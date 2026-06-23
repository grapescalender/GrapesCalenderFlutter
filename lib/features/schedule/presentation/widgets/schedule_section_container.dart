import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/dashboard_design.dart';

/// Schedule Section Container
/// Wraps the schedule module with rounded corners, subtle background, and padding.
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
    return DashboardCard(
      margin:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      padding: padding ?? const EdgeInsets.all(AppSpacing.smMd),
      child: child,
    );
  }
}
