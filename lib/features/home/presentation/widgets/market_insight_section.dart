import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../providers/plot_notifier.dart';
import 'competition_analysis_card.dart';

class MarketInsightSection extends ConsumerWidget {
  const MarketInsightSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plotNotifierProvider);
    final selected = state.plots.isNotEmpty
        ? state.plots.firstWhere(
            (p) => p.id == state.selectedPlotId,
            orElse: () => state.plots.first,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: const Icon(
                      Icons.insights_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Market Intelligence',
                        style: AppTypography.headlineSmall(context).copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onBackground,
                        ),
                      ),
                      Text(
                        'Harvest competition & pricing',
                        style: AppTypography.bodySmall(context).copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    Text(
                      'Details',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.smMd),

        // ── Summary Metrics Strip ────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Row(
            children: [
              _SummaryMetricCard(
                label: 'Last 5 Days',
                value: '—',
                icon: Icons.history_rounded,
                iconColor: AppColors.info,
                bgColor: const Color(0xFFEFF6FF),
              ),
              const SizedBox(width: AppSpacing.smMd),
              _SummaryMetricCard(
                label: 'Same Date',
                value: '—',
                icon: Icons.today_rounded,
                iconColor: AppColors.primary,
                bgColor: AppColors.primaryContainer,
              ),
              const SizedBox(width: AppSpacing.smMd),
              _SummaryMetricCard(
                label: 'Next 5 Days',
                value: '—',
                icon: Icons.update_rounded,
                iconColor: const Color(0xFF8B5CF6),
                bgColor: const Color(0xFFF3EBFE),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.smMd),

        // ── Pruning Date + Competition Level ────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Row(
            children: [
              Expanded(
                child: _InfoTile(
                  icon: Icons.content_cut_rounded,
                  label: 'My Pruning Date',
                  value: selected?.pruningDate != null
                      ? DateFormat('d MMM yyyy').format(selected!.pruningDate!)
                      : 'Not pruned',
                  valueColor: AppColors.onBackground,
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: _CompetitionLevelTile(level: 'MEDIUM'),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.smMd),

        // ── Competition Analysis Card ────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: const CompetitionAnalysisCard(),
        ),
      ],
    );
  }
}

// ── Summary Metric Card ─────────────────────────────────────────────────────
class _SummaryMetricCard extends StatelessWidget {
  const _SummaryMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.outline, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTypography.headlineMedium(context).copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.bodySmall(context).copyWith(
                color: AppColors.onSurface,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info Tile (Pruning Date) ────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
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
                Text(
                  value,
                  style: AppTypography.titleSmall(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: valueColor,
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

// ── Competition Level Tile ──────────────────────────────────────────────────
class _CompetitionLevelTile extends StatelessWidget {
  const _CompetitionLevelTile({required this.level});

  final String level;

  Color get _barColor {
    switch (level) {
      case 'LOW':
        return AppColors.success;
      case 'HIGH':
        return AppColors.error;
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Color get _bgColor {
    switch (level) {
      case 'LOW':
        return AppColors.successLight;
      case 'HIGH':
        return AppColors.errorLight;
      default:
        return const Color(0xFFFFF7ED);
    }
  }

  double get _fraction {
    switch (level) {
      case 'LOW':
        return 0.25;
      case 'HIGH':
        return 0.85;
      default:
        return 0.55;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(Icons.bar_chart_rounded, color: _barColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Competition',
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.onSurface,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _fraction,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _barColor,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  level,
                  style: AppTypography.titleSmall(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: _barColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
