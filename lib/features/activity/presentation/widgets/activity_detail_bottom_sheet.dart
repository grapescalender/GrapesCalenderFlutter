import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/utils/date_utils.dart' as activity_date_utils;
import '../../../../shared/widgets/app_button.dart';
import '../../domain/entities/activity_entity.dart';

/// Premium Activity Detail Bottom Sheet
/// All original data and navigation behaviour preserved.
class ActivityDetailBottomSheet extends StatelessWidget {
  const ActivityDetailBottomSheet({
    Key? key,
    required this.activity,
    this.pruningDate,
    this.onViewSchedules,
  }) : super(key: key);

  final ActivityEntity activity;
  final DateTime? pruningDate;
  final VoidCallback? onViewSchedules;

  // ── Status helpers ──────────────────────────────────────────────────────
  bool get _isActive => activity.isActive;
  bool get _isCompleted => activity.isCompleted;

  Color _accentColor(BuildContext context) {
    if (_isActive) return AppColors.primary;
    if (_isCompleted) return AppColors.success;
    return AppColors.onSurface;
  }

  Color _accentBg(BuildContext context) {
    if (_isActive) return AppColors.primaryContainer;
    if (_isCompleted) return AppColors.successLight;
    return AppColors.background;
  }

  String get _statusLabel {
    if (_isActive) return 'In Progress';
    if (_isCompleted) return 'Completed';
    return 'Upcoming';
  }

  IconData get _statusIcon {
    if (_isActive) return Icons.radio_button_checked_rounded;
    if (_isCompleted) return Icons.check_circle_rounded;
    return Icons.radio_button_unchecked_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Day calculations
    final startDay = activity.startedAt != null && pruningDate != null
        ? activity_date_utils.ActivityDateUtils.calculateDay(
            pruningDate!, activity.startedAt!)
        : null;
    final endDate = _isActive ? DateTime.now() : activity.completedAt;
    final endDay = endDate != null && pruningDate != null
        ? activity_date_utils.ActivityDateUtils.calculateDay(
            pruningDate!, endDate)
        : null;
    final duration = activity.startedAt != null && endDate != null
        ? endDate.difference(activity.startedAt!).inDays + 1
        : 0;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ───────────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),

            // ── Hero header ──────────────────────────────────────────────
            _Header(
              activity: activity,
              statusLabel: _statusLabel,
              statusIcon: _statusIcon,
              accentColor: _accentColor(context),
              accentBg: _accentBg(context),
            ),

            // ── Metrics strip ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal, vertical: 12),
              child: Row(
                children: [
                  if (duration > 0)
                    _MetricTile(
                      icon: Icons.hourglass_bottom_rounded,
                      label: 'Duration',
                      value: '$duration days',
                    ),
                  if (duration > 0 && startDay != null)
                    const SizedBox(width: AppSpacing.smMd),
                  if (startDay != null)
                    _MetricTile(
                      icon: Icons.calendar_today_rounded,
                      label: 'Start Day',
                      value: 'Day $startDay',
                    ),
                  if (startDay != null && endDay != null)
                    const SizedBox(width: AppSpacing.smMd),
                  if (endDay != null)
                    _MetricTile(
                      icon: _isActive
                          ? Icons.schedule_rounded
                          : Icons.event_available_rounded,
                      label: _isActive ? 'Today' : 'End Day',
                      value: 'Day $endDay',
                      highlight: _isActive,
                    ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.outline),

            // ── Details list ─────────────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.md,
                    AppSpacing.screenHorizontal,
                    AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (activity.startedAt != null)
                      _DetailRow(
                        icon: Icons.play_circle_outline_rounded,
                        label: 'Start Date',
                        value: _formatDate(activity.startedAt!),
                        sub: startDay != null ? 'Day $startDay' : null,
                      ),
                    if (activity.startedAt != null)
                      const SizedBox(height: AppSpacing.smMd),
                    if (_isCompleted && activity.completedAt != null)
                      _DetailRow(
                        icon: Icons.check_circle_outline_rounded,
                        label: 'End Date',
                        value: _formatDate(activity.completedAt!),
                        sub: endDay != null ? 'Day $endDay' : null,
                      ),
                    if (_isActive)
                      _DetailRow(
                        icon: Icons.schedule_rounded,
                        label: 'Ongoing until',
                        value: 'Today',
                        sub: endDay != null ? 'Day $endDay' : null,
                        highlight: true,
                      ),
                    if (_isCompleted || _isActive)
                      const SizedBox(height: AppSpacing.smMd),
                    _DetailRow(
                      icon: Icons.agriculture_rounded,
                      label: 'Plot',
                      value: activity.plotName.isNotEmpty
                          ? activity.plotName
                          : '—',
                    ),
                  ],
                ),
              ),
            ),

            // ── CTA ──────────────────────────────────────────────────────
            if (onViewSchedules != null) ...[
              const Divider(height: 1, color: AppColors.outline),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                child: AppButton.primary(
                  label: 'View Related Schedules',
                  onPressed: () {
                    Navigator.of(context).pop();
                    onViewSchedules?.call();
                  },
                  isFullWidth: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => DateFormat('d MMM yyyy').format(d);
}

// ── Hero Header ─────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header({
    required this.activity,
    required this.statusLabel,
    required this.statusIcon,
    required this.accentColor,
    required this.accentBg,
  });

  final ActivityEntity activity;
  final String statusLabel;
  final IconData statusIcon;
  final Color accentColor;
  final Color accentBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal, 12,
          AppSpacing.xs, 12),
      decoration: BoxDecoration(
        color: accentBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusHuge),
          topRight: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      child: Row(
        children: [
          // Activity icon badge
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                  color: accentColor.withValues(alpha: 0.2), width: 1),
            ),
            child: Icon(activity.type.icon, color: accentColor, size: 26),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.type.displayName,
                  style: AppTypography.headlineMedium(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(
                        color: accentColor.withValues(alpha: 0.2), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: accentColor),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel,
                        style: AppTypography.bodySmall(context).copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Close
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
            iconSize: 20,
            color: AppColors.onSurface,
          ),
        ],
      ),
    );
  }
}

// ── Metric Tile ──────────────────────────────────────────────────────────────
class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final color = highlight ? AppColors.primary : AppColors.onBackground;
    final bg = highlight ? AppColors.primaryContainer : AppColors.background;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTypography.headlineSmall(context).copyWith(
                fontWeight: FontWeight.w800,
                color: color,
                fontSize: 15,
              ),
            ),
            Text(
              label,
              style: AppTypography.bodySmall(context).copyWith(
                color: AppColors.onSurface,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Detail Row ───────────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.sub,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? sub;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final color =
        highlight ? AppColors.primary : AppColors.onBackground;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, size: 16, color: AppColors.onSurface),
        ),
        const SizedBox(width: AppSpacing.smMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.bodySmall(context).copyWith(
                  color: AppColors.onSurface,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    value,
                    style: AppTypography.titleSmall(context).copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (sub != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull),
                      ),
                      child: Text(
                        sub!,
                        style: AppTypography.bodySmall(context).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
