import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';

/// Schedule Context Message Widget
/// Shows information about the date range and day count for filtered schedules
class ScheduleContextMessage extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final int? startDay;
  final int? endDay;
  final String? activityName;

  const ScheduleContextMessage({
    Key? key,
    this.startDate,
    this.endDate,
    this.startDay,
    this.endDay,
    this.activityName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (startDate == null || endDate == null || startDay == null || endDay == null) {
      return const SizedBox.shrink();
    }

    final cs = Theme.of(context).colorScheme;
    final isToday = _isToday(endDate!);

    // Build message text
    String message;
    if (activityName != null) {
      message = 'This includes schedules linked to $activityName between Day $startDay and Day $endDay (${_formatDateRange(startDate!, endDate!, isToday)})';
    } else {
      message = 'This schedule includes all activities between Day $startDay and Day $endDay (${_formatDateRange(startDate!, endDate!, isToday)})';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: cs.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall(context).copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 12,
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
