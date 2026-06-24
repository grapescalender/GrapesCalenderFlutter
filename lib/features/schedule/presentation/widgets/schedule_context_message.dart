import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';

/// Schedule Context Message Widget
/// Shows information about the date range and day count for filtered schedules
class ScheduleContextMessage extends StatelessWidget {
  const ScheduleContextMessage({
    Key? key,
    this.startDate,
    this.endDate,
    this.startDay,
    this.endDay,
    this.activityName,
  }) : super(key: key);
  final DateTime? startDate;
  final DateTime? endDate;
  final int? startDay;
  final int? endDay;
  final String? activityName;

  @override
  Widget build(BuildContext context) {
    if (startDate == null ||
        endDate == null ||
        startDay == null ||
        endDay == null) {
      return const SizedBox.shrink();
    }

    final isToday = _isToday(endDate!);

    // Build message text
    String message;
    if (activityName != null) {
      message =
          'This includes schedules linked to $activityName between Day $startDay and Day $endDay (${_formatDateRange(startDate!, endDate!, isToday)})';
    } else {
      message =
          'This schedule includes all activities between Day $startDay and Day $endDay (${_formatDateRange(startDate!, endDate!, isToday)})';
    }

    return DashboardCard(
      margin:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColors.background,
      showShadow: false,
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.labelLarge(context).copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatDateRange(DateTime start, DateTime end, bool endIsToday) {
    final startFormatted = DateFormat('d MMM').format(start);
    final endFormatted = endIsToday ? 'Today' : DateFormat('d MMM').format(end);
    return '$startFormatted – $endFormatted';
  }
}
