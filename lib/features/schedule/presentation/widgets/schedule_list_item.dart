import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/theme/app_status_colors.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../domain/entities/schedule_entity.dart';

/// Modern Schedule List Item
///
/// Layout:
/// ┌─────────────────────────────────────────────────────┐
/// │  [icon]  Title                       [status chip]  │
/// │          Mon, Jan 06  ·  Day 12       In 3 days     │
/// └─────────────────────────────────────────────────────┘
///
/// Design rules:
///  - Zero hardcoded fontSize / Color — every token comes from
///    AppTypography or AppColors.
///  - Left-accent bar marks schedule type visually.
///  - Status chip uses pill shape (radiusFull) and AppStatusColors.
///  - Touch target ≥ 48 pt (vertical padding ensures this).
class ScheduleListItem extends StatelessWidget {
  const ScheduleListItem({
    Key? key,
    required this.schedule,
    this.onTap,
    this.pruningDate,
  }) : super(key: key);

  final ScheduleEntity schedule;
  final VoidCallback? onTap;

  /// When provided, shows "Day N" instead of relative date
  final DateTime? pruningDate;

  // ── Type helpers ──────────────────────────────────────────────────────────

  Color _typeColor(BuildContext ctx) {
    switch (schedule.type) {
      case ScheduleType.spray:
        return AppColors.info;
      case ScheduleType.nutrition:
        return AppColors.warning;
      case ScheduleType.work:
        return AppColors.success;
      default:
        return AppColors.onSurface;
    }
  }

  // ── Status helpers ─────────────────────────────────────────────────────────

  bool get _isCompleted => schedule.isCompleted;

  bool get _isToday {
    final now = DateTime.now();
    final d = schedule.scheduledDate;
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  bool get _isOverdue {
    if (_isCompleted) return false;
    final now = DateTime.now();
    final d = schedule.scheduledDate;
    return DateTime(d.year, d.month, d.day)
        .isBefore(DateTime(now.year, now.month, now.day));
  }

  bool get _isTomorrow {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final d = schedule.scheduledDate;
    return d.year == tomorrow.year &&
        d.month == tomorrow.month &&
        d.day == tomorrow.day;
  }

  String get _scheduleStatusLabel {
    if (_isCompleted) return 'Completed';
    if (_isOverdue || _isToday) return 'Pending';
    return 'Upcoming';
  }

  Color _statusColor(BuildContext ctx) {
    final sc = Theme.of(ctx).extension<AppStatusColors>()!;
    if (_isCompleted) return sc.completed;
    if (_isOverdue || _isToday) return AppColors.warning;
    return sc.upcoming;
  }

  String get _dueStatusLabel {
    if (_isCompleted) return 'Completed';
    if (_isToday) return 'Due Today';
    if (_isTomorrow) return 'Due Tomorrow';
    if (_isOverdue) return 'Overdue';
    return 'Upcoming';
  }

  // ── Day count ──────────────────────────────────────────────────────────────

  int? _dayCount() {
    if (pruningDate == null) return null;
    final schDay = DateTime(schedule.scheduledDate.year,
        schedule.scheduledDate.month, schedule.scheduledDate.day);
    final pruneDay =
        DateTime(pruningDate!.year, pruningDate!.month, pruningDate!.day);
    final diff = schDay.difference(pruneDay).inDays;
    return diff > 0 ? diff : null;
  }

  String _activityLabel() {
    if (schedule.activityIds.isEmpty) return 'Not linked';
    final raw = schedule.activityIds.first.split('_').last;
    return raw
        .split(RegExp('[-_\\s]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tc = _typeColor(context);
    final sc = _statusColor(context);
    final dayAfterPruning =
        _dayCount() == null ? 'Not set' : 'Day ${_dayCount()}';
    final activityLabel = _activityLabel();

    return DashboardCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.smMd,
        vertical: AppSpacing.sm,
      ),
      radius: AppSpacing.radiusSm,
      borderColor: AppColors.outlineVariant,
      showShadow: false,
      color: AppColors.surface,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 58,
            decoration: BoxDecoration(
              color: tc,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        schedule.title,
                        style: AppTypography.headlineSmall(context).copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    DashboardPill(
                      label: _scheduleStatusLabel,
                      color: sc,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: schedule.plotName),
                      const TextSpan(text: ' • '),
                      TextSpan(
                        text: dayAfterPruning,
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$activityLabel Stage',
                        style: AppTypography.bodyMedium(context).copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                      const TextSpan(text: ' • '),
                      TextSpan(text: schedule.type.displayName),
                    ],
                  ),
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _dueStatusLabel,
                  style: AppTypography.labelSmall(context).copyWith(
                    color: _dueStatusColor(context),
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _dueStatusColor(BuildContext context) {
    if (_isCompleted) return _statusColor(context);
    if (_isOverdue) return AppColors.error;
    if (_isToday || _isTomorrow) return AppColors.primary;
    return AppColors.onSurfaceVariant;
  }
}
