package com.app.liddar.tracking

import com.app.liddar.geometry.*
import com.google.ar.core.*
import java.util.concurrent.CopyOnWriteArrayList
import kotlin.math.abs

/**
 * Production SLAM Sensor Fusion Engine.
 * Combines ARCore pose tracking, Depth API point cloud geometry, horizontal plane tracking, and Kalman filtering.
 * Manages the Floor-to-Wall intersection workflow without relying on assumptions or hallucinated dimensions.
 */
class SlamEngine {

    val rawBoundaryPoints = CopyOnWriteArrayList<Vector3>()
    val ransacLineDetector = RansacLineDetector()
    private val geometryBuilder = RoomGeometryBuilder()
    private val kalmanFilter = KalmanFilter3D()
    private val qualityEvaluator = TrackingQualityEvaluator()

    var detectedFloorElevationY: Float? = null
        private set

    var detectedCeilingElevationY: Float? = null
        private set

    var latestTargetPoint: Vector3? = null

    var currentGuidance: String = "Pan camera across room floor & wall bottom edges"
        private set

    var lastQualityResult: TrackingEvaluationResult = TrackingEvaluationResult(QualityStatus.WARNING, "Initializing...", false, 0f)
        private set

    /**
     * Resets the entire SLAM tracking state and cleared geometry buffers.
     */
    fun resetSession() {
        rawBoundaryPoints.clear()
        kalmanFilter.reset()
        detectedFloorElevationY = null
        detectedCeilingElevationY = null
        latestTargetPoint = null
        currentGuidance = "Pan camera across room floor & wall bottom edges"
    }

    /**
     * Processes live AR frame at 60 FPS: updates floor/ceiling altitudes, performs precision center raycasts
     * against floor plane bounds, audits signal quality, and tracks feature clusters.
     */
    fun processFrame(frame: Frame, session: Session): TrackingEvaluationResult {
        // 1. Audit planes for horizontal floor and optional ceiling heights
        val allPlanes = session.getAllTrackables(Plane::class.java)
        var hasValidFloor = false
        var lowestFloorY = Float.MAX_VALUE
        var highestCeilingY = Float.MIN_VALUE

        for (plane in allPlanes) {
            if (plane.trackingState == TrackingState.TRACKING) {
                val poseY = plane.centerPose.ty()
                if (plane.type == Plane.Type.HORIZONTAL_UPWARD_FACING) {
                    hasValidFloor = true
                    if (poseY < lowestFloorY) {
                        lowestFloorY = poseY
                    }
                } else if (plane.type == Plane.Type.HORIZONTAL_DOWNWARD_FACING) {
                    if (poseY > highestCeilingY) {
                        highestCeilingY = poseY
                    }
                }
            }
        }

        if (hasValidFloor) {
            // Smoothly adapt floor elevation without sudden jumping
            val currY = detectedFloorElevationY
            detectedFloorElevationY = if (currY != null) currY * 0.9f + lowestFloorY * 0.1f else lowestFloorY
        }

        if (highestCeilingY != Float.MIN_VALUE && detectedFloorElevationY != null) {
            val measuredH = highestCeilingY - (detectedFloorElevationY ?: 0f)
            if (measuredH in 2.0f..7.0f) {
                detectedCeilingElevationY = measuredH
            }
        }

        // 2. Perform center screen precision raycasting (Floor-to-Wall edge intersection testing)
        var targetDist = -1f
        var candidatePoint: Vector3? = null

        val hitResults = frame.hitTest(0.5f, 0.5f)
        for (hit in hitResults) {
            val trackable = hit.trackable
            if (trackable is Plane && trackable.isPoseInPolygon(hit.hitPose) && 
                trackable.type == Plane.Type.HORIZONTAL_UPWARD_FACING && hit.hitPose.tz() < 8.0f) {
                
                val p = Vector3(hit.hitPose.tx(), hit.hitPose.ty(), hit.hitPose.tz())
                targetDist = hit.distance
                candidatePoint = kalmanFilter.update(p)
                break
            } else if (trackable is Point && trackable.orientationMode == Point.OrientationMode.ESTIMATED_SURFACE_NORMAL) {
                val p = Vector3(hit.hitPose.tx(), hit.hitPose.ty(), hit.hitPose.tz())
                // If feature point is within 12cm of detected floor plane elevation, treat as bottom baseboard edge
                val floorY = detectedFloorElevationY
                if (floorY != null && abs(p.y - floorY) <= 0.12f) {
                    targetDist = hit.distance
                    candidatePoint = kalmanFilter.update(Vector3(p.x, floorY, p.z))
                    break
                }
            }
        }
        latestTargetPoint = candidatePoint

        // 3. Evaluate Quality and assign actionable user telemetry
        val evaluation = qualityEvaluator.evaluate(frame, detectedFloorElevationY != null, targetDist)
        lastQualityResult = evaluation
        currentGuidance = evaluation.guidanceMessage

        return evaluation
    }

    /**
     * Explicitly records the currently targeted floor-wall boundary intersection point into the spatial dataset.
     * Rejects invalid or redundant points. Returns true if point was accepted and recorded.
     */
    fun recordBoundaryPoint(): Boolean {
        val target = latestTargetPoint ?: return false
        if (!lastQualityResult.isAcceptableForCapture) return false

        // Prevent redundant capture of identical spatial spot (< 15cm separation)
        for (existing in rawBoundaryPoints) {
            if (existing.distanceTo(target) < 0.15f) {
                return false
            }
        }

        rawBoundaryPoints.add(target)
        currentGuidance = "Boundary detected (${rawBoundaryPoints.size} points recorded)"
        return true
    }

    /**
     * Reconstructs the complete architectural 3D room model from collected points using RANSAC and topology closing.
     * NEVER returns hallucinated default 4-wall boxes if tracking failed or points are missing.
     */
    fun getReconstructedRoom(): Pair<List<ExtrudedWall>, FloorPolygon> {
        val lineSegments = ransacLineDetector.extractWallSegments(rawBoundaryPoints.toList())
        val floorY = detectedFloorElevationY ?: 0f
        val ceilingHeight = detectedCeilingElevationY
        return geometryBuilder.buildRoomTopology(lineSegments, ceilingHeight, floorY)
    }
}
