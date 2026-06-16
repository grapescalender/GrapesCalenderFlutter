import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';

/// Schedule Section Container
/// Wraps the entire schedule list with rounded corners, subtle background, and padding
/// Inspired by Groww's card containers
class ScheduleSectionContainer extends StatelessWidget {

  const ScheduleSectionContainer({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg), // 16-20 radius
        border: Border.all(
          color: cs.outline.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSpacing.md), // 12-16 padding
        child: child,
      ),
    );
  }
}
