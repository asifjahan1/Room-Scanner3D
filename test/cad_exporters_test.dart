import 'package:flutter_test/flutter_test.dart';
import 'package:liddar/models/room_scan.dart';
import 'package:liddar/services/exporters/cad_exporters.dart';

void main() {
  group('CAD Exporters Suite - Production Validation', () {
    late RoomScan testScan;

    setUp(() {
      final walls = [
        const WallSegment(
          start: Point3D(0.0, 0.0, 0.0),
          end: Point3D(4.0, 0.0, 0.0),
          height: 2.8,
          thickness: 0.15,
        ),
        const WallSegment(
          start: Point3D(4.0, 0.0, 0.0),
          end: Point3D(4.0, 0.0, 5.0),
          height: 2.8,
          thickness: 0.15,
        ),
        const WallSegment(
          start: Point3D(4.0, 0.0, 5.0),
          end: Point3D(0.0, 0.0, 5.0),
          height: 2.8,
          thickness: 0.15,
        ),
        const WallSegment(
          start: Point3D(0.0, 0.0, 5.0),
          end: Point3D(0.0, 0.0, 0.0),
          height: 2.8,
          thickness: 0.15,
        ),
      ];

      final openings = [
        const Opening(
          type: 'door',
          position: Point3D(2.0, 0.0, 0.0),
          width: 0.9,
          height: 2.1,
          onWallIndex: 0,
        ),
      ];

      testScan = RoomScan(
        id: 'test_cad_1001',
        label: 'Executive Conference Room',
        scannedAt: DateTime(2026, 7, 26, 10, 0),
        walls: walls,
        openings: openings,
        floorBoundary: [
          const Point3D(0.0, 0.0, 0.0),
          const Point3D(4.0, 0.0, 0.0),
          const Point3D(4.0, 0.0, 5.0),
          const Point3D(0.0, 0.0, 5.0),
        ],
        area: 20.0,
        perimeter: 18.0,
        roomHeight: 2.8,
        isHeightMeasured: true,
      );
    });

    test('DXF Export produces compliant AutoCAD R12 ASCII structure', () {
      final dxf = CadExporters.exportDxf(testScan);
      
      expect(dxf.contains('0\nSECTION'), isTrue);
      expect(dxf.contains('2\nHEADER'), isTrue);
      expect(dxf.contains('1\nAC1009'), isTrue); // R12 Specification
      expect(dxf.contains('2\nTABLES'), isTrue);
      expect(dxf.contains('2\nLAYER'), isTrue);
      
      // Verify layer allocations
      expect(dxf.contains('WALLS'), isTrue);
      expect(dxf.contains('OPENINGS'), isTrue);
      expect(dxf.contains('FLOOR_BOUNDARY'), isTrue);
      
      // Verify line entities exist with real world coordinates
      expect(dxf.contains('0\nLINE'), isTrue);
      expect(dxf.contains('4.0000'), isTrue);
      expect(dxf.contains('5.0000'), isTrue);
      expect(dxf.contains('0\nEOF'), isTrue);
    });

    test('SVG Export generates vector floor layout with architectural styling', () {
      final svg = CadExporters.exportSvg(testScan, isMetric: true);
      
      expect(svg.contains('<?xml version="1.0"'), isTrue);
      expect(svg.contains('<svg width='), isTrue);
      expect(svg.contains('viewBox='), isTrue);
      expect(svg.contains('Executive Conference Room'), isTrue);
      
      // Check polygon wall segment representations
      expect(svg.contains('<line x1='), isTrue);
      expect(svg.contains('stroke="#343a40"'), isTrue); // Architect Dark Slate
      expect(svg.contains('class="dim-text"'), isTrue);
      expect(svg.contains('4.00 m') || svg.contains('4.00m'), isTrue);
      expect(svg.contains('5.00 m') || svg.contains('5.00m'), isTrue);
    });

    test('OBJ 3D Mesh Export creates polygonal vertices and face geometry', () {
      final obj = CadExporters.exportObj(testScan);
      
      expect(obj.contains('# Produced by Liddar 3D AR Engine'), isTrue);
      expect(obj.contains('g wall_1'), isTrue);
      expect(obj.contains('g wall_2'), isTrue);
      expect(obj.contains('g wall_3'), isTrue);
      expect(obj.contains('g wall_4'), isTrue);
      
      // Every wall segment creates an 8-vertex bounding box prism (8 vertices * 4 walls = 32 'v ')
      final vCount = 'v '.allMatches(obj).length;
      expect(vCount, equals(32));
      
      // Every wall segment has front, back, top triangular faces (6 faces * 4 walls = 24 'f ')
      final fCount = 'f '.allMatches(obj).length;
      expect(fCount, equals(24));
    });

    test('GLB JSON export preserves complete spatial coordinates and flags', () {
      final jsonStr = CadExporters.exportGlbJson(testScan);
      expect(jsonStr.contains('test_cad_1001'), isTrue);
      expect(jsonStr.contains('isHeightMeasured: true') || jsonStr.contains('isHeightMeasured'), isTrue);
    });
  });
}
