import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/views/categorylist.dart';

void main() {
  testWidgets('CategoryList widget test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CategoryList(timedMode: false),
    ));

    expect(tester.takeException(), isNull);
  });

  testWidgets('CategoryList app bar test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CategoryList(timedMode: false),
    ));

    expect(find.byType(AppBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('CategoryList category list test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CategoryList(timedMode: false),
    ));

    expect(find.byType(ListView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
