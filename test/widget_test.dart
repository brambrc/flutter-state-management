// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_state_management_training/main.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StateManagementTrainingApp());

    // Verify that main menu loads
    expect(find.text('Flutter State Management Training'), findsOneWidget);
    expect(find.text('Pilih topik pembelajaran yang ingin dipelajari:'), findsOneWidget);

    // Verify menu cards are present
    expect(find.text('setState()'), findsOneWidget);
    expect(find.text('Provider'), findsOneWidget);
    expect(find.text('BLOC'), findsOneWidget);
    expect(find.text('Cubit'), findsOneWidget);
  });
}
