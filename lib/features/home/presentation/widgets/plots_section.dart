import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/plot_notifier.dart';
import '../../presentation/providers/plot_state.dart';
import '../../domain/entities/plot_entity.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/colors/app_colors.dart';

/// PlotsSection — shows current selected plot status and allows selecting a plot.
class PlotsSection extends ConsumerWidget {
  const PlotsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final state = ref.watch(plotNotifierProvider);
    final notifier = ref.read(plotNotifierProvider.notifier);

    PlotEntity? selected;
    if (state.plots.isEmpty) {
      selected = null;
    } else {
      selected = state.plots.firstWhere(
        (p) => p.id == state.selectedPlotId,
        orElse: () => state.plots.first,
      );
    }

    final heroHeight = MediaQuery.of(context).size.height * 0.26;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 0),

        // Hero status card (polished, stage gradient)
        SizedBox(
          height: heroHeight,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [cs.primary, cs.secondary], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: cs.shadow.withOpacity(0.08), blurRadius: 14, offset: const Offset(0,8))],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row inside hero: plot selector (distinct color)
                  GestureDetector(
                    onTap: () => _openSelector(context, state, notifier),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.plotSelector,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.agriculture_rounded, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.plots.isEmpty ? 'No plots' : '${selected?.name ?? '-'} · ${selected?.cropType ?? '-'}',
                              style: AppTypography.titleMedium(context).copyWith(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_drop_down, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Main content row
                  Expanded(
                    child: Row(
                      children: [
                        // Left: stats and CTA
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selected != null && selected.hasPruningDate ? '${selected.daysSincePruning} Days' : 'Not Pruned',
                                style: AppTypography.displaySmall(context).copyWith(fontWeight: FontWeight.w900, color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _deriveStage(selected?.daysSincePruning ?? 0),
                                style: AppTypography.headlineSmall(context).copyWith(color: Colors.white70, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                (selected != null && selected.pruningDate != null) ? 'Pruning Date: ${_formatDate(selected!.pruningDate)}' : 'Pruning Date: —',
                                style: AppTypography.bodyMedium(context).copyWith(color: Colors.white70),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    minimumSize: const Size(120, 36), // reduced to match filter chips
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text('View Plot Details', style: AppTypography.bodyMedium(context).copyWith(color: cs.primary, fontWeight: FontWeight.w800, fontSize: 13)),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Right: decorative illustrative block
                        Container(
                          width: heroHeight * 0.56,
                          height: heroHeight * 0.56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [cs.onPrimary.withOpacity(0.12), cs.onPrimary.withOpacity(0.06)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(top: 18, left: 18, child: Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle))),
                              Positioned(bottom: 18, right: 18, child: Container(width: 24, height: 24, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle))),
                              const Icon(Icons.eco_rounded, color: Colors.white70, size: 46),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openSelector(BuildContext context, PlotState state, PlotNotifier notifier) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: state.plots.length,
            separatorBuilder: (_, __) => const Divider(height: 12),
            itemBuilder: (context, index) {
              final plot = state.plots[index];
              return ListTile(
                title: Text(plot.name),
                subtitle: Text('${plot.cropType} · ${plot.area} ha'),
                trailing: state.selectedPlotId == plot.id ? const Icon(Icons.check, color: AppColors.plotSelector) : null,
                onTap: () {
                  notifier.selectPlot(plot.id);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.day.toString().padLeft(2, '0')} ${_monthAbbr(dt.month)} ${dt.year}';
  }

  String _monthAbbr(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[(m-1).clamp(0,11)];
  }

  String _deriveStage(int days) {
    if (days <= 14) return 'Post-pruning: Shoot Emergence';
    if (days <= 35) return 'Vegetative Growth';
    if (days <= 70) return 'Berry Setting';
    return 'Ripening & Canopy';
  }
}

