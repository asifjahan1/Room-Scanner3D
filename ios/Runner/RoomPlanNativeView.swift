import Flutter
import UIKit
import ARKit
import RoomPlan

@available(iOS 16.0, *)
class RoomPlanNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return RoomPlanNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

@available(iOS 16.0, *)
class RoomPlanNativeView: NSObject, FlutterPlatformView {
    private var roomCaptureView: RoomCaptureView?
    private var roomCaptureSession: RoomCaptureSession?
    private var containerView: UIView
    private var channel: FlutterMethodChannel
    private var finalResults: CapturedRoom?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        self.containerView = UIView(frame: frame)
        self.channel = FlutterMethodChannel(
            name: "com.app.liddar/roomplan_view_\(viewId)",
            binaryMessenger: messenger
        )
        super.init()

        setupView(frame: frame)
        setupMethodChannel()
    }

    func view() -> UIView {
        return containerView
    }

    private func setupView(frame: CGRect) {
        containerView.backgroundColor = .black

        // Create RoomCaptureView
        let captureView = RoomCaptureView(frame: containerView.bounds)
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        captureView.captureSession.delegate = self
        captureView.delegate = self

        containerView.addSubview(captureView)
        roomCaptureView = captureView
        roomCaptureSession = captureView.captureSession
    }

    private func setupMethodChannel() {
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "startScan":
                self?.startScan(result: result)
            case "stopScan":
                self?.stopScan(result: result)
            case "cancelScan":
                self?.cancelScan(result: result)
            case "isSupported":
                result(RoomCaptureSession.isSupported)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func startScan(result: @escaping FlutterResult) {
        let config = RoomCaptureSession.Configuration()
        roomCaptureSession?.run(configuration: config)
        result(true)
    }

    private func stopScan(result: @escaping FlutterResult) {
        roomCaptureSession?.stop()
        result(true)
    }

    private func cancelScan(result: @escaping FlutterResult) {
        roomCaptureSession?.stop()
        result(true)
    }
}

@available(iOS 16.0, *)
extension RoomPlanNativeView: RoomCaptureSessionDelegate {
    func captureSession(_ session: RoomCaptureSession, didUpdate room: CapturedRoom) {
        // Send progress update to Flutter
        var wallCount = 0
        var openingCount = 0

        for surface in room.walls {
            wallCount += 1
        }
        for _ in room.doors {
            openingCount += 1
        }
        for _ in room.windows {
            openingCount += 1
        }

        let progressData: [String: Any] = [
            "wallsDetected": wallCount,
            "openingsDetected": openingCount,
            "message": "Scanning in progress...",
            "percentage": min(Double(wallCount) / 4.0, 1.0)
        ]

        DispatchQueue.main.async {
            self.channel.invokeMethod("onScanProgress", arguments: progressData)
        }
    }

    func captureSession(_ session: RoomCaptureSession, didEndWith data: CapturedRoomData, error: Error?) {
        if let error = error {
            DispatchQueue.main.async {
                self.channel.invokeMethod("onScanError", arguments: ["error": error.localizedDescription])
            }
            return
        }

        // Process the captured room data
        Task {
            do {
                let finalRoom = try await session.process(data: data)
                self.finalResults = finalRoom
                await self.sendRoomData(room: finalRoom)
            } catch {
                DispatchQueue.main.async {
                    self.channel.invokeMethod("onScanError", arguments: ["error": error.localizedDescription])
                }
            }
        }
    }

    func captureSession(_ session: RoomCaptureSession, didProvide instruction: RoomCaptureSession.Instruction) {
        var message = ""
        switch instruction {
        case .moveCloseToWall:
            message = "Move closer to the wall"
        case .moveAwayFromWall:
            message = "Move away from the wall"
        case .slowDown:
            message = "Please slow down"
        case .turnOnLight:
            message = "Turn on more lights"
        case .normal:
            message = "Continue scanning"
        case .lowTexture:
            message = "Point at textured surfaces"
        @unknown default:
            message = "Continue scanning"
        }

        DispatchQueue.main.async {
            self.channel.invokeMethod("onInstruction", arguments: ["message": message])
        }
    }

    @MainActor
    private func sendRoomData(room: CapturedRoom) {
        var walls: [[String: Any]] = []
        var openings: [[String: Any]] = []
        var floorBoundary: [[String: Any]] = []

        // Extract wall data
        for wall in room.walls {
            let transform = wall.transform
            let dims = wall.dimensions

            let startX = Double(transform.columns.3.x) - Double(dims.x) / 2.0
            let startZ = Double(transform.columns.3.z) - Double(dims.z) / 2.0
            let endX = Double(transform.columns.3.x) + Double(dims.x) / 2.0
            let endZ = Double(transform.columns.3.z) + Double(dims.z) / 2.0

            walls.append([
                "start": ["x": startX, "y": 0.0, "z": startZ],
                "end": ["x": endX, "y": 0.0, "z": endZ],
                "height": Double(dims.y),
                "thickness": 0.15
            ])

            floorBoundary.append(["x": startX, "y": 0.0, "z": startZ])
            floorBoundary.append(["x": endX, "y": 0.0, "z": endZ])
        }

        // Extract doors
        for door in room.doors {
            let transform = door.transform
            let dims = door.dimensions
            openings.append([
                "type": "door",
                "position": [
                    "x": Double(transform.columns.3.x),
                    "y": Double(transform.columns.3.y),
                    "z": Double(transform.columns.3.z)
                ],
                "width": Double(dims.x),
                "height": Double(dims.y)
            ])
        }

        // Extract windows
        for window in room.windows {
            let transform = window.transform
            let dims = window.dimensions
            openings.append([
                "type": "window",
                "position": [
                    "x": Double(transform.columns.3.x),
                    "y": Double(transform.columns.3.y),
                    "z": Double(transform.columns.3.z)
                ],
                "width": Double(dims.x),
                "height": Double(dims.y)
            ])
        }

        // Calculate area (simple polygon area from wall endpoints)
        var area = 0.0
        if floorBoundary.count >= 3 {
            for i in 0..<floorBoundary.count {
                let j = (i + 1) % floorBoundary.count
                if let xi = floorBoundary[i]["x"] as? Double,
                   let yi = floorBoundary[i]["z"] as? Double,
                   let xj = floorBoundary[j]["x"] as? Double,
                   let yj = floorBoundary[j]["z"] as? Double {
                    area += xi * yj - xj * yi
                }
            }
            area = abs(area) / 2.0
        }

        // Export USDZ file
        var usdzPath: String? = nil
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let usdzURL = documentsPath.appendingPathComponent("room_scan_\(Int(Date().timeIntervalSince1970)).usdz")
        do {
            try room.export(to: usdzURL)
            usdzPath = usdzURL.path
        } catch {
            print("Failed to export USDZ: \(error)")
        }

        let resultData: [String: Any] = [
            "walls": walls,
            "openings": openings,
            "floorBoundary": floorBoundary,
            "area": area,
            "perimeter": 0.0,
            "usdzPath": usdzPath ?? "",
            "id": UUID().uuidString
        ]

        self.channel.invokeMethod("onScanComplete", arguments: resultData)
    }
}

@available(iOS 16.0, *)
extension RoomPlanNativeView: RoomCaptureViewDelegate {
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }

    func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        // Room processing complete
    }
}
