import 'dart:math';

/// Represents a 3D point in space
class Point3D {
  final double x;
  final double y;
  final double z;

  const Point3D(this.x, this.y, this.z);

  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'z': z};

  factory Point3D.fromJson(Map<String, dynamic> json) {
    return Point3D(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      (json['z'] as num).toDouble(),
    );
  }

  double distanceTo(Point3D other) {
    return sqrt(
      pow(x - other.x, 2) + pow(y - other.y, 2) + pow(z - other.z, 2),
    );
  }
}

/// Represents a 2D point for floor plan
class Point2D {
  final double x;
  final double y;

  const Point2D(this.x, this.y);

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory Point2D.fromJson(Map<String, dynamic> json) {
    return Point2D(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    );
  }
}

/// Represents a detected wall segment
class WallSegment {
  final Point3D start;
  final Point3D end;
  final double height;
  final double thickness;

  const WallSegment({
    required this.start,
    required this.end,
    this.height = 2.4,
    this.thickness = 0.15,
  });

  double get length => start.distanceTo(end);

  Map<String, dynamic> toJson() => {
    'start': start.toJson(),
    'end': end.toJson(),
    'height': height,
    'thickness': thickness,
  };

  factory WallSegment.fromJson(Map<String, dynamic> json) {
    return WallSegment(
      start: Point3D.fromJson(json['start']),
      end: Point3D.fromJson(json['end']),
      height: (json['height'] as num?)?.toDouble() ?? 2.4,
      thickness: (json['thickness'] as num?)?.toDouble() ?? 0.15,
    );
  }
}

/// Represents a detected door or window opening
class Opening {
  final String type; // 'door' or 'window'
  final Point3D position;
  final double width;
  final double height;

  const Opening({
    required this.type,
    required this.position,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'position': position.toJson(),
    'width': width,
    'height': height,
  };

  factory Opening.fromJson(Map<String, dynamic> json) {
    return Opening(
      type: json['type'] as String,
      position: Point3D.fromJson(json['position']),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );
  }
}

/// The scanning status
enum ScanStatus {
  idle,
  initializing,
  scanning,
  processing,
  completed,
  failed,
}

/// Represents a complete room scan result
class RoomScan {
  final String id;
  final String? label;
  final String? roomTypeId;
  final DateTime scannedAt;
  final List<WallSegment> walls;
  final List<Opening> openings;
  final List<Point3D> floorBoundary;
  final double? area; // square meters
  final double? perimeter; // meters
  final ScanStatus status;
  final String? usdzFilePath;
  final String? jsonFilePath;

  const RoomScan({
    required this.id,
    this.label,
    this.roomTypeId,
    required this.scannedAt,
    this.walls = const [],
    this.openings = const [],
    this.floorBoundary = const [],
    this.area,
    this.perimeter,
    this.status = ScanStatus.idle,
    this.usdzFilePath,
    this.jsonFilePath,
  });

  RoomScan copyWith({
    String? id,
    String? label,
    String? roomTypeId,
    DateTime? scannedAt,
    List<WallSegment>? walls,
    List<Opening>? openings,
    List<Point3D>? floorBoundary,
    double? area,
    double? perimeter,
    ScanStatus? status,
    String? usdzFilePath,
    String? jsonFilePath,
  }) {
    return RoomScan(
      id: id ?? this.id,
      label: label ?? this.label,
      roomTypeId: roomTypeId ?? this.roomTypeId,
      scannedAt: scannedAt ?? this.scannedAt,
      walls: walls ?? this.walls,
      openings: openings ?? this.openings,
      floorBoundary: floorBoundary ?? this.floorBoundary,
      area: area ?? this.area,
      perimeter: perimeter ?? this.perimeter,
      status: status ?? this.status,
      usdzFilePath: usdzFilePath ?? this.usdzFilePath,
      jsonFilePath: jsonFilePath ?? this.jsonFilePath,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'roomTypeId': roomTypeId,
    'scannedAt': scannedAt.toIso8601String(),
    'walls': walls.map((w) => w.toJson()).toList(),
    'openings': openings.map((o) => o.toJson()).toList(),
    'floorBoundary': floorBoundary.map((p) => p.toJson()).toList(),
    'area': area,
    'perimeter': perimeter,
    'status': status.name,
    'usdzFilePath': usdzFilePath,
    'jsonFilePath': jsonFilePath,
  };

  factory RoomScan.fromJson(Map<String, dynamic> json) {
    return RoomScan(
      id: json['id'] as String,
      label: json['label'] as String?,
      roomTypeId: json['roomTypeId'] as String?,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      walls: (json['walls'] as List<dynamic>?)
              ?.map((w) => WallSegment.fromJson(w as Map<String, dynamic>))
              .toList() ??
          [],
      openings: (json['openings'] as List<dynamic>?)
              ?.map((o) => Opening.fromJson(o as Map<String, dynamic>))
              .toList() ??
          [],
      floorBoundary: (json['floorBoundary'] as List<dynamic>?)
              ?.map((p) => Point3D.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      area: (json['area'] as num?)?.toDouble(),
      perimeter: (json['perimeter'] as num?)?.toDouble(),
      status: ScanStatus.values.byName(json['status'] as String? ?? 'idle'),
      usdzFilePath: json['usdzFilePath'] as String?,
      jsonFilePath: json['jsonFilePath'] as String?,
    );
  }
}

/// Represents a complete project with multiple room scans
class ScanProject {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<RoomScan> rooms;

  const ScanProject({
    required this.id,
    required this.name,
    required this.createdAt,
    this.rooms = const [],
  });

  double get totalArea =>
      rooms.fold(0.0, (sum, room) => sum + (room.area ?? 0.0));

  int get completedRooms =>
      rooms.where((r) => r.status == ScanStatus.completed).length;

  ScanProject copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    List<RoomScan>? rooms,
  }) {
    return ScanProject(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rooms: rooms ?? this.rooms,
    );
  }
}
