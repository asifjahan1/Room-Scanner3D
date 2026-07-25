import 'dart:math';

/// Utility class for measurement conversions and geometric calculations.
class MeasurementUtils {
  MeasurementUtils._();

  // ─── Conversion Constants ───
  static const double metersToFeet = 3.28084;
  static const double feetToMeters = 0.3048;
  static const double sqMetersToSqFeet = 10.7639;
  static const double sqFeetToSqMeters = 0.092903;
  static const double cubicMetersToCubicFeet = 35.3147;

  // ─── Length Conversions ───
  static double toFeet(double meters) => meters * metersToFeet;
  static double toMeters(double feet) => feet * feetToMeters;

  // ─── Area Conversions ───
  static double toSqFeet(double sqMeters) => sqMeters * sqMetersToSqFeet;
  static double toSqMeters(double sqFeet) => sqFeet * sqFeetToSqMeters;

  // ─── Volume Conversions ───
  static double toCubicFeet(double cubicMeters) =>
      cubicMeters * cubicMetersToCubicFeet;

  // ─── Formatting ───
  static String formatLength(double meters, {bool isMetric = true}) {
    if (isMetric) {
      return '${meters.toStringAsFixed(2)} m';
    }
    return '${toFeet(meters).toStringAsFixed(1)} ft';
  }

  static String formatArea(double sqMeters, {bool isMetric = true}) {
    if (isMetric) {
      return '${sqMeters.toStringAsFixed(1)} m²';
    }
    return '${toSqFeet(sqMeters).toStringAsFixed(1)} ft²';
  }

  static String formatVolume(double cubicMeters, {bool isMetric = true}) {
    if (isMetric) {
      return '${cubicMeters.toStringAsFixed(1)} m³';
    }
    return '${toCubicFeet(cubicMeters).toStringAsFixed(1)} ft³';
  }

  // ─── Geometric Calculations ───

  /// Calculate distance between two 2D points.
  static double distance2D(double x1, double y1, double x2, double y2) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    return sqrt(dx * dx + dy * dy);
  }

  /// Calculate distance between two 3D points.
  static double distance3D(
    double x1, double y1, double z1,
    double x2, double y2, double z2,
  ) {
    final dx = x2 - x1;
    final dy = y2 - y1;
    final dz = z2 - z1;
    return sqrt(dx * dx + dy * dy + dz * dz);
  }

  /// Calculate polygon area using the Shoelace formula.
  /// Points are 2D (x, y) pairs in a flat list.
  static double polygonArea(List<double> xs, List<double> ys) {
    if (xs.length < 3 || xs.length != ys.length) return 0.0;

    double area = 0.0;
    final n = xs.length;
    for (int i = 0; i < n; i++) {
      final j = (i + 1) % n;
      area += xs[i] * ys[j];
      area -= xs[j] * ys[i];
    }
    return area.abs() / 2.0;
  }

  /// Calculate polygon perimeter.
  static double polygonPerimeter(List<double> xs, List<double> ys) {
    if (xs.length < 2 || xs.length != ys.length) return 0.0;

    double perimeter = 0.0;
    final n = xs.length;
    for (int i = 0; i < n; i++) {
      final j = (i + 1) % n;
      perimeter += distance2D(xs[i], ys[i], xs[j], ys[j]);
    }
    return perimeter;
  }

  /// Calculate angle between two wall segments at their shared point.
  /// Returns angle in degrees (0-360).
  static double angleBetweenWalls(
    double ax, double ay, // first wall other endpoint
    double cx, double cy, // shared corner point
    double bx, double by, // second wall other endpoint
  ) {
    final angle1 = atan2(ay - cy, ax - cx);
    final angle2 = atan2(by - cy, bx - cx);
    var angleDiff = angle2 - angle1;

    // Normalize to [0, 2π)
    while (angleDiff < 0) {
      angleDiff += 2 * pi;
    }
    while (angleDiff >= 2 * pi) {
      angleDiff -= 2 * pi;
    }

    return angleDiff * 180.0 / pi;
  }

  /// Calculate room volume = area × height.
  static double volume(double area, double height) => area * height;
}
