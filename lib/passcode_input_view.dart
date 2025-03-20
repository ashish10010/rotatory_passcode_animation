import 'package:flutter/material.dart';
import 'package:rotatory_passcode/widgets/input_mode_button.dart';
import 'package:rotatory_passcode/widgets/passcode/passcode_digits.dart';
import 'package:rotatory_passcode/widgets/rotaty_dial_painter/constants.dart';

import 'widgets/widgets.dart';

const _animationDuration = Duration(microseconds: 500);
const _padding = 16.0;

class PasscodeInputView extends StatefulWidget {
  final String expectedCode;
  final VoidCallback onSuccess;
  final VoidCallback onError;
  const PasscodeInputView({
    required this.expectedCode,
    required this.onSuccess,
    required this.onError,
    super.key,
  });

  @override
  State<PasscodeInputView> createState() => _PasscodeInputViewState();
}

class _PasscodeInputViewState extends State<PasscodeInputView> {
  late final List<PasscodeDigit> _passcodeDigitValues;
  var _currentInputIndex = 0;

  var _simpleInputMode = false;

  @override
  void initState() {
    super.initState();
    _resetDigits();
  }

  void _onDigitSelected(int index) {
    final digitValue = _passcodeDigitValues[_currentInputIndex];
    setState(() {
      _passcodeDigitValues[_currentInputIndex++] = digitValue.copyWith(
        value: RotaryDialConstants.inputValues[index],
      );
    });
  }

  void _resetDigits() => setState(() {
    _currentInputIndex = 0;
    _passcodeDigitValues = List.generate(
      widget.expectedCode.length,
      (index) =>
          PasscodeDigit(backgroundColor: Colors.white, fontColor: Colors.white),
      growable: false,
    );
  });

  void _onModeChanged() => setState(() {
    _simpleInputMode = !_simpleInputMode;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            _padding,
            _padding * 3,
            _padding,
            _padding * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter\npasscode'.toUpperCase(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
              Align(
                alignment:
                    _simpleInputMode ? Alignment.center : Alignment.centerRight,
                child: PasscodeDigits(
                  animationDuration: _animationDuration,
                  passcodeDigitsValues: _passcodeDigitValues,
                  simpleInputMode: _simpleInputMode,
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                //to define passcodeinput and rotatory input
                child:
                    _simpleInputMode
                        ? PasscodeInput(onDigitSelected: _onDigitSelected)
                        : const RotaryDialInput(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InputModeButton(
                  animationDuration: _animationDuration,
                  simpleInputMode: _simpleInputMode,
                  onModeChanged: _onModeChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
