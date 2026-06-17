import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../../../core/design_system/theme/app_status_colors.dart';
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
    final semantic = Theme.of(ctx).extension<AppSemanticColors>()!;
    switch (schedule.type) {
      case ScheduleType.spray:
        return semantic.info;
      case ScheduleType.nutrition:
        return semantic.warning;
      case ScheduleType.work:
        return Theme.of(ctx).colorScheme.primary;
      default:
        return AppColors.onSurface;
    }
  }

  IconData get _typeIcon {
    switch (schedule.type) {
      case ScheduleType.spray:
        return Icons.water_drop_rounded;
      case ScheduleType.nutrition:
        return Icons.grass_rounded;
      case ScheduleType.work:
        return Icons.handyman_rounded;
      default:
        return Icons.event_note_rounded;
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

  bool get _isUpcoming => !_isCompleted && !_isOverdue && !_isToday;

  String get _statusLabel {
    if (_isCompleted) return 'Done';
    if (_isToday) return 'Today';
    if (_isOverdue) return 'Overdue';
    return 'Upcoming';
  }

  Color _statusColor(BuildContext ctx) {
    final sc = Theme.of(ctx).extension<AppStatusColors>()!;
    if (_isCompleted) return sc.completed;
    if (_isToday) return Theme.of(ctx).colorScheme.primary;
    if (_isOverdue) return AppColors.error;
    return sc.upcoming;
  }

  Color _statusBg(BuildContext ctx) {
    if (_isCompleted) return AppColors.successLight;
    if (_isToday) return AppColors.primaryContainer;
    if (_isOverdue) return AppColors.errorLight;
    return AppColors.surfaceVariant;
  }

  // ── Day count ──────────────────────────────────────────────────────────────

  int? _dayCount() {
    if (pruningDate == null) return null;
    final schDay = DateTime(schedule.scheduledDate.year,
        schedule.scheduledDate.month, schedule.scheduledDate.day);
    final pruneDay = DateTime(
        pruningDate!.year, pruningDate!.month, pruningDate!.day);
    final diff = schDay.difference(pruneDay).inDays;
    return diff > 0 ? diff : null;
  }

  // ── Date formatting ────────────────────────────────────────────────────────

  String _primaryDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = schedule.scheduledDate;
    final dateOnly = DateTime(d.year, d.month, d.day);
    final diff = dateOnly.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff > 1 && diff <= 7) return DateFormat('EEE, d MMM').format(d);
    return DateFormat('d MMM yyyy').format(d);
  }

  String _secondaryLabel() {
    final day = _dayCount();
    if (day != null) return 'Day $day';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = schedule.scheduledDate;
    final diff = DateTime(d.year, d.month, d.day).difference(today).inDays;
    if (diff == 0) return '';
    if (diff > 0) return 'in $diff days';
    return '${-diff}d ago';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tc = _typeColor(context);
    final sc = _statusColor(context);
    final sbg = _statusBg(context);
    final secondary = _secondaryLabel();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        splashColor: tc.withValues(alpha: 0.06),
        highlightColor: tc.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smMd,
            vertical: AppSpacing.smMd,
          ),
          child: Row(
            children: [
              // ── Left accent bar ─────────────────────────────────────
              Container(
                width: 3,
                height: 38,
                decoration: BoxDecoration(
                  color: tc,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),

              const SizedBox(width: AppSpacing.smMd),

              // ── Type icon badge ────────────────────────────────────
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tc.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(_typeIcon, size: 16, color: tc),
              ),

              const SizedBox(width: AppSpacing.smMd),

              // ── Title + date row ───────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      schedule.title,
                      style: AppTypography.titleLarge(context).copyWith(
                        color: AppColors.onBackground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 3),

                    // Date + optional day count
                    Row(
                      children: [
                        Text(
                          _primaryDate(),
                          style: AppTypography.bodySmall(context).copyWith(
                            color: _isToday
                                ? AppColors.primary
                                : AppColors.onSurface,
                            fontWeight: _isToday
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        if (secondary.isNotEmpty) ...[
                          Text(
                            '  ·  ',
                            style: AppTypography.bodySmall(context).copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            secondary,
                            style: AppTypography.labelSmall(context).copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // ── Status pill ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: sbg,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(
                    color: sc.withValues(alpha: 0.20),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dot indicator
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: sc,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _statusLabel,
                      style: AppTypography.labelMedium(context).copyWith(
                        color: sc,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
