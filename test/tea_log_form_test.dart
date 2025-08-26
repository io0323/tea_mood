import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tea_mood/presentation/widgets/tea_log_form.dart';

void main() {
  group('TeaLogForm Widget Tests', () {
    testWidgets('TeaLogForm should build without errors', (WidgetTester tester) async {
      // Build our widget
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TeaLogForm(),
            ),
          ),
        ),
      );

      // Verify that the form is displayed
      expect(find.text('お茶を記録'), findsOneWidget);
      expect(find.text('日時'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('DateTime picker ListTile should be tappable', (WidgetTester tester) async {
      // Build our widget
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TeaLogForm(),
            ),
          ),
        ),
      );

      // Find the date time picker ListTile and verify it exists
      final dateTimeListTile = find.byIcon(Icons.calendar_today);
      expect(dateTimeListTile, findsOneWidget);

      // The ListTile should be tappable (this tests that our mounted checks don't break the UI)
      await tester.tap(dateTimeListTile);
      await tester.pump();
      
      // Note: We can't easily test the actual date/time picker dialogs in widget tests
      // without more complex mocking, but this verifies the UI doesn't crash
    });
  });
}