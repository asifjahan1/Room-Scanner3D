package com.app.liddar.tracking

import com.app.liddar.geometry.Vector3
import kotlin.math.abs

/**
 * 3D Spatial and Temporal Kalman Filter.
 * Smooths raw ARCore raycast intersections and floor elevation estimates in real time,
 * eliminating high-frequency sensor noise, hand tremor, and coordinate jitter.
 */
class KalmanFilter3D(
    private val processNoise: Float = 0.005f,       // Q: Expected internal dynamics variation
    private val measurementNoise: Float = 0.04f,    // R: Expected sensor variance / coordinate jitter
    private val estimationError: Float = 1.0f       // P_init: Initial error covariance
) {
    private var stateX: Float = 0f
    private var stateY: Float = 0f
    private var stateZ: Float = 0f

    private var covX: Float = estimationError
    private var covY: Float = estimationError
    private var covZ: Float = estimationError

    private var isInitialized = false

    /**
     * Resets filter state when beginning a new wall segment or shifting attention.
     */
    fun reset() {
        isInitialized = false
    }

    /**
     * Predict and update 3D coordinates using optimal recursive gain weighting.
     */
    fun update(measurement: Vector3): Vector3 {
        if (!isInitialized) {
            stateX = measurement.x
            stateY = measurement.y
            stateZ = measurement.z
            covX = estimationError
            covY = estimationError
            covZ = estimationError
            isInitialized = true
            return measurement
        }

        // 1. Prediction step (assuming zero zero-acceleration kinematic model for wall boundary target)
        covX += processNoise
        covY += processNoise
        covZ += processNoise

        // 2. Kalman Gain calculation
        val gainX = covX / (covX + measurementNoise)
        val gainY = covY / (covY + measurementNoise)
        val gainZ = covZ / (covZ + measurementNoise)

        // 3. State update with innovative measurement residual
        stateX += gainX * (measurement.x - stateX)
        stateY += gainY * (measurement.y - stateY)
        stateZ += gainZ * (measurement.z - stateZ)

        // 4. Covariance update
        covX *= (1f - gainX)
        covY *= (1f - gainY)
        covZ *= (1f - gainZ)

        return Vector3(stateX, stateY, stateZ)
    }

    /**
     * Evaluates whether a newly observed raw coordinate deviates excessively from the current Kalman state,
     * signaling an invalid outlier hit (e.g., crosshair accidentally pointing out a window or doorway).
     */
    fun isOutlier(measurement: Vector3, thresholdMeters: Float = 0.35f): Boolean {
        if (!isInitialized) return false
        val dist = measurement.distanceTo(Vector3(stateX, stateY, stateZ))
        return dist > thresholdMeters
    }
}
