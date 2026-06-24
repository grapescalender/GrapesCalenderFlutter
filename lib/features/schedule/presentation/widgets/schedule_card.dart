import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../domain/entities/schedule_entity.dart';

/// Schedule Card Widget
/// Displays schedule information in a card format
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    Key? key,
    required this.schedule,
    this.onTap,
  }) : super(key: key);
  final ScheduleEntity schedule;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    return DashboardCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Type Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getTypeColor(context, schedule.type)
                      .withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  _getTypeIcon(schedule.type),
                  color: _getTypeColor(context, schedule.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Title and Type
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.title,
                      style: AppTypography.cardTitle(context).copyWith(
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      schedule.type.displayName,
                      style: AppTypography.chipText(context).copyWith(
                        color: _getTypeColor(context, schedule.type),
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              if (schedule.isCompleted)
                DashboardPill(
                  label: 'Done',
                  color: semantic.success,
                  icon: Icons.check_circle_rounded,
                ),
            ],
          ),
          if (schedule.description != null &&
              schedule.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              schedule.description!,
              style: AppTypography.bodySmall(context).copyWith(
                color: cs.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          // Date Row
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _formatDate(schedule.scheduledDate),
                style: AppTypography.body(context).copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Icon(
                Icons.access_time_outlined,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _formatTime(schedule.scheduledDate),
                style: AppTypography.caption(context).copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(BuildContext context, ScheduleType type) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    if (type == ScheduleType.spray) return semantic.info;
    if (type == ScheduleType.nutrition) return semantic.warning;
    if (type == ScheduleType.work) return cs.primary;
    return cs.onSurface;
  }

  IconData _getTypeIcon(ScheduleType type) {
    if (type == ScheduleType.spray) {
      return Icons.water_drop_outlined;
    } else if (type == ScheduleType.nutrition) {
      return Icons.grass_outlined;
    } else if (type == ScheduleType.work) {
      return Icons.construction_outlined;
    } else {
      return Icons.list_outlined;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final difference = dateOnly.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0 && difference <= 7) {
      return DateFormat('EEEE').format(date);
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  String _formatTime(DateTime date) => DateFormat('hh:mm a').format(date);
}
