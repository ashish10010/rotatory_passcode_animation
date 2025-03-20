import 'package:flutter/material.dart';

class PasscodeInput extends StatelessWidget {
  final ValueSetter<int> onDigitSelected;
  const PasscodeInput({required this.onDigitSelected, super.key});

  @override
  Widget build(BuildContext context) {
    const alignment = MainAxisAlignment.spaceEvenly;
    return Column(
      mainAxisAlignment: alignment,
      children: [
        for(var i = 0; i< 3; i++)
        Row(
          mainAxisAlignment: alignment,
          children: [
            for(var j = 0; j<3; j++) _renderDialNumber(i*3 + j),
          ],
        ),
        _renderDialNumber(9)
      ],
    );
  }

  Widget _renderDialNumber(int index) =>
      GestureDetector(onTap: () => onDigitSelected(index), child: Center());
}
