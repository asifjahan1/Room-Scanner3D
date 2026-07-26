package com.app.liddar.geometry

import kotlin.math.*

/**
 * High-precision 3D vector representation used for AR point tracking and geometry processing.
 */
data class Vector3(
    val x: Float,
    val y: Float,
    val z: Float
) {
    operator fun plus(other: Vector3) = Vector3(x + other.x, y + other.y, z + other.z)
    operator fun minus(other: Vector3) = Vector3(x - other.x, y - other.y, z - other.z)
    operator fun times(scalar: Float) = Vector3(x * scalar, y * scalar, z * scalar)
    operator fun div(scalar: Float) = if (scalar != 0f) Vector3(x / scalar, y / scalar, z / scalar) else this

    fun dot(other: Vector3): Float = x * other.x + y * other.y + z * other.z
    
    fun cross(other: Vector3): Vector3 = Vector3(
        y * other.z - z * other.y,
        z * other.x - x * other.z,
        x * other.y - y * other.x
    )

    fun length(): Float = sqrt(x * x + y * y + z * z)
    
    fun length2D(): Float = sqrt(x * x + z * z)

    fun normalized(): Vector3 {
        val len = length()
        return if (len > 0.00001f) this / len else Vector3(0f, 0f, 0f)
    }

    fun distanceTo(other: Vector3): Float {
        val dx = x - other.x
        val dy = y - other.y
        val dz = z - other.z
        return sqrt(dx * dx + dy * dy + dz * dz)
    }

    fun distanceTo2D(other: Vector3): Float {
        val dx = x - other.x
        val dz = z - other.z
        return sqrt(dx * dx + dz * dz)
    }

    fun to2D(): Vector2 = Vector2(x, z)

    companion object {
        val ZERO = Vector3(0f, 0f, 0f)
        val UP = Vector3(0f, 1f, 0f)
    }
}

/**
 * 2D vector for horizontal floor plane calculations (X/Z coordinates in AR space).
 */
data class Vector2(
    val x: Float,
    val z: Float
) {
    operator fun plus(other: Vector2) = Vector2(x + other.x, z + other.z)
    operator fun minus(other: Vector2) = Vector2(x - other.x, z - other.z)
    operator fun times(scalar: Float) = Vector2(x * scalar, z * scalar)
    operator fun div(scalar: Float) = if (scalar != 0f) Vector2(x / scalar, z / scalar) else this

    fun dot(other: Vector2): Float = x * other.x + z * other.z
    fun cross(other: Vector2): Float = x * other.z - z * other.x
    fun length(): Float = sqrt(x * x + z * z)

    fun normalized(): Vector2 {
        val len = length()
        return if (len > 0.00001f) this / len else Vector2(0f, 0f)
    }

    fun distanceTo(other: Vector2): Float {
        val dx = x - other.x
        val dz = z - other.z
        return sqrt(dx * dx + dz * dz)
    }
}

/**
 * Represents an un-extruded straight wall line segment on the horizontal plane.
 */
data class LineSegment2D(
    val start: Vector2,
    val end: Vector2
) {
    val length: Float get() = start.distanceTo(end)

    val direction: Vector2 get() = (end - start).normalized()

    val angleRad: Float get() = atan2((end.z - start.z).toDouble(), (end.x - start.x).toDouble()).toFloat()

    val angleDeg: Float get() = Math.toDegrees(angleRad.toDouble()).toFloat()

    /**
     * Calculates orthogonal distance from any point in the floor plane to this infinite line.
     */
    fun orthogonalDistance(point: Vector2): Float {
        val lineDir = end - start
        val len = lineDir.length()
        if (len < 0.0001f) return start.distanceTo(point)
        val numerator = abs((end.z - start.z) * point.x - (end.x - start.x) * point.z + end.x * start.z - end.z * start.x)
        return numerator / len
    }

    /**
     * Projects a point onto the line segment (clamped between start and end vertices).
     */
    fun projectPoint(point: Vector2): Vector2 {
        val lineVec = end - start
        val lenSq = lineVec.x * lineVec.x + lineVec.z * lineVec.z
        if (lenSq < 0.00001f) return start
        val t = ((point.x - start.x) * lineVec.x + (point.z - start.z) * lineVec.z) / lenSq
        val clampedT = t.coerceIn(0f, 1f)
        return start + lineVec * clampedT
    }

    /**
     * Calculates 2D line intersection between this line and another infinite line.
     * Returns null if lines are parallel.
     */
    fun intersection(other: LineSegment2D): Vector2? {
        val x1 = start.x
        val y1 = start.z
        val x2 = end.x
        val y2 = end.z
        val x3 = other.start.x
        val y3 = other.start.z
        val x4 = other.end.x
        val y4 = other.end.z

        val denom = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
        if (abs(denom) < 0.0001f) return null

        val px = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) / denom
        val py = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) / denom
        return Vector2(px, py)
    }
}

/**
 * Production extruded wall structural representation.
 */
data class ExtrudedWall(
    val start: Vector3,
    val end: Vector3,
    val height: Float,
    val thickness: Float,
    val isHeightMeasured: Boolean
) {
    val length: Float get() = start.distanceTo2D(end)
}

/**
 * Closed or open room floor boundary polygon.
 */
data class FloorPolygon(
    val vertices: List<Vector3>,
    val isClosed: Boolean
) {
    /**
     * Calculates true horizontal surface area using the shoelace formula on X/Z plane.
     */
    val area: Float get() {
        if (vertices.size < 3 || !isClosed) return 0f
        var total = 0f
        val n = vertices.size
        for (i in 0 until n) {
            val j = (i + 1) % n
            total += vertices[i].x * vertices[j].z
            total -= vertices[j].x * vertices[i].z
        }
        return abs(total) / 2f
    }

    val perimeter: Float get() {
        if (vertices.size < 2) return 0f
        var total = 0f
        val count = if (isClosed) vertices.size else vertices.size - 1
        for (i in 0 until count) {
            val next = (i + 1) % vertices.size
            total += vertices[i].distanceTo2D(vertices[next])
        }
        return total
    }
}
