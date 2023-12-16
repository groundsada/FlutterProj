import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/main.dart';
import 'package:mp5/views/home.dart';

void main() {
  testWidgets(
      'SplashScreen displays CircularProgressIndicator and navigates to HomePage',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MyApp(),
    ));

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.runAsync(() async {
      await tester.pump(Duration(seconds: 30));
    });

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    expect(find.byType(HomePage), findsOneWidget);
  });
}
