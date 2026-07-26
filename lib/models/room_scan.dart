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

  @override
  String toString() => 'Point3D($x, $y, $z)';
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

  double distanceTo(Point2D other) {
    return sqrt(pow(x - other.x, 2) + pow(y - other.y, 2));
  }

  @override
  String toString() => 'Point2D($x, $y)';
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
    this.height = 2.6,
    this.thickness = 0.15,
  });

  double get length => start.distanceTo(end);

  /// 2D length ignoring Y axis
  double get length2D {
    final dx = end.x - start.x;
    final dz = end.z - start.z;
    return sqrt(dx * dx + dz * dz);
  }

  /// Midpoint of wall in 3D
  Point3D get midpoint => Point3D(
        (start.x + end.x) / 2,
        (start.y + end.y) / 2,
        (start.z + end.z) / 2,
      );

  /// 2D angle of wall in radians
  double get angle2D => atan2(end.z - start.z, end.x - start.x);

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
      height: (json['height'] as num?)?.toDouble() ?? 2.6,
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
  final int? onWallIndex; // which wall this opening is on

  const Opening({
    required this.type,
    required this.position,
    required this.width,
    required this.height,
    this.onWallIndex,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'position': position.toJson(),
        'width': width,
        'height': height,
        'onWallIndex': onWallIndex,
      };

  factory Opening.fromJson(Map<String, dynamic> json) {
    return Opening(
      type: json['type'] as String,
      position: Point3D.fromJson(json['position']),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      onWallIndex: json['onWallIndex'] as int?,
    );
  }
}

/// Room corner with angle information
class RoomCorner {
  final Point3D position;
  final double angle; // degrees between adjacent walls

  const RoomCorner({required this.position, required this.angle});

  Map<String, dynamic> toJson() => {
        'position': position.toJson(),
        'angle': angle,
      };

  factory RoomCorner.fromJson(Map<String, dynamic> json) {
    return RoomCorner(
      position: Point3D.fromJson(json['position']),
      angle: (json['angle'] as num).toDouble(),
    );
  }
}

/// Room type classification
enum RoomType {
  bedroom,
  livingRoom,
  kitchen,
  bathroom,
  office,
  diningRoom,
  garage,
  hallway,
  balcony,
  custom;

  String get displayName {
    switch (this) {
      case RoomType.bedroom:
        return 'Bedroom';
      case RoomType.livingRoom:
        return 'Living Room';
      case RoomType.kitchen:
        return 'Kitchen';
      case RoomType.bathroom:
        return 'Bathroom';
      case RoomType.office:
        return 'Office';
      case RoomType.diningRoom:
        return 'Dining Room';
      case RoomType.garage:
        return 'Garage';
      case RoomType.hallway:
        return 'Hallway';
      case RoomType.balcony:
        return 'Balcony';
      case RoomType.custom:
        return 'Custom';
    }
  }

