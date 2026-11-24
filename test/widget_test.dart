import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seoul_finance_high_app/main.dart';

void main() {
  testWidgets('shows bundled meals and schedules without a network request', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(412, 917));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      SeoulFinanceApp(initialDate: DateTime(2026, 11, 2)),
    );
    await tester.pumpAndSettle();

    expect(find.text('압맥밥'), findsOneWidget);
    expect(find.text('앱에 저장된 급식과 학사일정을 보여드려요.'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('schedule_card_container')),
        matching: find.byType(ListView),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('meal_next_day_button')));
    await tester.pumpAndSettle();
    expect(find.text('발아현미밥'), findsOneWidget);

    await tester.tap(find.byKey(const Key('meal_prev_day_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('meal_prev_day_button')));
    await tester.pumpAndSettle();
    expect(find.text('저장된 급식 정보가 없어요.'), findsOneWidget);
  });
}
