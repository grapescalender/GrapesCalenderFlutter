import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../domain/entities/schedule_entity.dart';

class ScheduleSummaryHeader extends StatelessWidget {
  const ScheduleSummaryHeader({
    super.key,
    required this.plotName,
    required this.scheduleType,
    required this.stageName,
    required this.scheduleDate,
    required this.dayAfterPruning,
    required this.productCount,
  });

  final String plotName;
  final ScheduleType scheduleType;
  final String stageName;
  final DateTime scheduleDate;
  final int? dayAfterPruning;
  final int productCount;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    final typeColor = switch (scheduleType) {
      ScheduleType.spray => AppColors.info,
      ScheduleType.nutrition => AppColors.warning,
      ScheduleType.water => AppColors.primary,
      ScheduleType.work => AppColors.success,
      ScheduleType.all => AppColors.primary,
    };
    final hasProducts = scheduleType == ScheduleType.spray ||
        scheduleType == ScheduleType.nutrition;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            typeColor.withValues(alpha: 0.14),
            colors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: typeColor.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$plotName • ${dayAfterPruning == null ? 'Pruning date not set' : 'Day $dayAfterPruning'}',
                  style: AppTypography.titleMedium(context).copyWith(
                    color: colors.onBackground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  scheduleType.displayName,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: typeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${scheduleType.displayName} Schedule • $stageName Stage',
            style: AppTypography.bodyMedium(context).copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.smMd),
          Wrap(
            spacing: AppSpacing.smMd,
            runSpacing: AppSpacing.xs,
            children: [
              _SummaryItem(
                icon: Icons.event_outlined,
                label: DateFormat('d MMM, h:mm a').format(scheduleDate),
              ),
              if (hasProducts)
                _SummaryItem(
                  icon: Icons.inventory_2_outlined,
                  label: '$productCount product${productCount == 1 ? '' : 's'}',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: DashboardStyle.of(context).primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.labelLarge(context).copyWith(
              color: DashboardStyle.of(context).onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}