  String get emoji {
    switch (this) {
      case RoomType.bedroom:
        return '🛏️';
      case RoomType.livingRoom:
        return '🛋️';
      case RoomType.kitchen:
        return '🍳';
      case RoomType.bathroom:
        return '🚿';
      case RoomType.office:
        return '💼';
      case RoomType.diningRoom:
        return '🍽️';
      case RoomType.garage:
        return '🚗';
      case RoomType.hallway:
        return '🚪';
      case RoomType.balcony:
        return '🌿';
      case RoomType.custom:
        return '📐';
    }
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

/// Tracking quality for AR sessions
enum TrackingQuality {
  good,
  limited,
  lost;

  String get displayName {
    switch (this) {
      case TrackingQuality.good:
        return 'Good';
      case TrackingQuality.limited:
        return 'Limited';
      case TrackingQuality.lost:
        return 'Lost';
    }
  }
}

/// Represents a complete room scan result
class RoomScan {
  final String id;
  final String? label;
  final String? roomTypeId;
  final RoomType roomType;
  final DateTime scannedAt;
  final DateTime? updatedAt;
  final List<WallSegment> walls;
  final List<Opening> openings;
  final List<Point3D> floorBoundary;
  final List<RoomCorner> corners;
  final double? area;
  final double? perimeter;
  final double? roomHeight;
  final double? volume;
  final double? qualityScore;
  final String? notes;
  final ScanStatus status;
  final String? usdzFilePath;
  final String? jsonFilePath;
  final bool isHeightMeasured;

  const RoomScan({
    required this.id,
    this.label,
    this.roomTypeId,
    this.roomType = RoomType.custom,
    required this.scannedAt,
    this.updatedAt,
    this.walls = const [],
    this.openings = const [],
    this.floorBoundary = const [],
    this.corners = const [],
    this.area,
    this.perimeter,
    this.roomHeight,
    this.volume,
    this.qualityScore,
    this.notes,
    this.status = ScanStatus.idle,
    this.usdzFilePath,
    this.jsonFilePath,
    this.isHeightMeasured = false,
  });

  int get doorCount => openings.where((o) => o.type == 'door').length;
  int get windowCount => openings.where((o) => o.type == 'window').length;

  RoomScan copyWith({
    String? id,
    String? label,
    String? roomTypeId,
    RoomType? roomType,
    DateTime? scannedAt,
    DateTime? updatedAt,
    List<WallSegment>? walls,
    List<Opening>? openings,
    List<Point3D>? floorBoundary,
    List<RoomCorner>? corners,
    double? area,
    double? perimeter,
    double? roomHeight,
    double? volume,
    double? qualityScore,
    String? notes,
    ScanStatus? status,
    String? usdzFilePath,
    String? jsonFilePath,
    bool? isHeightMeasured,
  }) {
    return RoomScan(
      id: id ?? this.id,
      label: label ?? this.label,
      roomTypeId: roomTypeId ?? this.roomTypeId,
      roomType: roomType ?? this.roomType,
      scannedAt: scannedAt ?? this.scannedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      walls: walls ?? this.walls,
      openings: openings ?? this.openings,
      floorBoundary: floorBoundary ?? this.floorBoundary,
      corners: corners ?? this.corners,
      area: area ?? this.area,
      perimeter: perimeter ?? this.perimeter,
      roomHeight: roomHeight ?? this.roomHeight,
      volume: volume ?? this.volume,
      qualityScore: qualityScore ?? this.qualityScore,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      usdzFilePath: usdzFilePath ?? this.usdzFilePath,
      jsonFilePath: jsonFilePath ?? this.jsonFilePath,
      isHeightMeasured: isHeightMeasured ?? this.isHeightMeasured,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'roomTypeId': roomTypeId,
        'roomType': roomType.name,
        'scannedAt': scannedAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'walls': walls.map((w) => w.toJson()).toList(),
        'openings': openings.map((o) => o.toJson()).toList(),
        'floorBoundary': floorBoundary.map((p) => p.toJson()).toList(),
        'corners': corners.map((c) => c.toJson()).toList(),
        'area': area,
        'perimeter': perimeter,
        'roomHeight': roomHeight,
        'volume': volume,
        'qualityScore': qualityScore,
        'notes': notes,
        'status': status.name,
        'usdzFilePath': usdzFilePath,
        'jsonFilePath': jsonFilePath,
        'isHeightMeasured': isHeightMeasured,
      };

  factory RoomScan.fromJson(Map<String, dynamic> json) {
    return RoomScan(
      id: json['id'] as String,
      label: json['label'] as String?,
      roomTypeId: json['roomTypeId'] as String?,
      roomType: RoomType.values.byName(json['roomType'] as String? ?? 'custom'),
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
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
      corners: (json['corners'] as List<dynamic>?)
              ?.map((c) => RoomCorner.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
      area: (json['area'] as num?)?.toDouble(),
      perimeter: (json['perimeter'] as num?)?.toDouble(),
      roomHeight: (json['roomHeight'] as num?)?.toDouble(),
      volume: (json['volume'] as num?)?.toDouble(),
      qualityScore: (json['qualityScore'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      status: ScanStatus.values.byName(json['status'] as String? ?? 'idle'),
      usdzFilePath: json['usdzFilePath'] as String?,
      jsonFilePath: json['jsonFilePath'] as String?,
      isHeightMeasured: json['isHeightMeasured'] as bool? ?? false,
    );
  }
}

/// Represents a complete project with multiple room scans
class ScanProject {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<RoomScan> rooms;

  const ScanProject({
    required this.id,
    required this.name,
    required this.createdAt,
    this.updatedAt,
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
    DateTime? updatedAt,
    List<RoomScan>? rooms,
  }) {
    return ScanProject(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rooms: rooms ?? this.rooms,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'rooms': rooms.map((r) => r.toJson()).toList(),
      };

  factory ScanProject.fromJson(Map<String, dynamic> json) {
    return ScanProject(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((r) => RoomScan.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
