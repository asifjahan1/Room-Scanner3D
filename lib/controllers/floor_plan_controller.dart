import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/room_scan.dart';
import '../models/floor_plan_element.dart';
import '../core/constants/app_constants.dart';

/// GetX controller managing the interactive floor plan editor.
class FloorPlanController extends GetxController {
  // ─── Reactive State ───
  final walls = <EditableWall>[].obs;
  final openings = <EditableOpening>[].obs;
  final annotations = <Annotation>[].obs;
  final selectedElementId = Rxn<String>();
  final isEditing = false.obs;
  final showDimensions = true.obs;
  final showGrid = false.obs;
  final isMetric = true.obs;
  final is3DView = false.obs;
  final roomLabel = 'Room'.obs;
  final roomType = RoomType.custom.obs;

  // Undo/Redo stacks
  final _undoStack = <FloorPlanAction>[];
  final _redoStack = <FloorPlanAction>[];
  final canUndo = false.obs;
  final canRedo = false.obs;

  final _uuid = const Uuid();

  /// Initialize from a RoomScan result.
  void loadFromScan(RoomScan scan) {
    walls.clear();
    openings.clear();
    annotations.clear();
    _undoStack.clear();
    _redoStack.clear();

    // Convert wall segments to editable walls
    for (int i = 0; i < scan.walls.length; i++) {
      walls.add(EditableWall.fromWallSegment(scan.walls[i], _uuid.v4()));
    }

    // Convert openings
    for (final opening in scan.openings) {
      openings.add(EditableOpening(
        id: _uuid.v4(),
        type: opening.type,
        width: opening.width,
        height: opening.height,
      ));
    }

    if (scan.label != null) roomLabel.value = scan.label!;
    roomType.value = scan.roomType;

    _updateUndoRedoState();
  }

  // ─── Selection ───

  void selectElement(String id) {
    selectedElementId.value = id;
    isEditing.value = true;
  }

  void deselectAll() {
    selectedElementId.value = null;
    isEditing.value = false;
    for (final w in walls) {
      w.isSelected = false;
    }
  }

  // ─── Wall Operations ───

  void moveWallEndpoint(String wallId, bool isStart, double newX, double newY) {
    final idx = walls.indexWhere((w) => w.id == wallId);
    if (idx < 0) return;

    final wall = walls[idx];
    final prevState = wall.toJson();

    if (isStart) {
      wall.start = Point2D(newX, newY);
    } else {
      wall.end = Point2D(newX, newY);
    }

    _pushUndo(FloorPlanAction(
      type: 'move_wall',
      previousState: prevState,
      newState: wall.toJson(),
    ));

    walls.refresh();
  }

  void deleteWall(String wallId) {
    final idx = walls.indexWhere((w) => w.id == wallId);
    if (idx < 0) return;

    final wall = walls[idx];
    _pushUndo(FloorPlanAction(
      type: 'delete_wall',
      previousState: wall.toJson(),
      newState: {},
    ));

    walls.removeAt(idx);
    if (selectedElementId.value == wallId) {
      deselectAll();
    }
  }

  void splitWall(String wallId) {
    final idx = walls.indexWhere((w) => w.id == wallId);
    if (idx < 0) return;

    final wall = walls[idx];
    final mid = wall.midpoint;

    final wall1 = EditableWall(
      id: _uuid.v4(),
      start: wall.start,
      end: mid,
      thickness: wall.thickness,
    );

    final wall2 = EditableWall(
      id: _uuid.v4(),
      start: mid,
      end: wall.end,
      thickness: wall.thickness,
    );

    _pushUndo(FloorPlanAction(
      type: 'split_wall',
      previousState: wall.toJson(),
      newState: {'wall1': wall1.toJson(), 'wall2': wall2.toJson()},
    ));

    walls[idx] = wall1;
    walls.insert(idx + 1, wall2);
  }

  // ─── Opening Operations ───

  void addDoor(String? parentWallId) {
    final door = EditableOpening(
      id: _uuid.v4(),
      type: 'door',
      width: 0.9,
      height: 2.1,
      parentWallId: parentWallId,
    );

    _pushUndo(FloorPlanAction(
      type: 'add_door',
      previousState: {},
      newState: door.toJson(),
    ));

    openings.add(door);
  }

  void addWindow(String? parentWallId) {
    final window = EditableOpening(
      id: _uuid.v4(),
      type: 'window',
      width: 1.2,
      height: 1.0,
      parentWallId: parentWallId,
    );

    _pushUndo(FloorPlanAction(
      type: 'add_window',
      previousState: {},
      newState: window.toJson(),
    ));

    openings.add(window);
  }

  void deleteOpening(String openingId) {
    final idx = openings.indexWhere((o) => o.id == openingId);
    if (idx < 0) return;

    _pushUndo(FloorPlanAction(
      type: 'delete_opening',
      previousState: openings[idx].toJson(),
      newState: {},
    ));

    openings.removeAt(idx);
  }

  // ─── Annotations ───

  void addAnnotation(String text, double x, double y) {
    final annotation = Annotation(
      id: _uuid.v4(),
      text: text,
      x: x,
      y: y,
    );

    _pushUndo(FloorPlanAction(
      type: 'add_annotation',
      previousState: {},
      newState: annotation.toJson(),
    ));

    annotations.add(annotation);
  }

  void deleteAnnotation(String annotationId) {
    annotations.removeWhere((a) => a.id == annotationId);
  }

  // ─── Undo / Redo ───

  void undo() {
    if (_undoStack.isEmpty) return;
    final action = _undoStack.removeLast();
    _redoStack.add(action);
    _updateUndoRedoState();
    // Re-apply by rebuilding state (simplified — a full impl would reverse each action type)
    walls.refresh();
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    final action = _redoStack.removeLast();
    _undoStack.add(action);
    _updateUndoRedoState();
    walls.refresh();
  }

  void _pushUndo(FloorPlanAction action) {
    _undoStack.add(action);
    if (_undoStack.length > AppConstants.maxUndoSteps) {
      _undoStack.removeAt(0);
    }
    _redoStack.clear();
    _updateUndoRedoState();
  }

  void _updateUndoRedoState() {
    canUndo.value = _undoStack.isNotEmpty;
    canRedo.value = _redoStack.isNotEmpty;
  }

  // ─── Room Info ───

  double get totalArea {
    if (walls.length < 3) return 0;
    final xs = walls.map((w) => w.start.x).toList();
    final ys = walls.map((w) => w.start.y).toList();
    double area = 0;
    for (int i = 0; i < xs.length; i++) {
      final j = (i + 1) % xs.length;
      area += xs[i] * ys[j] - xs[j] * ys[i];
    }
    return area.abs() / 2.0;
  }

  double get totalPerimeter {
    return walls.fold(0.0, (sum, w) => sum + w.length);
  }
}
