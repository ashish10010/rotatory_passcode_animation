import 'package:flutter/material.dart';

class InputModeButton extends StatelessWidget {
  final Duration animationDuration;
  final bool simpleInputMode;
  final VoidCallback onModeChanged;
  const InputModeButton({
    required this.animationDuration,
    required this.simpleInputMode,
    required this.onModeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: _Button(label: 'Original', onTap: onModeChanged),
      secondChild: _Button(label: 'Simplify', onTap: onModeChanged),
      crossFadeState: simpleInputMode ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: animationDuration,
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _Button({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
