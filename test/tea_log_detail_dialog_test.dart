import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tea_mood/presentation/widgets/tea_log_detail_dialog.dart';
import 'package:tea_mood/domain/entities/tea_log.dart';

void main() {
  group('TeaLogDetailDialog Context Tests', () {
    testWidgets('TeaLogDetailDialog should render correctly', (WidgetTester tester) async {
      // Create a sample tea log for testing
      final teaLog = TeaLog(
        id: 'test-id',
        teaType: 'green',
        caffeineMg: 50,
        temperature: 80,
        dateTime: DateTime.now(),
        mood: 'relaxed',
        amount: 200,
        notes: 'Test note',
      );

      // Build our widget
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TeaLogDetailDialog(teaLog: teaLog),
            ),
          ),
        ),
      );

      // Verify that the dialog renders without errors
      expect(find.text('green茶'), findsOneWidget);
      expect(find.text('削除'), findsOneWidget);
      expect(find.text('編集'), findsOneWidget);
      
      // This test verifies the mounted checks don't break the UI rendering
    });

    testWidgets('Delete button should be tappable without throwing errors', (WidgetTester tester) async {
      final teaLog = TeaLog(
        id: 'test-id',
        teaType: 'green',
        caffeineMg: 50,
        temperature: 80,
        dateTime: DateTime.now(),
        mood: 'relaxed',
        amount: 200,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TeaLogDetailDialog(teaLog: teaLog),
            ),
          ),
        ),
      );

      // Tap the delete button to open confirmation dialog
      final deleteButton = find.text('削除');
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pump();

      // Verify the confirmation dialog appears
      expect(find.text('削除の確認'), findsOneWidget);
      expect(find.text('この記録を削除しますか？'), findsOneWidget);
      
      // This verifies that our async context handling doesn't break the dialog flow
    });
  });
}