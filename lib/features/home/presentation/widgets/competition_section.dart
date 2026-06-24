import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../providers/plot_notifier.dart';
import '../../domain/entities/plot_entity.dart';

/// Competition Analysis Section
///
/// Without scrolling the farmer sees (in this order):
///   ① Section header
///   ② Pruning window helper + Radius range and Variety filter
///   ③ Compact result summary
///   ④ Donut chart with variety breakdown
class CompetitionSection extends ConsumerStatefulWidget {
  const CompetitionSection({super.key});

  @override
  ConsumerState<CompetitionSection> createState() => _CompetitionSectionState();
}

class _CompetitionSectionState extends ConsumerState<CompetitionSection> {
  // ── Filter state ──────────────────────────────────────────────
  double _radiusKm = 10;
  final Set<String> _selectedVarieties = {..._varietyOptions};

  static const int _fixedWindowDays = 5;

  static const List<String> _varietyOptions = [
    'Thompson Seedless',
    'Sonaka',
    'Sharad Seedless',
    'Manik Chaman',
    'Other varieties',
  ];

  List<_CompetitionPlot> _matchingCompetitionPlots(PlotEntity selectedPlot) {
    final selectedLocation = _selectedPlotLocation(selectedPlot);
    final selectedPruningDate = selectedPlot.pruningDate ?? DateTime.now();

    return _competitionPlots.where((plot) {
      final distance = _distanceKm(selectedLocation, plot.location);
      final competitorPruningDate =
          selectedPruningDate.add(Duration(days: plot.pruningOffsetDays));
      final pruningGap =
          competitorPruningDate.difference(selectedPruningDate).inDays.abs();
      final varietyMatches = _selectedVarieties.contains(plot.variety);

      return distance <= _radiusKm &&
          pruningGap <= _fixedWindowDays &&
          varietyMatches;
    }).toList();
  }

  double _matchingArea(List<_CompetitionPlot> plots) =>
      plots.fold(0, (total, plot) => total + plot.area);

