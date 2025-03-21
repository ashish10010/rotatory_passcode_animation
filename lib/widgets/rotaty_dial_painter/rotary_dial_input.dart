import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotatory_passcode/utils.dart';
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

  void _rotateDialToStart() {
    setState(() {
      _startAngleOffset = 0.0;
    });
  }

  void _onPanStart(DragStartDetails details, Offset centerOffset) {
    _currentDragOffset = details.localPosition - centerOffset;
  }

  void _onPanUpdate(DragUpdateDetails details, Offset centerOffset) {
    final previousOffset = _currentDragOffset;
    _currentDragOffset += details.delta;

    final currentDirection = _currentDragOffset.direction;
    final previousDirection = previousOffset.direction;

    if (currentDirection * previousDirection < 0.0) return;
    final angle = _startAngleOffset + currentDirection - previousDirection;

    if (angle < 0.0 || angle >= RotaryDialConstants.maxRotaryRingAngle) return;

    setState(() => _startAngleOffset = angle);
  }

  void _onPanEnd(DragEndDetails details) {}

  @override
  Widget build(BuildContext context) {
    const inputValues = RotaryDialConstants.inputValues;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final size = Size(width, width);
        final centerOffset = size.centerOffset;
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
            GestureDetector(
              onPanStart: (detials) => _onPanStart(detials, centerOffset),
              onPanUpdate: (detials) => _onPanUpdate(detials, centerOffset),

              onPanEnd: _onPanEnd,
              child: CustomPaint(
                size: size,
                painter: RotaryDialForegroundPainter(
                  numberRadiusFromCenter: dialNumberDistanceFromCenter,
                  startAngleOffset: _startAngleOffset,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
