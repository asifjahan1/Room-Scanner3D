package com.app.liddar

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.opengl.GLES11Ext
import android.opengl.GLES20
import android.opengl.GLSurfaceView
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import com.google.ar.core.*
import com.google.ar.core.exceptions.*
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer
import java.util.*
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10
import kotlin.math.abs
import kotlin.math.sqrt

/**
 * Factory for creating ARCore scanner platform views
 */
class ArCoreScannerViewFactory(
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    @Suppress("UNCHECKED_CAST")
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String, Any>
        return ArCoreScannerPlatformView(context, viewId, creationParams, messenger)
    }
}

/**
 * ARCore-based room scanner platform view for Android.
 * Renders live ARCore camera feed via OpenGL ES and measures real room dimensions.
 */
class ArCoreScannerPlatformView(
    private val context: Context,
    private val viewId: Int,
    private val creationParams: Map<String, Any>?,
    messenger: BinaryMessenger
) : PlatformView, GLSurfaceView.Renderer {

    private val containerView: FrameLayout = FrameLayout(context)
    private val glSurfaceView: GLSurfaceView = GLSurfaceView(context)
    private val overlayView: ArCoreScannerView = ArCoreScannerView(context)
    private val channel: MethodChannel

    // AR Session & Camera Texture
    private var isScanning = false
    private var isSessionResumed = false
    private var arSession: Session? = null
    private var cameraTextureId: Int = -1
    private var backgroundRenderer: CameraBackgroundRenderer? = null

    // Tracked room geometry
    private val detectedPlanes = mutableListOf<DetectedPlaneData>()
    private val wallSegments = mutableListOf<WallData>()
    private val openings = mutableListOf<OpeningData>()
    private val mainHandler = Handler(Looper.getMainLooper())

    init {
        channel = MethodChannel(messenger, "com.app.liddar/arcore_view_$viewId")

        // Crucial: Set Z-Order Media Overlay so GLSurfaceView renders visible over Flutter's view hierarchy
        glSurfaceView.setEGLContextClientVersion(2)
        glSurfaceView.setEGLConfigChooser(8, 8, 8, 8, 16, 0)
        glSurfaceView.setZOrderMediaOverlay(true)
        glSurfaceView.setRenderer(this)
        glSurfaceView.renderMode = GLSurfaceView.RENDERMODE_CONTINUOUSLY

        containerView.addView(glSurfaceView, FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        ))
        containerView.addView(overlayView, FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        ))

        setupMethodChannel()
        initializeARCore()
    }

    override fun getView(): View = containerView

    override fun dispose() {
        isScanning = false
        isSessionResumed = false
        glSurfaceView.onPause()
        try {
            arSession?.pause()
            arSession?.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }
        arSession = null
    }

    private fun setupMethodChannel() {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startScan" -> startScan(result)
                "stopScan" -> stopScan(result)
                "cancelScan" -> cancelScan(result)
                "isSupported" -> result.success(isARCoreSupported())
                else -> result.notImplemented()
            }
        }
    }

    private fun isARCoreSupported(): Boolean {
        return try {
            val availability = ArCoreApk.getInstance().checkAvailability(context)
            availability == ArCoreApk.Availability.SUPPORTED_INSTALLED ||
                    availability == ArCoreApk.Availability.SUPPORTED_APK_TOO_OLD ||
                    availability == ArCoreApk.Availability.SUPPORTED_NOT_INSTALLED
        } catch (e: Exception) {
            false
        }
    }

    private fun initializeARCore() {
        try {
            // Skip requestInstall since we don't have an Activity context readily available, 
            // and try to create the session directly.
            createARSession()
        } catch (e: Exception) {
            android.util.Log.e("ArCoreScannerView", "ARCore init failed", e)
            channel.invokeMethod("onScanError", mapOf("error" to "ARCore init error: ${e.message}"))
        }
    }

    private fun createARSession() {
        try {
            arSession = Session(context).apply {
                val config = Config(this).apply {
                    if (isDepthModeSupported(Config.DepthMode.AUTOMATIC)) {
                        depthMode = Config.DepthMode.AUTOMATIC
                    } else if (isDepthModeSupported(Config.DepthMode.RAW_DEPTH_ONLY)) {
                        depthMode = Config.DepthMode.RAW_DEPTH_ONLY
                    }
                    planeFindingMode = Config.PlaneFindingMode.HORIZONTAL_AND_VERTICAL
                    lightEstimationMode = Config.LightEstimationMode.ENVIRONMENTAL_HDR
                    focusMode = Config.FocusMode.AUTO
                }
                configure(config)
                resume()
                isSessionResumed = true
            }
        } catch (e: Exception) {
            android.util.Log.e("ArCoreScannerView", "Failed to create AR session", e)
            channel.invokeMethod("onScanError", mapOf("error" to "Failed to create AR session: ${e.message}"))
        }
    }

    private fun startScan(result: MethodChannel.Result) {
        try {
            if (!isSessionResumed) {
                arSession?.resume()
                isSessionResumed = true
            }
            glSurfaceView.onResume()
            isScanning = true
            detectedPlanes.clear()
            wallSegments.clear()
            openings.clear()

            overlayView.startScanning()
            result.success(true)
        } catch (e: Exception) {
            result.error("SCAN_ERROR", "Failed to start scan: ${e.message}", null)
        }
    }

    private fun stopScan(result: MethodChannel.Result) {
        isScanning = false
        overlayView.stopScanning()

        processDetectedPlanes()
        val scanResult = buildScanResult()

        mainHandler.post {
            channel.invokeMethod("onScanComplete", scanResult)
        }

        result.success(true)
    }

    private fun cancelScan(result: MethodChannel.Result) {
        isScanning = false
        overlayView.stopScanning()
        result.success(true)
    }

    // --- GLSurfaceView.Renderer Methods ---

    override fun onSurfaceCreated(gl: GL10?, config: EGLConfig?) {
        GLES20.glClearColor(0.0f, 0.0f, 0.0f, 1.0f)
        backgroundRenderer = CameraBackgroundRenderer()
        backgroundRenderer?.createOnGlThread()
        cameraTextureId = backgroundRenderer?.textureId ?: -1

        if (cameraTextureId != -1 && arSession != null) {
            try {
                arSession?.setCameraTextureName(cameraTextureId)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
        GLES20.glViewport(0, 0, width, height)
        arSession?.setDisplayGeometry(0, width, height)
    }

    override fun onDrawFrame(gl: GL10?) {
        GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT or GLES20.GL_DEPTH_BUFFER_BIT)

        val session = arSession ?: return

        try {
            if (cameraTextureId != -1) {
                session.setCameraTextureName(cameraTextureId)
            }
            val frame = session.update()

            // 1. ALWAYS draw live camera background (so camera is NEVER black!)
            backgroundRenderer?.draw(frame)

            // If user hasn't tapped start scan yet, camera is still live
            if (!isScanning) return

            // 2. Process tracked planes in real time
            val updatedPlanes = frame.getUpdatedTrackables(Plane::class.java)
            for (plane in updatedPlanes) {
                if (plane.trackingState == TrackingState.TRACKING) {
                    processPlane(plane)
                }
            }

            // 3. Dispatch real progress to Flutter & overlay
            val wallCount = wallSegments.size
            val progress = (wallCount.toFloat() / 4f).coerceAtMost(1f)
            val progressData = mapOf(
                "wallsDetected" to wallCount,
                "openingsDetected" to openings.size,
                "message" to if (wallCount > 0) "Scanning... $wallCount wall(s) detected" else "Point camera at room walls & surfaces",
                "percentage" to progress.toDouble()
            )

            mainHandler.post {
                channel.invokeMethod("onScanProgress", progressData)
                overlayView.updateWireframe(wallSegments)
            }

        } catch (e: Exception) {
            // Frame update exception
        }
    }

    private fun processPlane(plane: Plane) {
        val pose = plane.centerPose
        val extentX = plane.extentX.toDouble()
        val extentZ = plane.extentZ.toDouble()

        val planeTypeStr = when (plane.type) {
            Plane.Type.HORIZONTAL_UPWARD_FACING -> "floor"
            Plane.Type.HORIZONTAL_DOWNWARD_FACING -> "ceiling"
            Plane.Type.VERTICAL -> "wall"
            else -> "unknown"
        }

        val planeData = DetectedPlaneData(
            centerX = pose.tx().toDouble(),
            centerY = pose.ty().toDouble(),
            centerZ = pose.tz().toDouble(),
            extentX = extentX,
            extentZ = extentZ,
            type = planeTypeStr,
            polygon = emptyList()
        )

        val existingIndex = detectedPlanes.indexOfFirst { existing ->
            val dx = existing.centerX - planeData.centerX
            val dy = existing.centerY - planeData.centerY
            val dz = existing.centerZ - planeData.centerZ
            sqrt(dx * dx + dy * dy + dz * dz) < 0.4
        }

        if (existingIndex >= 0) {
            detectedPlanes[existingIndex] = planeData
        } else {
            detectedPlanes.add(planeData)
        }

        if (planeTypeStr == "wall" && extentX > 0.3) {
            convertPlaneToWall(planeData)
        }
    }

    private fun convertPlaneToWall(planeData: DetectedPlaneData) {
        val halfX = planeData.extentX / 2.0
        val height = if (planeData.extentZ > 0) planeData.extentZ else 2.5

        val startX = planeData.centerX - halfX
        val endX = planeData.centerX + halfX
        val startZ = planeData.centerZ
        val endZ = planeData.centerZ

        val wallData = WallData(
            startX = startX,
            startY = 0.0,
            startZ = startZ,
            endX = endX,
            endY = 0.0,
            endZ = endZ,
            height = height,
            thickness = 0.15
        )

        val existingIndex = wallSegments.indexOfFirst { existing ->
            val dStart = sqrt(
                (existing.startX - wallData.startX) * (existing.startX - wallData.startX) +
                        (existing.startZ - wallData.startZ) * (existing.startZ - wallData.startZ)
            )
            val dEnd = sqrt(
                (existing.endX - wallData.endX) * (existing.endX - wallData.endX) +
                        (existing.endZ - wallData.endZ) * (existing.endZ - wallData.endZ)
            )
            dStart < 0.6 && dEnd < 0.6
        }

        if (existingIndex >= 0) {
            wallSegments[existingIndex] = wallData
        } else {
            wallSegments.add(wallData)
        }
    }

    private fun processDetectedPlanes() {
        // Floor boundary calculation
    }

    private fun buildScanResult(): Map<String, Any> {
        val walls = wallSegments.map { wall ->
            mapOf(
                "start" to mapOf("x" to wall.startX, "y" to wall.startY, "z" to wall.startZ),
                "end" to mapOf("x" to wall.endX, "y" to wall.endY, "z" to wall.endZ),
                "height" to wall.height,
                "thickness" to wall.thickness
            )
        }

        val floorBoundary = mutableListOf<Map<String, Double>>()
        for (wall in wallSegments) {
            floorBoundary.add(mapOf("x" to wall.startX, "y" to 0.0, "z" to wall.startZ))
            floorBoundary.add(mapOf("x" to wall.endX, "y" to 0.0, "z" to wall.endZ))
        }

        var area = 0.0
        if (floorBoundary.size >= 3) {
            for (i in floorBoundary.indices) {
                val j = (i + 1) % floorBoundary.size
                val xi = floorBoundary[i]["x"] ?: 0.0
                val yi = floorBoundary[i]["z"] ?: 0.0
                val xj = floorBoundary[j]["x"] ?: 0.0
                val yj = floorBoundary[j]["z"] ?: 0.0
                area += xi * yj - xj * yi
            }
            area = abs(area) / 2.0
        }

        val perimeter = wallSegments.sumOf { wall ->
            sqrt(
                (wall.endX - wall.startX) * (wall.endX - wall.startX) +
                        (wall.endZ - wall.startZ) * (wall.endZ - wall.startZ)
            )
        }

        return mapOf(
            "id" to UUID.randomUUID().toString(),
            "walls" to walls,
            "openings" to emptyList<Any>(),
            "floorBoundary" to floorBoundary,
            "area" to area,
            "perimeter" to perimeter
        )
    }
}

