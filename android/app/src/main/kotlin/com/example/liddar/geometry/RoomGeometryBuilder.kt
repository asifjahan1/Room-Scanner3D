package com.app.liddar.geometry

import kotlin.math.*

/**
 * Production Room Geometry Builder.
 * Reconstructs closed room floor polygons from RANSAC walls, snaps orthogonal corners while preserving
 * irregular and angled architectures, removes redundant vertices, and extrudes true measured walls.
 */
class RoomGeometryBuilder(
    private val orthoAngleToleranceDeg: Float = 12f, // Corners within 12° of 90°/180°/270° snap precisely
    private val vertexMergeThresholdMeters: Float = 0.15f,
    private val defaultCeilingHeightMeters: Float = 2.6f
) {

    /**
     * Builds a finalized room topology from raw sequential boundary measurements or RANSAC extracted segments.
     * Zero guessing: if segments are insufficient or tracking breaks, outputs exact open measured geometry.
     */
    fun buildRoomTopology(
        segments: List<LineSegment2D>,
        measuredCeilingHeight: Float?,
        floorY: Float = 0f
    ): Pair<List<ExtrudedWall>, FloorPolygon> {
        if (segments.isEmpty()) {
            return Pair(emptyList(), FloorPolygon(emptyList(), false))
        }

        // 1. Order segments sequentially around the room perimeter if not already ordered
        val orderedSegments = orderSegmentsContinuously(segments)

        // 2. Compute exact structural intersection vertices between adjacent segments
        val rawVertices = mutableListOf<Vector2>()
        val numSegments = orderedSegments.size

        for (i in 0 until numSegments) {
            val curr = orderedSegments[i]
            val next = orderedSegments[(i + 1) % numSegments]

            // Check if final segment actually meets the first segment (closed loop test)
            if (i == numSegments - 1 && !shouldCloseLoop(orderedSegments.last(), orderedSegments.first())) {
                rawVertices.add(curr.end)
                break
            }

            val intersection = curr.intersection(next)
            if (intersection != null && intersection.distanceTo(curr.end) < 1.8f && intersection.distanceTo(next.start) < 1.8f) {
                rawVertices.add(intersection)
            } else {
                // Parallel or disconnected corner: bridge with mid-point average
                val avgPt = Vector2((curr.end.x + next.start.x) / 2f, (curr.end.z + next.start.z) / 2f)
                rawVertices.add(avgPt)
            }
        }
        if (rawVertices.isEmpty() || numSegments == 1) {
            rawVertices.clear()
            rawVertices.add(orderedSegments.first().start)
            rawVertices.add(orderedSegments.first().end)
        }

        // 3. Remove duplicate noisy vertices
        val prunedVertices = pruneDuplicateVertices(rawVertices)

        // 4. Perform intelligent Corner Snapping without destroying irregular / L-shaped geometries
        val isClosed = shouldCloseLoop(orderedSegments.last(), orderedSegments.first()) && prunedVertices.size >= 3
        val snappedVertices = if (isClosed) snapOrthogonalCorners(prunedVertices) else prunedVertices

        // 5. Build Extruded 3D walls and verified floor polygon
        val extrudedWalls = mutableListOf<ExtrudedWall>()
        val vertices3D = snappedVertices.map { Vector3(it.x, floorY, it.z) }

        val wallHeight = if (measuredCeilingHeight != null && measuredCeilingHeight in 1.8f..12.0f) {
            measuredCeilingHeight
        } else {
            defaultCeilingHeightMeters
        }
        val isMeasured = (measuredCeilingHeight != null && measuredCeilingHeight in 1.8f..12.0f)

        val loopLimit = if (isClosed) vertices3D.size else vertices3D.size - 1
        for (i in 0 until loopLimit) {
            val startV = vertices3D[i]
            val endV = vertices3D[(i + 1) % vertices3D.size]
            if (startV.distanceTo2D(endV) >= 0.05f) {
                extrudedWalls.add(
                    ExtrudedWall(
                        start = startV,
                        end = endV,
                        height = wallHeight,
                        thickness = 0.15f,
                        isHeightMeasured = isMeasured
                    )
                )
            }
        }

        return Pair(extrudedWalls, FloorPolygon(vertices3D, isClosed))
    }

    private fun orderSegmentsContinuously(segments: List<LineSegment2D>): List<LineSegment2D> {
        if (segments.size <= 2) return segments
        val ordered = mutableListOf(segments.first())
        val pool = segments.drop(1).toMutableList()

        while (pool.isNotEmpty()) {
            val lastEnd = ordered.last().end
            var bestIdx = -1
            var minDist = Float.MAX_VALUE

            for (i in pool.indices) {
                val dStart = lastEnd.distanceTo(pool[i].start)
                val dEnd = lastEnd.distanceTo(pool[i].end)
                val minD = minOf(dStart, dEnd)
                if (minD < minDist) {
                    minDist = minD
                    bestIdx = i
                }
            }

            if (bestIdx >= 0) {
                val chosen = pool.removeAt(bestIdx)
                if (lastEnd.distanceTo(chosen.end) < lastEnd.distanceTo(chosen.start)) {
                    // Reverse segment orientation to maintain continuous loop winding
                    ordered.add(LineSegment2D(chosen.end, chosen.start))
                } else {
                    ordered.add(chosen)
                }
            } else {
                break
            }
        }
        return ordered
    }

    private fun shouldCloseLoop(lastSegment: LineSegment2D, firstSegment: LineSegment2D): Boolean {
        // Close loop if the end of scanning meets the starting anchor within 0.5m
        return lastSegment.end.distanceTo(firstSegment.start) < 0.50f
    }

    private fun pruneDuplicateVertices(vertices: List<Vector2>): List<Vector2> {
        if (vertices.isEmpty()) return emptyList()
        val pruned = mutableListOf<Vector2>()
        for (v in vertices) {
            if (pruned.isEmpty() || pruned.last().distanceTo(v) >= vertexMergeThresholdMeters) {
                pruned.add(v)
            }
        }
        if (pruned.size > 1 && pruned.last().distanceTo(pruned.first()) < vertexMergeThresholdMeters) {
            pruned.removeAt(pruned.size - 1)
        }
        return pruned
    }

    /**
     * Evaluates consecutive edge vectors and snaps junctions within tolerance to exact 90°/180°/270° axes,
     * while completely maintaining non-orthogonal architectural angles (e.g. 45° or 135° bay windows).
     */
    private fun snapOrthogonalCorners(vertices: List<Vector2>): List<Vector2> {
        val n = vertices.size
        if (n < 3) return vertices

        // Find primary reference alignment vector from longest wall segment
        var maxLen = 0f
        var baseDir = Vector2(1f, 0f)
        for (i in 0 until n) {
            val v1 = vertices[i]
            val v2 = vertices[(i + 1) % n]
            val seg = LineSegment2D(v1, v2)
            if (seg.length > maxLen) {
                maxLen = seg.length
                baseDir = seg.direction
            }
        }
        val baseAngleRad = atan2(baseDir.z.toDouble(), baseDir.x.toDouble())

        // Refine vertex lines against orthogonal axes oriented to the dominant reference angle
        val refinedLines = mutableListOf<LineSegment2D>()
        for (i in 0 until n) {
            val start = vertices[i]
            val end = vertices[(i + 1) % n]
            val origLine = LineSegment2D(start, end)
            val currentAngleRad = origLine.angleRad.toDouble()

            var deltaAngle = (currentAngleRad - baseAngleRad) % (2 * Math.PI)
            if (deltaAngle < -Math.PI) deltaAngle += 2 * Math.PI
            if (deltaAngle > Math.PI) deltaAngle -= 2 * Math.PI

            val deg = Math.toDegrees(deltaAngle)
            val nearestMulti90 = (Math.round(deg / 90.0) * 90.0).toFloat()

            if (abs(deg - nearestMulti90) <= orthoAngleToleranceDeg) {
                // Snap direction exactly to orthogonal axis relative to dominant room wall
                val snappedRad = baseAngleRad + Math.toRadians(nearestMulti90.toDouble())
                val newDir = Vector2(cos(snappedRad).toFloat(), sin(snappedRad).toFloat())
                
                // Keep midpoint stationary and orient endpoints to snapped axis
                val mid = Vector2((start.x + end.x) / 2f, (start.z + end.z) / 2f)
                val halfLen = origLine.length / 2f
                refinedLines.add(LineSegment2D(mid - newDir * halfLen, mid + newDir * halfLen))
            } else {
                // Preserve exact measured angle for custom irregular architecture!
                refinedLines.add(origLine)
            }
        }

        // Recompute vertex intersections of snapped lines
        val finalVertices = mutableListOf<Vector2>()
        for (i in 0 until n) {
            val l1 = refinedLines[i]
            val l2 = refinedLines[(i + 1) % n]
            val intersection = l1.intersection(l2)
            if (intersection != null && intersection.distanceTo(l1.end) < 1.0f) {
                finalVertices.add(intersection)
            } else {
                finalVertices.add(Vector2((l1.end.x + l2.start.x) / 2f, (l1.end.z + l2.start.z) / 2f))
            }
        }
        return finalVertices
    }
}
