import 'package:flutter/cupertino.dart';

class AnimatedDice extends StatelessWidget {
  final int value;
  final bool showFirst;
  final Key key;
  AnimatedDice({required this.value, required this.showFirst, required this.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Image.asset(
        'assets/images/dice${value ?? 1}_1.png',
        key: ValueKey<int>(value ?? 1),
        width: 100,
        height: 100,
      ),
      secondChild: Image.asset(
        'assets/images/dice${value ?? 1}_2.png',
        key: ValueKey<int>(value ?? 1),
        width: 100,
        height: 100,
      ),
      crossFadeState: showFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 400),
    );
  }
}