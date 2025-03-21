import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:rotatory_passcode/utils.dart';
import 'package:rotatory_passcode/widgets/rotaty_dial_painter/constants.dart';

class RotaryDialForegroundPainter extends CustomPainter {
  final double numberRadiusFromCenter;
  final double startAngleOffset;
  final double sweepAngle;

  const RotaryDialForegroundPainter({
    required this.numberRadiusFromCenter,
    required this.startAngleOffset,
    required this.sweepAngle,
  });
  @override
  void paint(Canvas canvas, Size size) {
    const firstDialNumberPosition = RotaryDialConstants.firstDialNumberPosition;
    const ringWidth = RotaryDialConstants.rotaryRingWidth;
    final angleOffset = startAngleOffset * firstDialNumberPosition;

    final paint =
        Paint()
          ..color = const Color.fromARGB(255, 255, 255, 1)
          ..strokeCap = StrokeCap.round
          ..strokeWidth = ringWidth - RotaryDialConstants.rotaryRingPadding * 2
          ..style = PaintingStyle.stroke;

    canvas
      ..saveLayer(Rect.largest, paint)
      ..drawArc(
        Rect.fromCenter(
          center: size.centerOffset,
          width: size.width - ringWidth, //diameter = 2 * radius
          height: size.width - ringWidth,
        ),
        angleOffset + firstDialNumberPosition,
        sweepAngle,
        false,
        paint,
      );
    for (int i = 0; i < 10; i++) {
      final offset = Offset.fromDirection(
        angleOffset + math.pi * (-30 - i * 30) / 180,
        numberRadiusFromCenter,
      );
      canvas.drawCircle(
        size.centerOffset + offset,
        RotaryDialConstants.dialNumberRadius,
        Paint()..blendMode = BlendMode.clear,
      );
    }

    canvas.drawCircle(
      size.centerOffset +
          Offset.fromDirection(math.pi / 6, numberRadiusFromCenter),
      ringWidth / 6,
      Paint()..color =  Color.fromRGBO(255, 255, 255, sweepAngle/ RotaryDialConstants.maxRotaryRingSweepAngle),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(RotaryDialForegroundPainter oldDelegate) =>
      oldDelegate.numberRadiusFromCenter != numberRadiusFromCenter &&
      oldDelegate.startAngleOffset != startAngleOffset &&
      oldDelegate.sweepAngle != sweepAngle;
}
