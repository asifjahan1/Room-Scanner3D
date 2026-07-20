import 'dart:math';
import 'dart:ui';
import '../models/room_scan.dart';

/// Generates a 2D floor plan from 3D room scan data
class FloorPlanGenerator {
  /// Convert 3D wall segments to 2D floor plan points
  static List<Point2D> generateFloorPlan(RoomScan scan) {
    if (scan.floorBoundary.isNotEmpty) {
      // Project 3D floor boundary to 2D (drop Y/height axis)
      return scan.floorBoundary
          .map((p) => Point2D(p.x, p.z))
          .toList();
    }

    if (scan.walls.isNotEmpty) {
      // Extract wall endpoints projected to 2D
      final points = <Point2D>[];
      for (final wall in scan.walls) {
        points.add(Point2D(wall.start.x, wall.start.z));
        points.add(Point2D(wall.end.x, wall.end.z));
      }
      return _convexHull(points);
    }

    return [];
  }

  /// Calculate room area from 2D boundary points (Shoelace formula)
  static double calculateArea(List<Point2D> boundary) {
    if (boundary.length < 3) return 0.0;

    double area = 0.0;
    final n = boundary.length;
    for (int i = 0; i < n; i++) {
      final j = (i + 1) % n;
      area += boundary[i].x * boundary[j].y;
      area -= boundary[j].x * boundary[i].y;
    }
    return area.abs() / 2.0;
  }

  /// Calculate room perimeter
  static double calculatePerimeter(List<Point2D> boundary) {
    if (boundary.length < 2) return 0.0;

    double perimeter = 0.0;
    for (int i = 0; i < boundary.length; i++) {
      final j = (i + 1) % boundary.length;
      final dx = boundary[j].x - boundary[i].x;
      final dy = boundary[j].y - boundary[i].y;
      perimeter += sqrt(dx * dx + dy * dy);
    }
    return perimeter;
  }

  /// Get wall lines for floor plan drawing
  static List<FloorPlanWall> getFloorPlanWalls(RoomScan scan) {
    final planWalls = <FloorPlanWall>[];
    for (final wall in scan.walls) {
      planWalls.add(FloorPlanWall(
        start: Point2D(wall.start.x, wall.start.z),
        end: Point2D(wall.end.x, wall.end.z),
        thickness: wall.thickness,
        length: wall.length,
      ));
    }
    return planWalls;
  }

  /// Get opening positions for floor plan
  static List<FloorPlanOpening> getFloorPlanOpenings(RoomScan scan) {
    return scan.openings.map((opening) {
      return FloorPlanOpening(
        type: opening.type,
        position: Point2D(opening.position.x, opening.position.z),
        width: opening.width,
      );
    }).toList();
  }

  /// Normalize floor plan points to fit within a given canvas size
  static List<Offset> normalizeToCanvas(
    List<Point2D> points,
    double canvasWidth,
    double canvasHeight, {
    double padding = 40.0,
  }) {
    if (points.isEmpty) return [];

    double minX = double.infinity, maxX = double.negativeInfinity;
    double minY = double.infinity, maxY = double.negativeInfinity;

    for (final p in points) {
      if (p.x < minX) minX = p.x;
      if (p.x > maxX) maxX = p.x;
      if (p.y < minY) minY = p.y;
      if (p.y > maxY) maxY = p.y;
    }

    final rangeX = maxX - minX;
    final rangeY = maxY - minY;
    if (rangeX == 0 && rangeY == 0) return [];

    final availableWidth = canvasWidth - 2 * padding;
    final availableHeight = canvasHeight - 2 * padding;
    final scale = min(
      availableWidth / (rangeX == 0 ? 1 : rangeX),
      availableHeight / (rangeY == 0 ? 1 : rangeY),
    );

    final offsetX = padding + (availableWidth - rangeX * scale) / 2;
    final offsetY = padding + (availableHeight - rangeY * scale) / 2;

    return points.map((p) {
      return Offset(
        offsetX + (p.x - minX) * scale,
        offsetY + (p.y - minY) * scale,
      );
    }).toList();
  }

  /// Generate dimension labels for walls
  static List<DimensionLabel> generateDimensionLabels(RoomScan scan) {
    final labels = <DimensionLabel>[];
    for (final wall in scan.walls) {
      final midX = (wall.start.x + wall.end.x) / 2;
      final midZ = (wall.start.z + wall.end.z) / 2;
      labels.add(DimensionLabel(
        position: Point2D(midX, midZ),
        lengthMeters: wall.length,
        lengthFeet: wall.length * 3.28084,
      ));
    }
    return labels;
  }

  /// Simple convex hull algorithm (Graham scan)
  static List<Point2D> _convexHull(List<Point2D> points) {
    if (points.length < 3) return points;

    // Find bottom-most point (or leftmost if tie)
    int lowestIdx = 0;
    for (int i = 1; i < points.length; i++) {
      if (points[i].y < points[lowestIdx].y ||
          (points[i].y == points[lowestIdx].y && points[i].x < points[lowestIdx].x)) {
        lowestIdx = i;
      }
    }

    final pivot = points[lowestIdx];
    final sorted = List<Point2D>.from(points);
    sorted.removeAt(lowestIdx);
    sorted.sort((a, b) {
      final angleA = atan2(a.y - pivot.y, a.x - pivot.x);
      final angleB = atan2(b.y - pivot.y, b.x - pivot.x);
      return angleA.compareTo(angleB);
    });

    final hull = <Point2D>[pivot];
    for (final p in sorted) {
      while (hull.length >= 2) {
        final a = hull[hull.length - 2];
        final b = hull[hull.length - 1];
        final cross = (b.x - a.x) * (p.y - a.y) - (b.y - a.y) * (p.x - a.x);
        if (cross <= 0) {
          hull.removeLast();
        } else {
          break;
        }
      }
      hull.add(p);
    }
    return hull;
  }
}

/// 2D wall for floor plan rendering
class FloorPlanWall {
  final Point2D start;
  final Point2D end;
  final double thickness;
  final double length;

  const FloorPlanWall({
    required this.start,
    required this.end,
    required this.thickness,
    required this.length,
  });
}

/// Opening in floor plan
class FloorPlanOpening {
  final String type;
  final Point2D position;
  final double width;

  const FloorPlanOpening({
    required this.type,
    required this.position,
    required this.width,
  });
}

/// Dimension label for floor plan
class DimensionLabel {
  final Point2D position;
  final double lengthMeters;
  final double lengthFeet;

  const DimensionLabel({
    required this.position,
    required this.lengthMeters,
    required this.lengthFeet,
  });

  String get formattedMeters => '${lengthMeters.toStringAsFixed(2)}m';
  String get formattedFeet => '${lengthFeet.toStringAsFixed(1)}ft';
}
