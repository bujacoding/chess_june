import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chess_june/main.dart';

void main() {
  testWidgets('Main menu displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ChessApp());

    expect(find.text('♔ 체스 게임 ♚'), findsOneWidget);
    expect(find.text('게임 시작'), findsOneWidget);
    expect(find.text('Phase 1: 클래식 체스'), findsOneWidget);
  });

  testWidgets('Game screen navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const ChessApp());

    await tester.tap(find.text('게임 시작'));
    await tester.pumpAndSettle();

    expect(find.text('클래식 체스'), findsOneWidget);
    expect(find.text('현재 턴: 백색'), findsOneWidget);
  });
}
