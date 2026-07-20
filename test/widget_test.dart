import 'package:flutter_test/flutter_test.dart';
import 'package:liddar/main.dart';

void main() {
  testWidgets('App should launch', (WidgetTester tester) async {
    await tester.pumpWidget(const RoomScannerApp());
    expect(find.text('Room Scanner'), findsOneWidget);
  });
}
