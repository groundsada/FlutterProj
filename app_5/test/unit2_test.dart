import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/views/categorylist.dart';

void main() {
  testWidgets('CategoryList widget renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CategoryList(timedMode: true),
    ));

    expect(find.text('Choose a category'), findsOneWidget);

    expect(find.byType(ListTile), findsWidgets);
  });
}
