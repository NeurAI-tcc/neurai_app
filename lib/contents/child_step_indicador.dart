import 'package:flutter/material.dart';

class ChildStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ChildStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
        (index) {
          final step = index + 1;

          return Row(
            children: [
              _Step(
                number: step,
                active: step == currentStep,
              ),

              if (step != totalSteps)
                const _Line(),
            ],
          );
        },
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final int number;
  final bool active;

  const _Step({
    required this.number,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? const Color(0xFF5796E8)
            : const Color(0xFFD0D0D0),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: active
              ? Colors.white
              : const Color(0xFF555555),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 1,
      color: const Color(0xFFC8C8C8),
    );
  }
}