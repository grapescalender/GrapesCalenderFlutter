import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      case ScheduleType.water:
        return AppColors.primary;
      case ScheduleType.work:
        return AppColors.success;
      default:
        return AppColors.onSurface;
    }
  }

  IconData get _typeIcon {
    switch (schedule.type) {
      case ScheduleType.spray:
        return Icons.water_drop_outlined;
      case ScheduleType.nutrition:
        return Icons.grass_outlined;
      case ScheduleType.water:
        return Icons.water_outlined;
      case ScheduleType.work:
        return Icons.construction_outlined;
      default:
        return Icons.list_outlined;
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

  String _scheduleDateLabel() =>
      DateFormat('dd MMM yyyy').format(schedule.scheduledDate);

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tc = _typeColor(context);
    final sc = _statusColor(context);
    final dayAfterPruning =
        _dayCount() == null ? 'Not set' : 'Day ${_dayCount()}';
    final activityLabel = _activityLabel();

    return DashboardCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      radius: AppSpacing.radiusSm,
      borderColor: AppColors.outlineVariant,
      showShadow: false,
      color: AppColors.surface,
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 8,
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
                  Text(
                    schedule.title,
                    style: AppTypography.titleMedium(context).copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _scheduleDateLabel(),
                              style: AppTypography.bodyMedium(context).copyWith(
                                color: AppColors.onSurfaceVariant,
                                height: 1.15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              activityLabel,
                              style: AppTypography.bodyMedium(context).copyWith(
                                color: AppColors.onBackground,
                                height: 1.15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: DashboardPill(
                                label: _scheduleStatusLabel,
                                color: sc,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              DashboardPill(
                                label: dayAfterPruning,
                                color: AppColors.primary,
                              ),
                              _ScheduleTypeTag(
                                label: schedule.type.displayName,
                                color: tc,
                                icon: _typeIcon,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTypeTag extends StatelessWidget {
  const _ScheduleTypeTag({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
            child: Icon(icon, size: 12, color: color),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelLarge(context).copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
