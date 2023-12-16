import 'package:flutter/material.dart';
import 'package:mp2/views/scores_view.dart';
import 'package:provider/provider.dart';
import '../models/gamestats.dart';
import 'dice_view.dart';

class Yahtzee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameStats = Provider.of<GameStats>(context);
    gameStats.context = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Yahtzee Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40),
            DiceWidget(gameStats),
            SizedBox(height: 40),
            Text('Rolls Left: ${gameStats.maxRolls - gameStats.rollCount}'),
            SizedBox(height: 10),
            Text('Current Score: ${gameStats.scoreCard.total}'),
            SizedBox(height: 20),
            ScoreWidget(gameStats),
            ElevatedButton(
              onPressed: gameStats.rollCount < gameStats.maxRolls ? () {
                gameStats.rollDice();
              } : null,
              child: Text(gameStats.rollCount < 3 ? 'Roll Dice (Roll ${gameStats.rollCount + 1})' : 'Out of rolls'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                gameStats.resetGame();
              },
              child: Text('Reset Game'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}



