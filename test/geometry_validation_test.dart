import 'package:flutter_test/flutter_test.dart';
import 'package:liddar/models/room_scan.dart';

void main() {
  group('3D Geometry & RoomScan Domain Suite', () {
    test('Point3D distanceTo computes accurate Euclidean distance in 3D space', () {
      const p1 = Point3D(0.0, 0.0, 0.0);
      const p2 = Point3D(3.0, 4.0, 12.0);
      expect(p1.distanceTo(p2), closeTo(13.0, 0.0001));
    });

    test('WallSegment length and length2D accurately separate vertical variance', () {
      const wall = WallSegment(
        start: Point3D(0.0, 0.0, 0.0),
        end: Point3D(3.0, 0.5, 4.0), // 3D distance is sqrt(9 + 0.25 + 16) = sqrt(25.25)
        height: 2.75,
        thickness: 0.20,
      );

      expect(wall.length2D, closeTo(5.0, 0.0001)); // sqrt(3^2 + 4^2) = 5
      expect(wall.length, closeTo(5.0249, 0.001));
      expect(wall.midpoint.x, equals(1.5));
      expect(wall.midpoint.z, equals(2.0));
    });

    test('RoomScan serializes and deserializes correctly including isHeightMeasured flag', () {
      final original = RoomScan(
        id: 'scan_2026_x',
        label: 'Laboratory 3',
        scannedAt: DateTime(2026, 7, 26, 12, 30),
        roomType: RoomType.office,
        area: 45.5,
        perimeter: 28.4,
        roomHeight: 3.1,
        qualityScore: 0.98,
        status: ScanStatus.completed,
        isHeightMeasured: true,
      );

      final json = original.toJson();
      expect(json['id'], equals('scan_2026_x'));
      expect(json['isHeightMeasured'], isTrue);

      final deserialized = RoomScan.fromJson(json);
      expect(deserialized.id, equals(original.id));
      expect(deserialized.label, equals(original.label));
      expect(deserialized.roomType, equals(RoomType.office));
      expect(deserialized.area, equals(45.5));
      expect(deserialized.isHeightMeasured, isTrue);
    });

    test('RoomScan default copyWith retains isHeightMeasured unless explicitly overwritten', () {
      final now = DateTime.now();
      final scan1 = RoomScan(id: '101', scannedAt: now, isHeightMeasured: true);
      final scan2 = scan1.copyWith(label: 'Updated Label');
      expect(scan2.isHeightMeasured, isTrue);

      final scan3 = scan1.copyWith(isHeightMeasured: false);
      expect(scan3.isHeightMeasured, isFalse);
    });
  });
}
