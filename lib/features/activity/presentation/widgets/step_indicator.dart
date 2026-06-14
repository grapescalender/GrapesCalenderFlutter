import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';

/// Activity step state enum (renamed from StepState to avoid conflict with Material's Stepper)
enum ActivityStepState {
  completed,
  current,
  upcoming,
}

/// Reusable Step Indicator Widget
/// Can be used in both horizontal and vertical steppers
class StepIndicator extends StatelessWidget {
  final ActivityStepState state;
  final int stepNumber;
  final IconData? icon;
  final bool isLast;
  final VoidCallback? onTap;
  final bool isClickable;
  final double size;

  const StepIndicator({
    Key? key,
    required this.state,
    required this.stepNumber,
    this.icon,
    this.isLast = false,
    this.onTap,
    this.isClickable = true,
    this.size = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final canTap = isClickable && (state == ActivityStepState.completed || state == ActivityStepState.current);

    return GestureDetector(
      onTap: canTap ? onTap : null,
      child: MouseRegion(
        cursor: canTap ? SystemMouseCursors.click : MouseCursor.defer,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getBackgroundColor(cs),
            border: Border.all(
              color: _getBorderColor(cs),
              width: state == ActivityStepState.upcoming ? 2.0 : 0.0,
            ),
            boxShadow: state == ActivityStepState.current
                ? [
                    BoxShadow(
                      color: cs.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: _buildContent(cs),
          ),
        ),
      ),
    );
  }

  /// Get background color based on state
  Color _getBackgroundColor(ColorScheme cs) {
    switch (state) {
      case ActivityStepState.completed:
        return cs.secondary; // Green/Success
      case ActivityStepState.current:
        return cs.primary; // Indigo
      case ActivityStepState.upcoming:
        return Colors.transparent;
    }
  }

  /// Get border color based on state
  Color _getBorderColor(ColorScheme cs) {
    switch (state) {
      case ActivityStepState.completed:
        return cs.secondary;
      case ActivityStepState.current:
        return cs.primary;
      case ActivityStepState.upcoming:
        return cs.outlineVariant;
    }
  }

  /// Build the content inside the circle
  Widget _buildContent(ColorScheme cs) {
    switch (state) {
      case ActivityStepState.completed:
        return Icon(
          Icons.check,
          color: Colors.white,
          size: size * 0.5,
        );
      case ActivityStepState.current:
        return Text(
          stepNumber.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        );
      case ActivityStepState.upcoming:
        return Text(
          stepNumber.toString(),
          style: TextStyle(
            color: cs.outlineVariant,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }
}
