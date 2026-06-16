import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';

/// Activity step state enum
enum ActivityStepState { completed, current, upcoming }

/// Modern pill-shaped step indicator
class StepIndicator extends StatelessWidget {
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

  final ActivityStepState state;
  final int stepNumber;
  final IconData? icon;
  final bool isLast;
  final VoidCallback? onTap;
  final bool isClickable;
  final double size;

  @override
  Widget build(BuildContext context) {
    final canTap = isClickable &&
        (state == ActivityStepState.completed ||
            state == ActivityStepState.current);

    return GestureDetector(
      onTap: canTap ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _bg,
          border: state == ActivityStepState.upcoming
              ? Border.all(color: AppColors.outline, width: 1.5)
              : null,
          boxShadow: state == ActivityStepState.current
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(child: _buildIcon),
      ),
    );
  }

  Color get _bg {
    switch (state) {
      case ActivityStepState.completed:
        return AppColors.success;
      case ActivityStepState.current:
        return AppColors.primary;
      case ActivityStepState.upcoming:
        return AppColors.surface;
    }
  }

  Widget get _buildIcon {
    switch (state) {
      case ActivityStepState.completed:
        return Icon(Icons.check_rounded, color: Colors.white, size: size * 0.48);
      case ActivityStepState.current:
        return icon != null
            ? Icon(icon, color: Colors.white, size: size * 0.48)
            : Text(
                '$stepNumber',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w700,
                ),
              );
      case ActivityStepState.upcoming:
        return Text(
          '$stepNumber',
          style: TextStyle(
            color: AppColors.onSurface,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w500,
          ),
        );
    }
  }
}
