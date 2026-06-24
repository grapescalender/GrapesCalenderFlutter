import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../models/dashboard_models.dart';

class DashboardInsightsSection extends StatelessWidget {
  const DashboardInsightsSection({
    super.key,
    required this.marketInsights,
    required this.recommendations,
  });

  final List<MarketInsightModel> marketInsights;
  final List<ConsultantRecommendationModel> recommendations;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MarketInsightCard(insights: marketInsights),
          if (recommendations.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.smMd),
            _ConsultantRecommendationSection(recommendations: recommendations),
          ],
        ],
      ),
    );
  }
}

class _MarketInsightCard extends StatelessWidget {
  const _MarketInsightCard({required this.insights});

  final List<MarketInsightModel> insights;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return DashboardSectionCard(
      title: 'Market Insights',
      icon: Icons.trending_up_rounded,
      child: insights.isEmpty
          ? Text(
              'Market updates will appear when price data is available.',
              style: AppTypography.bodyMedium(context).copyWith(
                color: colors.onSurfaceVariant,
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 380;
                return Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final insight in insights)
                      SizedBox(
                        width: compact
                            ? double.infinity
                            : (constraints.maxWidth - AppSpacing.sm) / 2,
                        child: _MarketInsightTile(insight: insight),
                      ),
                  ],
                );
              },
            ),
    );
  }
}

class _MarketInsightTile extends StatelessWidget {
  const _MarketInsightTile({required this.insight});

  final MarketInsightModel insight;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    final statusColor = switch (insight.status) {
      MarketInsightStatus.positive => AppColors.success,
      MarketInsightStatus.neutral => colors.primary,
      MarketInsightStatus.caution => AppColors.warning,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: colors
          .cardDecoration(
        radius: AppSpacing.radiusMd,
        accentColor: statusColor,
      )
          .copyWith(boxShadow: const []),
      child: Row(
        children: [
          Container(
            width: AppSpacing.xl,
            height: AppSpacing.xl,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(insight.icon, color: statusColor, size: AppSpacing.md),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  insight.value,
                  style: AppTypography.titleMedium(context).copyWith(
                    color: colors.onBackground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  insight.trendLabel,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
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
}

class _ConsultantRecommendationSection extends StatelessWidget {
  const _ConsultantRecommendationSection({required this.recommendations});

  final List<ConsultantRecommendationModel> recommendations;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      title: 'Consultant Recommendations',
      icon: Icons.support_agent_rounded,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recommendations.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => _RecommendationTile(
          recommendation: recommendations[index],
        ),
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({required this.recommendation});

  final ConsultantRecommendationModel recommendation;

  @override
  Widget build(BuildContext context) {
    final priorityColor = switch (recommendation.priority) {
      RecommendationPriority.high => AppColors.error,
      RecommendationPriority.medium => AppColors.warning,
      RecommendationPriority.low => AppColors.success,
    };

    return DashboardListItem(
      title: recommendation.title,
      subtitle: recommendation.message,
      icon: Icons.lightbulb_outline_rounded,
      accentColor: priorityColor,
      meta:
          '${recommendation.consultantName} • ${DateFormat('d MMM').format(recommendation.createdAt)}',
      trailing: DashboardStatusPill(
        label: recommendation.priority.name.toUpperCase(),
        color: priorityColor,
        muted: false,
      ),
    );
  }
}
