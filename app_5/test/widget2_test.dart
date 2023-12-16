import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/views/categorylist.dart';

void main() {
  testWidgets('CategoryList displays app bar with correct title',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CategoryList(timedMode: false)));

    expect(find.text('Choose a category'), findsOneWidget);
  });

  testWidgets('CategoryList displays category list',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CategoryList(timedMode: false)));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('CategoryList displays correct app bar background color',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CategoryList(timedMode: false)));

    expect(
      tester.widget<AppBar>(find.byType(AppBar)).backgroundColor,
      equals(Colors.yellow[700]),
    );
  });

  testWidgets('CategoryList displays correct category text color',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CategoryList(timedMode: false)));

    expect(
      tester.widget<Text>(find.byType(Text).first).style?.color,
      equals(Colors.white),
    );
  });
}
