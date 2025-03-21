import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rotatory_passcode/widgets/widgets.dart';

class RotaryDialInput extends StatefulWidget {
  final ValueSetter<int> onDigitSelected;
  final AsyncCallback onValidatePasscode;
  const RotaryDialInput({
    required this.onDigitSelected,
    required this.onValidatePasscode,
    super.key,
  });

  @override
  State<RotaryDialInput> createState() => _RotaryDialInputState();
}

class _RotaryDialInputState extends State<RotaryDialInput> {
  var _currentDragOffset = Offset.zero;
  var _startAngleOffset = 0.0;
  @override
  Widget build(BuildContext context) {
    const inputValues = RotaryDialConstants.inputValues;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final size = Size(width, width);
        final dialNumberDistanceFromCenter =
            width / 2 -
            16.0 -
            RotaryDialConstants.rotaryRingPadding -
            RotaryDialConstants.dialNumberPadding;
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: size,
              painter: const RotaryDialBackgroundPainter(), //todo,
            ),
            for (var i = 0; i < inputValues.length; i++)
              Transform.translate(
                offset: Offset.fromDirection(
                  (i + 1) * -math.pi / 6,
                  dialNumberDistanceFromCenter,
                ),
                child: DialNumber(number: inputValues[i]),
              ),
            CustomPaint(
              size: size,
              painter: RotaryDialForegroundPainter(
                numberRadiusFromCenter: dialNumberDistanceFromCenter,
                startAngleOffset: _startAngleOffset,
              ),
            ),
          ],
        );
      },
    );
  }
}
