import 'package:flutter/material.dart';
import '../models/gamestats.dart';
import 'animated_dice.dart';

class DiceWidget extends StatefulWidget {
  final GameStats gameStats;
  DiceWidget(this.gameStats);
  @override
  _DiceWidgetState createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0;
        i <
            (widget.gameStats.dice.values.length > 0
                ? widget.gameStats.dice.values.length
                : 5);
        i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                if (!widget.gameStats.isFirstRoll) {
                  widget.gameStats.dice.toggleHold(i);
                  widget.gameStats.notifyListeners();
                }
              },
              child: AnimatedDice(
                value: widget.gameStats.dice[i] ?? 0,
                showFirst: widget.gameStats.dice.isHeld(i),
                key: ValueKey<int>(widget.gameStats.dice[i] ?? 1),
              ),
            ),
          ),
      ],
    );
  }
}
