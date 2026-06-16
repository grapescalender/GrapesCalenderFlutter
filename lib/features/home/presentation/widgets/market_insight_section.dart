import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
// import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../shared/widgets/app_card.dart';
import 'competition_analysis_card.dart';
import '../providers/plot_notifier.dart';
// import '../../domain/entities/plot_entity.dart';

class MarketInsightSection extends ConsumerWidget {
  const MarketInsightSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plotNotifierProvider);
    final selected = state.plots.isNotEmpty
        ? state.plots.firstWhere((p) => p.id == state.selectedPlotId, orElse: () => state.plots.first)
        : null;

    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Text('Market Intelligence', style: AppTypography.titleMedium(context).copyWith(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: AppSpacing.sm),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: AppCard.defaultStyle(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Pruning Date', style: AppTypography.bodySmall(context).copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(selected?.pruningDate != null ? DateFormat('d MMM yyyy').format(selected!.pruningDate!) : 'Not pruned', style: AppTypography.titleSmall(context).copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Competition', style: AppTypography.bodySmall(context).copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: AppSpacing.xs),
                        _competitionMeter(context, 'MEDIUM'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Simple metrics row (placeholders)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _metricTile(context, 'Last 5 Days', '—'),
                    _metricTile(context, 'Same Date', '—'),
                    _metricTile(context, 'Next 5 Days', '—'),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Competition analysis card (replaces previous horizontal chart)
                const CompetitionAnalysisCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _metricTile(BuildContext context, String title, String value) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.bodySmall(context).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTypography.titleSmall(context).copyWith(fontWeight: FontWeight.w800)),
      ],
    ),
  );

// Top-level competition meter so it can be used from the MarketInsightSection
Widget _competitionMeter(BuildContext context, String level) {
  final cs = Theme.of(context).colorScheme;
  final percent = level == 'LOW' ? 0.25 : level == 'HIGH' ? 0.85 : 0.55;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(level, style: AppTypography.bodySmall(context).copyWith(fontWeight: FontWeight.w800, color: cs.primary)),
      const SizedBox(height: AppSpacing.xs),
      Container(
        width: 120,
        height: 10,
        decoration: BoxDecoration(color: cs.onSurface.withOpacity(0.06), borderRadius: BorderRadius.circular(6)),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: percent,
          child: Container(decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(6))),
        ),
      ),
    ],
  );
}