  List<_Seg> _segments(List<_CompetitionPlot> plots) {
    final totals = <String, _VarietyCount>{};
    for (final plot in plots) {
      final current = totals[plot.variety] ?? const _VarietyCount();
      totals[plot.variety] = current.add(plot);
    }

    return totals.entries
        .map(
          (entry) => _Seg(
            entry.key,
            entry.value.totalAcres,
            entry.value.totalPlots,
            entry.value.localPlots,
            entry.value.localAcres,
            entry.value.exportPlots,
            entry.value.exportAcres,
            _varietyColor(entry.key),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(plotNotifierProvider);
    if (state.plots.isEmpty) return const SizedBox.shrink();

    final myPlot = state.plots.firstWhere(
      (p) => p.id == state.selectedPlotId,
      orElse: () => state.plots.first,
    );
    final matchingPlots = _matchingCompetitionPlots(myPlot);
    final matchingCount = matchingPlots.length;
    final matchingArea = _matchingArea(matchingPlots);
    final matchingAcres = matchingArea * 2.47105;
    final segments = _segments(matchingPlots);

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(myPlot: myPlot),
          const SizedBox(height: AppSpacing.xs),
          _OutlinedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.smMd,
                    AppSpacing.smMd,
                    AppSpacing.smMd,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fixedWindowLabel(myPlot.pruningDate),
                        style: AppTypography.labelSmall(context).copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_radiusKm.round()} KM radius from ${myPlot.name}',
                        style: AppTypography.labelSmall(context).copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: _RadiusRangeSelector(
                              value: _radiusKm,
                              onChanged: (value) =>
                                  setState(() => _radiusKm = value),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          SizedBox(
                            width: 98,
                            child: _CompactVarietyButton(
                              selectedVarieties: _selectedVarieties,
                              allVarieties: _varietyOptions,
                              onChanged: (next) {
                                setState(() {
                                  _selectedVarieties
                                    ..clear()
                                    ..addAll(next);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.smMd,
                  ),
                  child: _CompetitionSummaryCard(
                    plots: matchingCount,
                    acres: matchingAcres,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (matchingCount == 0)
                  const _CompetitionEmptyState()
                else
                  _DonutChart(
                    totalAcres: matchingAcres,
                    segments: segments,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fixedWindowLabel(DateTime? pruningDate) {
    if (pruningDate == null) return 'Pruning Window: —';
    final start = pruningDate.subtract(const Duration(days: _fixedWindowDays));
    final end = pruningDate.add(const Duration(days: _fixedWindowDays));
    return 'Pruning Window: ${DateFormat('dd MMM yyyy').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}';
  }

  _LatLng _selectedPlotLocation(PlotEntity plot) {
    final seed = plot.id.codeUnits.fold<int>(0, (sum, code) => sum + code);
    return _LatLng(
      19.9975 + (seed % 7) * 0.006,
      73.7898 + (seed % 5) * 0.006,
    );
  }

  double _distanceKm(_LatLng start, _LatLng end) {
    const earthRadiusKm = 6371.0;
    final dLat = _degreesToRadians(end.latitude - start.latitude);
    final dLng = _degreesToRadians(end.longitude - start.longitude);
    final lat1 = _degreesToRadians(start.latitude);
    final lat2 = _degreesToRadians(end.latitude);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) => degrees * math.pi / 180;

  Color _varietyColor(String variety) {
    switch (variety) {
      case 'Thompson Seedless':
        return AppColors.chartGreen;
      case 'Sonaka':
        return AppColors.chartMint;
      case 'Sharad Seedless':
        return AppColors.chartBlue;
      case 'Manik Chaman':
        return AppColors.chartAmber;
      default:
        return AppColors.chartGray;
    }
  }
}

final List<_CompetitionPlot> _competitionPlots = [
  _CompetitionPlot(
    variety: 'Thompson Seedless',
    harvestingType: 'Export',
    area: 2.6,
    pruningOffsetDays: -5,
    location: const _LatLng(20.0010, 73.7950),
  ),
  _CompetitionPlot(
    variety: 'Sonaka',
    harvestingType: 'Local',
    area: 1.9,
    pruningOffsetDays: -3,
    location: const _LatLng(20.0180, 73.8020),
  ),
  _CompetitionPlot(
    variety: 'Sharad Seedless',
    harvestingType: 'Export',
    area: 3.1,
    pruningOffsetDays: 0,
    location: const _LatLng(20.0300, 73.8200),
  ),
  _CompetitionPlot(
    variety: 'Manik Chaman',
    harvestingType: 'Local',
    area: 1.4,
    pruningOffsetDays: 2,
    location: const _LatLng(20.0450, 73.8300),
  ),
  _CompetitionPlot(
    variety: 'Other varieties',
    harvestingType: 'Export',
    area: 2.2,
    pruningOffsetDays: 5,
    location: const _LatLng(20.0800, 73.8500),
  ),
  _CompetitionPlot(
    variety: 'Thompson Seedless',
    harvestingType: 'Local',
    area: 2.8,
    pruningOffsetDays: -1,
    location: const _LatLng(20.1200, 73.8800),
  ),
  _CompetitionPlot(
    variety: 'Sonaka',
    harvestingType: 'Export',
    area: 1.7,
    pruningOffsetDays: 1,
    location: const _LatLng(20.1700, 73.9300),
  ),
  _CompetitionPlot(
    variety: 'Sharad Seedless',
    harvestingType: 'Local',
    area: 2.4,
    pruningOffsetDays: 3,
    location: const _LatLng(20.2400, 73.9500),
  ),
  _CompetitionPlot(
    variety: 'Manik Chaman',
    harvestingType: 'Export',
    area: 3.0,
    pruningOffsetDays: 6,
    location: const _LatLng(20.3200, 74.0000),
  ),
  _CompetitionPlot(
    variety: 'Other varieties',
    harvestingType: 'Local',
    area: 1.6,
    pruningOffsetDays: -4,
    location: const _LatLng(20.3900, 74.0600),
  ),
];

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.myPlot});
  final PlotEntity myPlot;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: const Icon(Icons.analytics_rounded,
              color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Competition Analysis',
                style: AppTypography.headlineSmall(context).copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Nearby pruning activity around selected plot',
                style: AppTypography.bodySmall(context)
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Outlined card wrapper ─────────────────────────────────────────────────────
class _OutlinedCard extends StatelessWidget {
  const _OutlinedCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _RadiusRangeSelector extends StatelessWidget {
  const _RadiusRangeSelector({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final selectedKm = value.round();

    return Container(
      height: 38,
      padding: const EdgeInsets.only(left: 6, right: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.22),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              '$selectedKm KM',
              style: AppTypography.labelSmall(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
              maxLines: 1,
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.primary.withValues(alpha: 0.16),
                thumbColor: AppColors.primary,
                overlayColor: AppColors.primary.withValues(alpha: 0.12),
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 8,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 15,
                ),
                valueIndicatorColor: AppColors.primary,
                valueIndicatorTextStyle: AppTypography.labelSmall(context)
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w900),
              ),
              child: Slider(
                value: value,
                min: 1,
                max: 50,
                divisions: 49,
                label: '$selectedKm KM',
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactVarietyButton extends StatelessWidget {
  const _CompactVarietyButton({
    required this.selectedVarieties,
    required this.allVarieties,
    required this.onChanged,
  });

  final Set<String> selectedVarieties;
  final List<String> allVarieties;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    final label = selectedVarieties.length == allVarieties.length
        ? 'Variety'
        : '${selectedVarieties.length} selected';

    return GestureDetector(
      onTap: () => _openVarietySheet(context),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.eco_rounded,
                size: 13,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                label,
                style: AppTypography.labelSmall(context).copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _openVarietySheet(BuildContext context) {
    final draft = {...selectedVarieties};

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.smMd,
                  AppSpacing.screenHorizontal,
                  AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.outline,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Select Varieties',
                      style: AppTypography.headlineSmall(context)
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: draft.length == allVarieties.length,
                          onSelected: (selected) {
                            setSheetState(() {
                              draft
                                ..clear()
                                ..addAll(selected ? allVarieties : const []);
                            });
                          },
                        ),
                        ...allVarieties.map(
                          (variety) => FilterChip(
                            label: Text(variety),
                            selected: draft.contains(variety),
                            onSelected: (selected) {
                              setSheetState(() {
                                if (selected) {
                                  draft.add(variety);
                                } else {
                                  draft.remove(variety);
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          onChanged(draft);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CompetitionSummaryCard extends StatelessWidget {
  const _CompetitionSummaryCard({
    required this.plots,
    required this.acres,
  });

  final int plots;
  final double acres;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: _SummaryText(plots: plots, acres: acres.round()),
    );
  }
}

class _SummaryText extends StatelessWidget {
  const _SummaryText({required this.plots, required this.acres});

  final int plots;
  final int acres;

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTypography.sectionTitle(context).copyWith(
      color: AppColors.onBackground,
      fontWeight: FontWeight.w900,
      height: 1.22,
    );
    final numberStyle = baseStyle.copyWith(
      color: AppColors.primary,
    );

    if (plots == 0) {
      return Text(
        'No Plots Match Your Filters',
        style: baseStyle.copyWith(
          color: AppColors.primary,
        ),
      );
    }

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: '$plots', style: numberStyle),
          TextSpan(text: ' ${plots == 1 ? 'Plot' : 'Plots'} ('),
          TextSpan(text: '$acres', style: numberStyle),
          TextSpan(
            text: ' Acres) ${plots == 1 ? 'Matches' : 'Match'} Your Filters',
          ),
        ],
      ),
      softWrap: true,
    );
  }
}

class _CompetitionEmptyState extends StatelessWidget {
  const _CompetitionEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.smMd,
        AppSpacing.xs,
        AppSpacing.smMd,
        AppSpacing.sm,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: const Icon(
                Icons.travel_explore_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Try widening the radius or selecting more varieties.',
              style: AppTypography.bodyMedium(context).copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dropdown filter ───────────────────────────────────────────────────────────
// ── Donut chart ───────────────────────────────────────────────────────────────
class _DonutChart extends StatefulWidget {
  const _DonutChart({required this.totalAcres, required this.segments});

  final double totalAcres;
  final List<_Seg> segments;

  @override
  State<_DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<_DonutChart> {
  late final TooltipBehavior _tooltip;

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(
      enable: true,
      format: 'point.x\npoint.y Acres',
      color: AppColors.onBackground,
      textStyle: AppTypography.caption(null).copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      borderWidth: 0,
      elevation: 4,
      duration: 3000,
      animationDuration: 150,
      tooltipPosition: TooltipPosition.auto,
      decimalPlaces: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    const chartSize = 118.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.smMd,
        AppSpacing.xs,
        AppSpacing.smMd,
        AppSpacing.sm,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 320;
          final chart = _DonutVisual(
            totalAcres: widget.totalAcres,
            segments: widget.segments,
            tooltip: _tooltip,
            size: chartSize,
          );
          final breakdown = _VarietyBreakdown(segments: widget.segments);

          if (compact) {
            return Column(
              children: [
                Align(alignment: Alignment.centerLeft, child: chart),
                const SizedBox(height: AppSpacing.sm),
                breakdown,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              chart,
              const SizedBox(width: AppSpacing.md),
              Expanded(child: breakdown),
            ],
          );
        },
      ),
    );
  }
}

class _DonutVisual extends StatelessWidget {
  const _DonutVisual({
    required this.totalAcres,
    required this.segments,
    required this.tooltip,
    required this.size,
  });

  final double totalAcres;
  final List<_Seg> segments;
  final TooltipBehavior tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SfCircularChart(
            margin: EdgeInsets.zero,
            tooltipBehavior: tooltip,
            series: <DoughnutSeries<_Seg, String>>[
              DoughnutSeries<_Seg, String>(
                dataSource: segments,
                xValueMapper: (_Seg d, _) => d.label,
                yValueMapper: (_Seg d, _) => d.value,
                pointColorMapper: (_Seg d, _) => d.color,
                innerRadius: '60%',
                radius: '100%',
                startAngle: 270,
                endAngle: 270 + 360,
                cornerStyle: CornerStyle.bothCurve,
                animationDuration: 700,
                selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedOpacity: 1.0,
                  unselectedOpacity: 0.6,
                  toggleSelection: true,
                ),
              ),
            ],
          ),
          IgnorePointer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${totalAcres.round()}',
                  style: AppTypography.titleLarge(context).copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.onBackground,
                    height: 1.0,
                  ),
                ),
                Text(
                  'Total',
                  style: AppTypography.labelSmall(context).copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Acres',
                  style: AppTypography.labelSmall(context).copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
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

class _VarietyBreakdown extends StatelessWidget {
  const _VarietyBreakdown({required this.segments});

  final List<_Seg> segments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            'Variety',
            style: AppTypography.labelSmall(context).copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...segments.map((s) => _VarietyBreakdownRow(segment: s)),
        if (segments.isEmpty)
          Text(
            'No plots found',
            style: AppTypography.labelSmall(context).copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Acres split by Local and Export.',
          style: AppTypography.labelSmall(context).copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _VarietyBreakdownRow extends StatelessWidget {
  const _VarietyBreakdownRow({required this.segment});

  final _Seg segment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 32,
              decoration: BoxDecoration(
                color: segment.color,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    segment.label,
                    style: AppTypography.labelSmall(context).copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Local ${segment.localAcres.round()} Acres  •  Export ${segment.exportAcres.round()} Acres',
                    style: AppTypography.labelSmall(context).copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 58),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${segment.totalAcres.round()}',
                    style: AppTypography.titleLarge(context).copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                  Text(
                    'Acres',
                    style: AppTypography.labelSmall(context).copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VarietyCount {
  const _VarietyCount({
    this.totalPlots = 0,
    this.localPlots = 0,
    this.exportPlots = 0,
    this.totalAcres = 0,
    this.localAcres = 0,
    this.exportAcres = 0,
  });

  final int totalPlots;
  final int localPlots;
  final int exportPlots;
  final double totalAcres;
  final double localAcres;
  final double exportAcres;

  _VarietyCount add(_CompetitionPlot plot) {
    final acres = plot.area * 2.47105;
    final isLocal = plot.harvestingType == 'Local';
    final isExport = plot.harvestingType == 'Export';

    return _VarietyCount(
      totalPlots: totalPlots + 1,
      localPlots: localPlots + (isLocal ? 1 : 0),
      exportPlots: exportPlots + (isExport ? 1 : 0),
      totalAcres: totalAcres + acres,
      localAcres: localAcres + (isLocal ? acres : 0),
      exportAcres: exportAcres + (isExport ? acres : 0),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class _CompetitionPlot {
  const _CompetitionPlot({
    required this.variety,
    required this.harvestingType,
    required this.area,
    required this.pruningOffsetDays,
    required this.location,
  });

  final String variety;
  final String harvestingType;
  final double area;
  final int pruningOffsetDays;
  final _LatLng location;
}

class _LatLng {
  const _LatLng(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class _Seg {
  const _Seg(
    this.label,
    this.value,
    this.totalPlots,
    this.localPlots,
    this.localAcres,
    this.exportPlots,
    this.exportAcres,
    this.color,
  );

  final String label;
  final double value;
  final int totalPlots;
  final int localPlots;
  final double localAcres;
  final int exportPlots;
  final double exportAcres;
  final Color color;

  double get totalAcres => value;
}
