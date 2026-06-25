import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../domain/entities/schedule_entity.dart';
import '../utils/schedule_type_colors.dart';

class PlotSummaryCard extends StatelessWidget {
  const PlotSummaryCard({
    super.key,
    required this.plotName,
    required this.dayAfterPruning,
    required this.scheduleType,
    required this.stageName,
    required this.productCount,
    required this.pruningDate,
  });

  final String plotName;
  final int? dayAfterPruning;
  final ScheduleType scheduleType;
  final String stageName;
  final int productCount;
  final DateTime? pruningDate;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    final typeColor = ScheduleTypeColors.accent(scheduleType);
    final hasProducts = scheduleType == ScheduleType.spray ||
        scheduleType == ScheduleType.nutrition;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: colors.outline),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: AppSpacing.smMd,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  plotName,
                  style: AppTypography.titleMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onBackground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                children: [
                  DashboardStatusPill(
                    label: scheduleType.displayName,
                    color: typeColor,
                  ),
                  if (hasProducts && productCount > 0)
                    DashboardStatusPill(
                      label:
                          '$productCount Product${productCount == 1 ? '' : 's'}',
                      color: colors.primary,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dayAfterPruning != null) ...[
                      _buildSummaryRow(
                        context,
                        'Days After Pruning',
                        'Day $dayAfterPruning',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    _buildSummaryRow(context, 'Current Stage', stageName),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (pruningDate != null) ...[
                      _buildSummaryRow(
                        context,
                        'Cutting Date',
                        DateFormat('d MMM yy').format(pruningDate!),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    _buildSummaryRow(
                      context,
                      'Today\'s Date',
                      DateFormat('d MMM yy').format(DateTime.now()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    final colors = DashboardStyle.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelLarge(context).copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.titleMedium(context).copyWith(
            color: colors.onBackground,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
