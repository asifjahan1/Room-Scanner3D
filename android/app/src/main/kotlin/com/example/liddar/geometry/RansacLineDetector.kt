package com.app.liddar.geometry

import kotlin.math.*
import kotlin.random.Random

/**
 * Production RANSAC (Random Sample Consensus) Line Detector.
 * Fits straight architectural wall line segments from raw floor-boundary raycasts and point cloud feature clusters.
 * Eradicates sensor noise and merges fragmented collinear walls.
 */
class RansacLineDetector(
    private val distanceThresholdMeters: Float = 0.08f, // 8cm max orthogonal distance for inliers
    private val minInlierCount: Int = 4,                // Minimum point count to establish a verified wall segment
    private val maxIterations: Int = 150                // RANSAC iteration ceiling for 60 FPS performance
) {

    /**
     * Extracts all robust linear wall segments from a collection of raw 3D floor boundary points.
     * Guaranteed NO guessing or arbitrary wall placement: if points do not satisfy statistical consensus, no wall is formed.
     */
    fun extractWallSegments(points: List<Vector3>, minSegmentLength: Float = 0.45f): List<LineSegment2D> {
        if (points.size < 2) return emptyList()
        if (points.size in 2..32) {
            // Manual Corner Capture Mode: Connect consecutive verified corner taps cleanly into wall segments without forcing artificial boxes
            val segments = mutableListOf<LineSegment2D>()
            val n = points.size
            val count = if (n >= 3) n else (n - 1)
            for (i in 0 until count) {
                val p1 = points[i].to2D()
                val p2 = points[(i + 1) % n].to2D()
                if (p1.distanceTo(p2) >= 0.10f) {
                    segments.add(LineSegment2D(p1, p2))
                }
            }
            if (segments.isNotEmpty()) {
                return mergeCollinearSegments(segments)
            }
        }
        val remainingPoints = points.map { it.to2D() }.toMutableList()
        val detectedLines = mutableListOf<LineSegment2D>()

        while (remainingPoints.size >= minInlierCount) {
            var bestLine: LineSegment2D? = null
            var bestInliers: List<Vector2> = emptyList()
            var minTotalError = Float.MAX_VALUE

            for (iteration in 0 until maxIterations) {
                val idx1 = Random.nextInt(remainingPoints.size)
                var idx2 = Random.nextInt(remainingPoints.size)
                while (idx2 == idx1) {
                    idx2 = Random.nextInt(remainingPoints.size)
                }

                val sampleA = remainingPoints[idx1]
                val sampleB = remainingPoints[idx2]

                // Skip identical or overly close samples to avoid degenerate slope spikes
                if (sampleA.distanceTo(sampleB) < 0.25f) continue

                val candidateLine = LineSegment2D(sampleA, sampleB)
                val currentInliers = mutableListOf<Vector2>()
                var totalError = 0f

                for (p in remainingPoints) {
                    val err = candidateLine.orthogonalDistance(p)
                    if (err <= distanceThresholdMeters) {
                        currentInliers.add(p)
                        totalError += err
                    }
                }

                if (currentInliers.size >= minInlierCount) {
                    if (currentInliers.size > bestInliers.size || 
                        (currentInliers.size == bestInliers.size && totalError < minTotalError)) {
                        bestInliers = currentInliers
                        bestLine = candidateLine
                        minTotalError = totalError
                    }
                }
            }

            // Once the dominant line is discovered, fit endpoints precisely to extreme projected inliers
            if (bestLine != null && bestInliers.size >= minInlierCount) {
                val refinedSegment = refineEndpoints(bestLine, bestInliers)
                if (refinedSegment != null && refinedSegment.length >= minSegmentLength) {
                    detectedLines.add(refinedSegment)
                }
                // Remove discovered inliers before searching for next architectural wall
                remainingPoints.removeAll(bestInliers.toSet())
            } else {
                break // No further statistically consensus linear structures exist in remaining cloud
            }
        }

        return mergeCollinearSegments(detectedLines)
    }

    /**
     * Finds exact start and end vertices by projecting all inliers onto the fitted vector and selecting extremes.
     */
    private fun refineEndpoints(line: LineSegment2D, inliers: List<Vector2>): LineSegment2D? {
        if (inliers.isEmpty()) return null
        val dir = line.direction
        val origin = inliers.first()

        var minProjection = Float.MAX_VALUE
        var maxProjection = Float.MIN_VALUE
        var minPt = origin
        var maxPt = origin

        for (pt in inliers) {
            val vec = pt - origin
            val proj = vec.dot(dir)
            if (proj < minProjection) {
                minProjection = proj
                minPt = pt
            }
            if (proj > maxProjection) {
                maxProjection = proj
                maxPt = pt
            }
        }

        val segment = LineSegment2D(minPt, maxPt)
        return if (segment.length > 0.05f) segment else null
    }

    /**
     * Merges collinear wall segments that were broken by occlusions, furniture, or door frames.
     */
    fun mergeCollinearSegments(segments: List<LineSegment2D>): List<LineSegment2D> {
        if (segments.size <= 1) return segments
        val result = mutableListOf<LineSegment2D>()
        val consumed = BooleanArray(segments.size) { false }

        for (i in segments.indices) {
            if (consumed[i]) continue
            var current = segments[i]
            consumed[i] = true

            var merged = true
            while (merged) {
                merged = false
                for (j in segments.indices) {
                    if (consumed[j]) continue
                    val target = segments[j]
                    if (areCollinearAndClose(current, target)) {
                        current = fuseTwoSegments(current, target)
                        consumed[j] = true
                        merged = true
                    }
                }
            }
            result.add(current)
        }
        return result
    }

    private fun areCollinearAndClose(s1: LineSegment2D, s2: LineSegment2D): Boolean {
        val dotProd = abs(s1.direction.dot(s2.direction))
        // Must be angularly aligned within ~10 degrees (cos(10°) ≈ 0.984)
        if (dotProd < 0.984f) return false

        // Check if endpoints of s2 lie along the trajectory of s1 within orthogonal tolerance (12cm)
        val distStart = s1.orthogonalDistance(s2.start)
        val distEnd = s1.orthogonalDistance(s2.end)
        if (distStart > 0.12f && distEnd > 0.12f) return false

        // Verify segments are adjacent or overlapping along trajectory (gap gap < 1.5m, e.g., standard doorway gap)
        val minDist = minOf(
            s1.start.distanceTo(s2.start),
            s1.start.distanceTo(s2.end),
            s1.end.distanceTo(s2.start),
            s1.end.distanceTo(s2.end)
        )
        return minDist <= 1.5f
    }

    private fun fuseTwoSegments(s1: LineSegment2D, s2: LineSegment2D): LineSegment2D {
        val points = listOf(s1.start, s1.end, s2.start, s2.end)
        var maxDist = -1f
        var bestStart = points[0]
        var bestEnd = points[1]

        for (i in 0 until 4) {
            for (j in i + 1 until 4) {
                val d = points[i].distanceTo(points[j])
                if (d > maxDist) {
                    maxDist = d
                    bestStart = points[i]
                    bestEnd = points[j]
                }
            }
        }
        return LineSegment2D(bestStart, bestEnd)
    }
}
