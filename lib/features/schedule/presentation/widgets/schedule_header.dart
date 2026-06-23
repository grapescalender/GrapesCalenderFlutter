import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/dashboard_design.dart';

/// Schedule Header Widget
/// Clean header with title on left and Add Schedule icon button on right
/// Minimal, inline design
class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.onAddTap,
    this.horizontalPadding = AppSpacing.screenHorizontal,
  }) : super(key: key);
  final String title;
  final String? subtitle;
  final VoidCallback? onAddTap;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionHeader(
      icon: Icons.calendar_month_rounded,
      title: title,
      subtitle: subtitle,
      horizontalPadding: horizontalPadding,
      action: onAddTap == null
          ? null
          : DashboardIconButton(
              icon: Icons.add_rounded,
              onTap: onAddTap!,
              tooltip: 'Add Schedule',
            ),
    );
  }
}
