import 'package:flutter/material.dart';
import 'package:local_hero/local_hero.dart';

const _passcodeDigitPadding = 8.0;
const _passcodeDigitSizeBig = 36.0;
const _passcodeDigitSizeSmall = 24.0;
const _passcodeDigitGapBig = 16.0;
const _passcodeDigitGapSmall = 4.0;

class PasscodeDigit {
  final Color backgroundColor;
  final Color fontColor;
  final int? value;
  PasscodeDigit({
    required this.backgroundColor,
    required this.fontColor,
    this.value,
  });

  PasscodeDigit copyWith({
    Color? backgroundColor,
    Color? fontColor,
    int? value,
  }) => PasscodeDigit(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    fontColor: fontColor ?? this.fontColor,
    value: value ?? this.value,
  );
}

class PasscodeDigits extends StatelessWidget {
  final Duration animationDuration;
  final List<PasscodeDigit> passcodeDigitsValues;
  final bool simpleInputMode;
  const PasscodeDigits({
    required this.animationDuration,
    required this.passcodeDigitsValues,
    required this.simpleInputMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _passcodeDigitSizeBig,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (var i = 0; i < passcodeDigitsValues.length; i++)
            LocalHero(tag: 'passcode_digit_$i', child: Center()),
        ],
      ),
    );
  }
}

class _PasswordDigitContainer extends StatelessWidget {
  final Duration animationDuration;
  final Color backgroundColor;
  final Color fontColor;
  final int? digit;
  final double size;
  const _PasswordDigitContainer({
    required this.animationDuration,
    required this.backgroundColor,
    required this.fontColor,
    required this.digit,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