/**
 * Renders ARCore camera feed as background texture in OpenGL ES 2.0 with transformed UV coordinates
 */
class CameraBackgroundRenderer {
    var textureId: Int = -1
        private set

    private var program: Int = 0
    private var aPosition: Int = 0
    private var aTexCoord: Int = 0

    private val quadCoords: FloatBuffer = ByteBuffer.allocateDirect(4 * 2 * 4)
        .order(ByteOrder.nativeOrder())
        .asFloatBuffer().apply {
            put(floatArrayOf(
                -1.0f, -1.0f,
                 1.0f, -1.0f,
                -1.0f,  1.0f,
                 1.0f,  1.0f
            ))
            position(0)
        }

    private val quadTexCoords: FloatBuffer = ByteBuffer.allocateDirect(4 * 2 * 4)
        .order(ByteOrder.nativeOrder())
        .asFloatBuffer().apply {
            put(floatArrayOf(
                0.0f, 1.0f,
                1.0f, 1.0f,
                0.0f, 0.0f,
                1.0f, 0.0f
            ))
            position(0)
        }

    private val quadTransformedTexCoords: FloatBuffer = ByteBuffer.allocateDirect(4 * 2 * 4)
        .order(ByteOrder.nativeOrder())
        .asFloatBuffer()

    fun createOnGlThread() {
        val textures = IntArray(1)
        GLES20.glGenTextures(1, textures, 0)
        textureId = textures[0]

        GLES20.glBindTexture(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, textureId)
        GLES20.glTexParameteri(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, GLES20.GL_TEXTURE_WRAP_S, GLES20.GL_CLAMP_TO_EDGE)
        GLES20.glTexParameteri(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, GLES20.GL_TEXTURE_WRAP_T, GLES20.GL_CLAMP_TO_EDGE)
        GLES20.glTexParameteri(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_NEAREST)
        GLES20.glTexParameteri(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, GLES20.GL_TEXTURE_MAG_FILTER, GLES20.GL_NEAREST)

        val vertexShaderCode = """
            attribute vec4 a_Position;
            attribute vec2 a_TexCoord;
            varying vec2 v_TexCoord;
            void main() {
               gl_Position = a_Position;
               v_TexCoord = a_TexCoord;
            }
        """.trimIndent()

        val fragmentShaderCode = """
            #extension GL_OES_EGL_image_external : require
            precision mediump float;
            varying vec2 v_TexCoord;
            uniform samplerExternalOES sTexture;
            void main() {
                gl_FragColor = texture2D(sTexture, v_TexCoord);
            }
        """.trimIndent()

        val vShader = loadShader(GLES20.GL_VERTEX_SHADER, vertexShaderCode)
        val fShader = loadShader(GLES20.GL_FRAGMENT_SHADER, fragmentShaderCode)

        program = GLES20.glCreateProgram()
        GLES20.glAttachShader(program, vShader)
        GLES20.glAttachShader(program, fShader)
        GLES20.glLinkProgram(program)

        aPosition = GLES20.glGetAttribLocation(program, "a_Position")
        aTexCoord = GLES20.glGetAttribLocation(program, "a_TexCoord")
    }

