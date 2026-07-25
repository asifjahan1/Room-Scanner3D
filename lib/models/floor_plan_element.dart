import 'room_scan.dart';

/// Editable floor plan element base class
abstract class FloorPlanElement {
  final String id;
  double x;
  double y;
  double rotation; // degrees
  bool isSelected;

  FloorPlanElement({
    required this.id,
    this.x = 0,
    this.y = 0,
    this.rotation = 0,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson();
}

/// Editable wall in the floor plan editor
class EditableWall extends FloorPlanElement {
  Point2D start;
  Point2D end;
  double thickness;
  bool isDragging;

  EditableWall({
    required super.id,
    required this.start,
    required this.end,
    this.thickness = 0.15,
    this.isDragging = false,
  });

  double get length => start.distanceTo(end);

  Point2D get midpoint => Point2D(
        (start.x + end.x) / 2,
        (start.y + end.y) / 2,
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'wall',
        'start': start.toJson(),
        'end': end.toJson(),
        'thickness': thickness,
      };

  factory EditableWall.fromJson(Map<String, dynamic> json) {
    return EditableWall(
      id: json['id'] as String,
      start: Point2D.fromJson(json['start']),
      end: Point2D.fromJson(json['end']),
      thickness: (json['thickness'] as num?)?.toDouble() ?? 0.15,
    );
  }

  factory EditableWall.fromWallSegment(WallSegment wall, String id) {
    return EditableWall(
      id: id,
      start: Point2D(wall.start.x, wall.start.z),
      end: Point2D(wall.end.x, wall.end.z),
      thickness: wall.thickness,
    );
  }
}

/// Editable door/window on a wall
class EditableOpening extends FloorPlanElement {
  String type; // 'door' or 'window'
  double width;
  double height;
  double positionOnWall; // 0.0–1.0 position along parent wall
  String? parentWallId;
  double swingAngle; // door swing angle in degrees (0 = closed)

  EditableOpening({
    required super.id,
    required this.type,
    required this.width,
    required this.height,
    this.positionOnWall = 0.5,
    this.parentWallId,
    this.swingAngle = 90,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'width': width,
        'height': height,
        'positionOnWall': positionOnWall,
        'parentWallId': parentWallId,
        'swingAngle': swingAngle,
      };

  factory EditableOpening.fromJson(Map<String, dynamic> json) {
    return EditableOpening(
      id: json['id'] as String,
      type: json['type'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      positionOnWall: (json['positionOnWall'] as num?)?.toDouble() ?? 0.5,
      parentWallId: json['parentWallId'] as String?,
      swingAngle: (json['swingAngle'] as num?)?.toDouble() ?? 90,
    );
  }
}

/// Text annotation on the floor plan
class Annotation extends FloorPlanElement {
  String text;
  double fontSize;

  Annotation({
    required super.id,
    required this.text,
    required super.x,
    required super.y,
    this.fontSize = 14,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'annotation',
        'text': text,
        'x': x,
        'y': y,
        'fontSize': fontSize,
      };

  factory Annotation.fromJson(Map<String, dynamic> json) {
    return Annotation(
      id: json['id'] as String,
      text: json['text'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14,
    );
  }
}

/// Undo/Redo action for floor plan editing
class FloorPlanAction {
  final String type; // 'move_wall', 'add_door', 'delete_wall', etc.
  final Map<String, dynamic> previousState;
  final Map<String, dynamic> newState;

  const FloorPlanAction({
    required this.type,
    required this.previousState,
    required this.newState,
  });
}
