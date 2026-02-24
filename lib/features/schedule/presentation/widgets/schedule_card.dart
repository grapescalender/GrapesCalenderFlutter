import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../domain/entities/schedule_entity.dart';

/// Schedule Card Widget
/// Displays schedule information in a card format
class ScheduleCard extends StatelessWidget {
  final ScheduleEntity schedule;
  final VoidCallback? onTap;

  const ScheduleCard({
    Key? key,
    required this.schedule,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    return AppCard.defaultStyle(
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
                  color: _getTypeColor(context, schedule.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  _getTypeIcon(schedule.type),
                  color: _getTypeColor(context, schedule.type),
                  size: 20,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              // Title and Type
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.title,
                      style: AppTypography.headlineSmall(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      schedule.type.displayName,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: _getTypeColor(context, schedule.type),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              if (schedule.isCompleted)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: semantic.success.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  ),
                  child: Text(
                    'Done',
                    style: AppTypography.labelSmall(context).copyWith(
                      color: semantic.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (schedule.description != null && schedule.description!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            Text(
              schedule.description!,
              style: AppTypography.bodySmall(context).copyWith(
                color: cs.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: AppSpacing.md),
          // Date Row
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                _formatDate(schedule.scheduledDate),
                style: AppTypography.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Icon(
                Icons.access_time_outlined,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                _formatTime(schedule.scheduledDate),
                style: AppTypography.bodySmall(context).copyWith(
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

  String _formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
}