    fun draw(frame: Frame) {
        if (textureId == -1 || program == 0) return

        if (frame.hasDisplayGeometryChanged()) {
            frame.transformDisplayUvCoords(quadTexCoords, quadTransformedTexCoords)
        }

        GLES20.glDisable(GLES20.GL_DEPTH_TEST)
        GLES20.glDepthMask(false)

        GLES20.glUseProgram(program)

        GLES20.glActiveTexture(GLES20.GL_TEXTURE0)
        GLES20.glBindTexture(GLES11Ext.GL_TEXTURE_EXTERNAL_OES, textureId)

        GLES20.glVertexAttribPointer(aPosition, 2, GLES20.GL_FLOAT, false, 0, quadCoords)
        GLES20.glEnableVertexAttribArray(aPosition)

        quadTransformedTexCoords.position(0)
        GLES20.glVertexAttribPointer(aTexCoord, 2, GLES20.GL_FLOAT, false, 0, quadTransformedTexCoords)
        GLES20.glEnableVertexAttribArray(aTexCoord)

        GLES20.glDrawArrays(GLES20.GL_TRIANGLE_STRIP, 0, 4)

        GLES20.glDisableVertexAttribArray(aPosition)
        GLES20.glDisableVertexAttribArray(aTexCoord)
    }

