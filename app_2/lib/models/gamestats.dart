import 'package:flutter/material.dart';
import 'dice.dart';
import 'scorecard.dart';

class GameStats extends ChangeNotifier {
  final Dice dice;
  int rollCount;
  bool isFirstRoll;
  final int maxRolls;
  final ScoreCard scoreCard;
  BuildContext? _context;

  GameStats({
    required this.dice,
    required this.rollCount,
    required this.isFirstRoll,
    required this.maxRolls,
    required this.scoreCard,
  });

  set context(BuildContext? newContext) {
    _context = newContext;
  }

  BuildContext? get context => _context;

  void rollDice() {
    if (isFirstRoll) {
      dice.roll();
      isFirstRoll = false;
      rollCount++;
    } else if (rollCount < maxRolls) {
      dice.roll();
      rollCount++;
    }
    notifyListeners();
  }

  void resetGame() {
    dice.clear();
    rollCount = 0;
    scoreCard.clear();
    isFirstRoll = true;
    notifyListeners();
  }

  bool checkAndShowFinalScore() {
    return scoreCard.completed;
  }

  int getFinalScore() {
    return scoreCard.total;
  }
  void showFinalScoreDialog() {
    int finalScore = getFinalScore();
    showDialog(
      context: _context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Final Score'),
          content: Text('Your final score is: $finalScore'),
          actions: <Widget>[
            TextButton(
              child: Text('Reset Game'),
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showScoreAlert() {
    if (checkAndShowFinalScore()) {
      showFinalScoreDialog();
    }
  }

  void registerScore(ScoreCategory category) {
    if (!isFirstRoll && scoreCard[category] == null) {
      scoreCard.registerScore(category, dice.values);
      rollCount = 0;
      dice.clear();
      isFirstRoll = true;
      notifyListeners();
    }
  }
}