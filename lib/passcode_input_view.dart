import 'package:flutter/material.dart';

const _animationDuration = Duration(microseconds: 500);
const _padding = 16.0;

class PasscodeInputView extends StatefulWidget {
  final String expectedCode;
  const PasscodeInputView({required this.expectedCode, super.key});

  @override
  State<PasscodeInputView> createState() => _PasscodeInputViewState();
}

class _PasscodeInputViewState extends State<PasscodeInputView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