    private fun loadShader(type: Int, shaderCode: String): Int {
        val shader = GLES20.glCreateShader(type)
        GLES20.glShaderSource(shader, shaderCode)
        GLES20.glCompileShader(shader)
        return shader
    }
}

/**
 * Transparent overlay view that renders room wireframe & real dimensions over the camera feed
 */
class ArCoreScannerView(context: Context) : View(context) {
    private val wireframePaint = Paint().apply {
        color = Color.CYAN
        style = Paint.Style.STROKE
        strokeWidth = 3f
        isAntiAlias = true
    }

    private val textPaint = Paint().apply {
        color = Color.WHITE
        textSize = 32f
        isAntiAlias = true
        setShadowLayer(4f, 2f, 2f, Color.BLACK)
    }

    private var isActive = false
    private var currentWalls = listOf<WallData>()

    init {
        setBackgroundColor(Color.TRANSPARENT)
    }

    fun startScanning() {
        isActive = true
        postInvalidate()
    }

    fun stopScanning() {
        isActive = false
    }

    fun updateWireframe(walls: List<WallData>) {
        currentWalls = walls.toList()
        postInvalidate()
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        if (!isActive) return

        val cx = width / 2f
        val cy = height / 2f
        val scale = width / 6f

        for ((index, wall) in currentWalls.withIndex()) {
            val sx = cx + (wall.startX * scale).toFloat()
            val sy = cy + (wall.startZ * scale).toFloat()
            val ex = cx + (wall.endX * scale).toFloat()
            val ey = cy + (wall.endZ * scale).toFloat()

            // Draw cyan wireframe wall line
            canvas.drawLine(sx, sy, ex, ey, wireframePaint)
            canvas.drawCircle(sx, sy, 8f, wireframePaint)
            canvas.drawCircle(ex, ey, 8f, wireframePaint)

            // Calculate real length in meters & feet
            val dx = wall.endX - wall.startX
            val dz = wall.endZ - wall.startZ
            val lengthMeters = sqrt(dx * dx + dz * dz)
            val lengthFeet = lengthMeters * 3.28084

            val label = String.format(Locale.US, "Wall %d: %.2fm (%.1fft)", index + 1, lengthMeters, lengthFeet)
            val mx = (sx + ex) / 2f
            val my = (sy + ey) / 2f - 10f
            canvas.drawText(label, mx - 80f, my, textPaint)
        }
    }
}

// Data models
data class DetectedPlaneData(
    val centerX: Double,
    val centerY: Double,
    val centerZ: Double,
    val extentX: Double,
    val extentZ: Double,
    val type: String,
    val polygon: List<FloatArray>
)

data class WallData(
    val startX: Double,
    val startY: Double,
    val startZ: Double,
    val endX: Double,
    val endY: Double,
    val endZ: Double,
    val height: Double,
    val thickness: Double
)

data class OpeningData(
    val type: String,
    val positionX: Double,
    val positionY: Double,
    val positionZ: Double,
    val width: Double,
    val height: Double
)
