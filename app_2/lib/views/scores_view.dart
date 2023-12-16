import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/gamestats.dart';
import '../models/scorecard.dart';

class ScoreWidget extends StatelessWidget {
  final GameStats gameStats;
  ScoreWidget(this.gameStats);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
        ),
        itemCount: ScoreCategory.values.length,
        itemBuilder: (BuildContext context, int index) {
          ScoreCategory category = ScoreCategory.values[index];
          bool hasScore = gameStats.scoreCard[category] != null;
          return GestureDetector(
            onTap: () {
              if (!gameStats.isFirstRoll && gameStats.scoreCard[category] == null) {
                gameStats.scoreCard.registerScore(category, gameStats.dice.values);
                gameStats.rollCount = 0;
                gameStats.dice.clear();
                gameStats.isFirstRoll = true;
                gameStats.showScoreAlert();
                gameStats.notifyListeners();
              }
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category.name),
                  Divider(),
                  Text(
                    hasScore
                        ? 'Score: ${gameStats.scoreCard[category]}'
                        : 'Pick',
                    style: TextStyle(
                      color: hasScore ? Colors.green : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
