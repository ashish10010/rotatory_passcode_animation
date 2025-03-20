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

  var _passcodeAnimationInProgress = false;

  bool get _isAnimating => _passcodeAnimationInProgress;

  @override
  void initState() {
    super.initState();
    _resetDigits();
  }

  void _onDigitSelected(int index) {
    if (_isAnimating) return;
    final digitValue = _passcodeDigitValues[_currentInputIndex];
    setState(() {
      _passcodeDigitValues[_currentInputIndex++] = digitValue.copyWith(
        value: RotaryDialConstants.inputValues[index],
      );
    });
    _validatePasscode();
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

  Future<void> _validatePasscode() async {
    if (_isAnimating) return;
    final expectedCode = widget.expectedCode;

    if (_currentInputIndex != expectedCode.length) return;

    final interval = _animationDuration.inMilliseconds ~/ expectedCode.length;
    final codeInput = _passcodeDigitValues.fold<String>(
      '',
      (code, element) => code += element.value?.toString() ?? '',
    );
    _togglePasscodeAnimation();
    if (codeInput == expectedCode) {
      await _changePasscodeDigitColors(
        backgroundColor: Colors.green,
        fontColor: Colors.transparent,
        interval: interval,
      );
      widget.onSuccess();
    } else {
      widget.onError();
    }
    await Future.delayed(_animationDuration);
    _resetDigits();
    _togglePasscodeAnimation();
  }

  Future<void> _changePasscodeDigitColors({
    Color? backgroundColor,
    Color? fontColor,
    int interval = 0,
  }) async {
    for (var i = 0; i < _passcodeDigitValues.length; i++) {
      await Future.delayed(Duration(microseconds: interval));

      setState(() {
        if (backgroundColor != null) {
          _passcodeDigitValues[i] = _passcodeDigitValues[i].copyWith(
            backgroundColor: backgroundColor,
          );
        }
        if (fontColor != null) {
          _passcodeDigitValues[i] = _passcodeDigitValues[i].copyWith(
            fontColor: fontColor,
          );
        }
      });
    }
  }

  void _togglePasscodeAnimation() => setState(
    () => _passcodeAnimationInProgress = !_passcodeAnimationInProgress,
  );

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
