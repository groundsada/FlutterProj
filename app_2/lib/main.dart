import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/dice.dart';
import 'models/gamestats.dart';
import 'models/scorecard.dart';
import 'views/yahtzee.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameStats(
        dice: Dice(5),
        rollCount: 0,
        isFirstRoll: true,
        maxRolls: 3,
        scoreCard: ScoreCard(),
      ),
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yahtzee',
      theme: ThemeData.dark(),
      home: Scaffold(
          body: Yahtzee()
      ),
    );
  }
}
