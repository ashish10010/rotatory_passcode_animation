import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rotatory_passcode/utils.dart';
import 'package:rotatory_passcode/widgets/widgets.dart';

class RotaryDialInput extends StatefulWidget {
  final Duration animationDuration;
  final AnimationController modeChangeController;
  final bool passcodeAnimationInProgress;
  final ValueSetter<int> onDigitSelected;
  final AsyncCallback onValidatePasscode;
  const RotaryDialInput({
    required this.modeChangeController,
    required this.passcodeAnimationInProgress,
    required this.animationDuration,
    required this.onDigitSelected,
    required this.onValidatePasscode,
    super.key,
  });

  @override
  State<RotaryDialInput> createState() => _RotaryDialInputState();
}

class _RotaryDialInputState extends State<RotaryDialInput>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dialController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _rotaryDialForegroundAnimation;
  late Animation<double> _rotaryDialBackgroundAnimation;

  var _currentDragOffset = Offset.zero;
  var _startAngleOffset = 0.0;

  bool get _isAnimating =>
      _dialController.isAnimating ||
      widget.modeChangeController.isAnimating ||
      widget.passcodeAnimationInProgress;

  @override
  void initState() {
    super.initState();
    _dialController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..addListener(
      () => setState(() => _startAngleOffset = _rotationAnimation.value),
    );

    _rotaryDialForegroundAnimation = Tween<double>(
      begin: RotaryDialConstants.maxRotaryRingSweepAngle,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: widget.modeChangeController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _dialController.dispose();
    super.dispose();
  }

  TickerFuture _rotateDialToStart() {
    _rotationAnimation = Tween<double>(
      begin: _startAngleOffset,
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: _dialController, curve: Curves.easeInOut),
    );

    _dialController.reset();

    return _dialController.forward();
  }

  // void _rotateDialToStart() {
  //   setState(() {
  //     _startAngleOffset = 0.0;
  //   });
  // }

  void _onPanStart(DragStartDetails details, Offset centerOffset) {
    if (_isAnimating) return;
    _currentDragOffset = details.localPosition - centerOffset;
  }

  void _onPanUpdate(DragUpdateDetails details, Offset centerOffset) {
    if (_isAnimating) return;
    final previousOffset = _currentDragOffset;
    _currentDragOffset += details.delta;

    final currentDirection = _currentDragOffset.direction;
    final previousDirection = previousOffset.direction;

    if (currentDirection * previousDirection < 0.0) return;
    final angle = _startAngleOffset + currentDirection - previousDirection;

    if (angle < 0.0 || angle >= RotaryDialConstants.maxRotaryRingAngle) return;

    setState(() => _startAngleOffset = angle);
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating) return;
    final offset =
        RotaryDialConstants.firstDialNumberPosition * (_startAngleOffset - 1);
    if (offset < -math.pi / 12) {
      _rotateDialToStart();
      return;
    }
    final numberIndex = ((offset * 180 / math.pi).abs() / 30).round();
    _addDigit(numberIndex);
  }

  void _addDigit(int index) {
    widget.onDigitSelected(index);
    _rotateDialToStart().then((_) async => await widget.onValidatePasscode());
  }

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
                  sweepAngle: _rotaryDialForegroundAnimation.value,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
