import 'package:flutter/material.dart';
import 'package:local_hero/local_hero.dart';

import 'widgets.dart';

const _dialNumbersRadius =
    RotaryDialConstants.rotaryRingWidth / 2 -
    (RotaryDialConstants.rotaryRingPadding +
        RotaryDialConstants.dialNumberPadding);

class DialNumber extends StatelessWidget {
  final int number;
  const DialNumber({required this.number, super.key});

  @override
  Widget build(BuildContext context) {
    return LocalHero(
      tag: 'digit_$number',
      child: Container(
        height: _dialNumbersRadius * 2,
        width: _dialNumbersRadius * 2,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
        child: Text(
          '$number',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
