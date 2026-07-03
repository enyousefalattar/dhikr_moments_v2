import 'package:flutter_test/flutter_test.dart';
import 'package:dhikr_moments_v2/main.dart';

void main() {
  testWidgets('App starts test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DhikrMomentsApp());
    expect(find.byType(DhikrMomentsApp), findsOneWidget);
  });
}
