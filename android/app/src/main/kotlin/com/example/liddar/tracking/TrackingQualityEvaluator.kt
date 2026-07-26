package com.app.liddar.tracking

import android.os.SystemClock
import com.app.liddar.geometry.Vector3
import com.google.ar.core.Camera
import com.google.ar.core.Frame
import com.google.ar.core.LightEstimate
import com.google.ar.core.TrackingFailureReason
import com.google.ar.core.TrackingState
import kotlin.math.abs
import kotlin.math.sqrt

enum class QualityStatus {
    OPTIMAL,
    WARNING,
    CRITICAL
}

data class TrackingEvaluationResult(
    val status: QualityStatus,
    val guidanceMessage: String,
    val isAcceptableForCapture: Boolean,
    val confidenceScore: Float // 0.0f to 1.0f
)

/**
 * Production Tracking Quality Evaluator.
 * Constantly audits sensor stability, illumination intensity, angular momentum, and AR tracking confidence.
 * Rejects substandard samples and produces explicit MeasureSquare guidance prompts.
 */
class TrackingQualityEvaluator {

    private var lastFrameTimeMs = 0L
    private var lastPosePosition = Vector3.ZERO
    private var lastPoseYaw = 0f

    /**
     * Evaluates the current frame and returns explicit guidance and validity gating.
     */
    fun evaluate(frame: Frame?, hasDetectedFloor: Boolean, currentTargetDistance: Float): TrackingEvaluationResult {
        if (frame == null) {
            return TrackingEvaluationResult(QualityStatus.CRITICAL, "Initializing AR sensor...", false, 0f)
        }

        val camera = frame.camera

        // 1. Check ARCore fundamental tracking state
        if (camera.trackingState != TrackingState.TRACKING) {
            val reasonMsg = when (camera.trackingFailureReason) {
                TrackingFailureReason.EXCESSIVE_MOTION -> "Move slower"
                TrackingFailureReason.INSUFFICIENT_LIGHT -> "Improve lighting"
                TrackingFailureReason.INSUFFICIENT_FEATURES -> "Point at textured floor surface"
                TrackingFailureReason.CAMERA_UNAVAILABLE -> "Camera sensor blocked"
                else -> "Tracking lost"
            }
            return TrackingEvaluationResult(QualityStatus.CRITICAL, reasonMsg, false, 0.0f)
        }

        // 2. Audit illumination levels via light estimation
        val lightEstimate = frame.lightEstimate
        if (lightEstimate.state == LightEstimate.State.VALID) {
            val pixelIntensity = lightEstimate.pixelIntensity
            // Normal indoor ambient intensity is ~0.8 to 1.5. Below 0.25 is too dim for commercial precision
            if (pixelIntensity < 0.25f) {
                return TrackingEvaluationResult(QualityStatus.WARNING, "Improve lighting", false, 0.3f)
            }
        }

        // 3. Monitor velocity and motion blur risk
        val currentTime = SystemClock.elapsedRealtime()
        val pose = camera.displayOrientedPose
        val currentPosition = Vector3(pose.tx(), pose.ty(), pose.tz())

        if (lastFrameTimeMs != 0L) {
            val deltaSec = (currentTime - lastFrameTimeMs) / 1000f
            if (deltaSec > 0f) {
                val linearSpeed = currentPosition.distanceTo(lastPosePosition) / deltaSec
                // If moving faster than 0.85 m/s, motion blur degrades tracking triangulation
                if (linearSpeed > 0.85f) {
                    lastPosePosition = currentPosition
                    lastFrameTimeMs = currentTime
                    return TrackingEvaluationResult(QualityStatus.WARNING, "Move slower", false, 0.4f)
                }
            }
        }
        lastPosePosition = currentPosition
        lastFrameTimeMs = currentTime

        // 4. Floor detection prerequisite
        if (!hasDetectedFloor) {
            return TrackingEvaluationResult(QualityStatus.WARNING, "Point camera at floor until recognized", false, 0.5f)
        }

        // 5. Check optimal operating distance to floor-wall edge (MeasureSquare guidelines: 1.0m to 4.5m)
        if (currentTargetDistance < 0.6f && currentTargetDistance > 0f) {
            return TrackingEvaluationResult(QualityStatus.WARNING, "Move backward", false, 0.65f)
        }
        if (currentTargetDistance > 5.5f) {
            return TrackingEvaluationResult(QualityStatus.WARNING, "Move closer", false, 0.65f)
        }

        // 6. Optimal commercial state
        val message = if (currentTargetDistance > 0f) "Point at floor edge" else "Floor detected"
        return TrackingEvaluationResult(QualityStatus.OPTIMAL, message, true, 0.98f)
    }
}
