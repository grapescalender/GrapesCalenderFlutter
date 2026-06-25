import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

    final entries = totals.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final colors = _shuffledCompetitionColors(entries);

    return entries
        .asMap()
        .entries
        .map(
          (indexedEntry) => _Seg(
            indexedEntry.value.key,
            indexedEntry.value.value.totalAcres,
            indexedEntry.value.value.totalPlots,
            indexedEntry.value.value.localPlots,
            indexedEntry.value.value.localAcres,
            indexedEntry.value.value.exportPlots,
            indexedEntry.value.value.exportAcres,
            colors[indexedEntry.key % colors.length],
          ),
        )
        .toList();
  }

  List<Color> _shuffledCompetitionColors(
    List<MapEntry<String, _VarietyCount>> entries,
  ) {
    final seedSource = entries
        .map((entry) => '${entry.key}:${entry.value.totalPlots}')
        .join('|');
    final seed = seedSource.codeUnits.fold<int>(
      17,
      (current, codeUnit) => current * 37 + codeUnit,
    );
    return [..._competitionPieColors]..shuffle(math.Random(seed));
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
                        style: AppTypography.labelLarge(context).copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_radiusKm.round()} KM radius from ${myPlot.name}',
                        style: AppTypography.labelLarge(context).copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
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
}

const List<Color> _competitionPieColors = [
  Color(0xFF2F8F83), // Deep Teal
  Color(0xFFD6A23A), // Muted Gold
  Color(0xFF7A8F46), // Olive
  Color(0xFFB85C6A), // Soft Berry
  Color(0xFF7467A8), // Dusty Violet
  Color(0xFF5F8F5F), // Sage Green
  Color(0xFFB87848), // Terracotta
  Color(0xFF596987), // Steel Slate
  Color(0xFFA65F8E), // Mauve
  Color(0xFF7C7468), // Warm Stone
];

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
                style: AppTypography.titleLarge(context).copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Nearby pruning activity around selected plot',
                style: AppTypography.labelLarge(context)
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
              style: AppTypography.labelLarge(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
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
                valueIndicatorTextStyle: AppTypography.labelLarge(context)
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
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
                style: AppTypography.labelLarge(context).copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w600,
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
                      style: AppTypography.titleLarge(context)
                          .copyWith(fontWeight: FontWeight.w600),
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
    final baseStyle = AppTypography.titleLarge(context).copyWith(
      color: AppColors.onBackground,
      fontWeight: FontWeight.w600,
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
                fontWeight: FontWeight.w600,
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
// ── Exploded pie chart ────────────────────────────────────────────────────────
class _DonutChart extends StatelessWidget {
  const _DonutChart({required this.segments});

  final List<_Seg> segments;

  @override
  Widget build(BuildContext context) {
    final chartSegments = _chartSegments(segments);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.smMd,
        AppSpacing.xs,
        AppSpacing.smMd,
        AppSpacing.sm,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = (width * 0.54).clamp(178.0, 224.0) +
              math.max(0, chartSegments.length - 5) * AppSpacing.xs;

          return _DonutVisual(
            segments: chartSegments,
            width: width,
            height: height,
          );
        },
      ),
    );
  }

  List<_Seg> _chartSegments(List<_Seg> source) {
    if (source.length <= _DonutVisual.maxVisibleSegments) {
      return source;
    }

    final sorted = [...source]..sort((a, b) => b.value.compareTo(a.value));
    final visible = sorted.take(_DonutVisual.maxVisibleSegments - 1).toList();
    final remaining = sorted.skip(_DonutVisual.maxVisibleSegments - 1);
    var totalAcres = 0.0;
    var totalPlots = 0;
    var localPlots = 0;
    var localAcres = 0.0;
    var exportPlots = 0;
    var exportAcres = 0.0;

    for (final segment in remaining) {
      totalAcres += segment.totalAcres;
      totalPlots += segment.totalPlots;
      localPlots += segment.localPlots;
      localAcres += segment.localAcres;
      exportPlots += segment.exportPlots;
      exportAcres += segment.exportAcres;
    }

    return [
      ...visible,
      _Seg(
        'Others',
        totalAcres,
        totalPlots,
        localPlots,
        localAcres,
        exportPlots,
        exportAcres,
        _competitionPieColors[(_DonutVisual.maxVisibleSegments - 1) %
            _competitionPieColors.length],
      ),
    ];
  }
}

class _DonutVisual extends StatefulWidget {
  const _DonutVisual({
    required this.segments,
    required this.width,
    required this.height,
  });

  static const int maxVisibleSegments = 8;
  static const double chartWidthFraction = 0.43;
  static const double labelStartFraction = 0.58;
  static const double labelRowHeight = 32;

  final List<_Seg> segments;
  final double width;
  final double height;

  @override
  State<_DonutVisual> createState() => _DonutVisualState();
}

class _DonutVisualState extends State<_DonutVisual> {
  _Seg? _activeSegment;
  Offset? _tooltipPosition;

  void _setActiveSegment(Offset position, Size size) {
    final next = _segmentAt(position, size);
    if (next == _activeSegment && position == _tooltipPosition) {
      return;
    }
    setState(() {
      _activeSegment = next;
      _tooltipPosition = position;
    });
  }

  void _clearActiveSegment() {
    if (_activeSegment == null && _tooltipPosition == null) {
      return;
    }
    setState(() {
      _activeSegment = null;
      _tooltipPosition = null;
    });
  }

  _Seg? _segmentAt(Offset position, Size size) {
    final total =
        widget.segments.fold<double>(0, (sum, segment) => sum + segment.value);
    if (total <= 0) {
      return null;
    }

    final chartBounds = _ExplodedPiePainter.chartRect(size);
    final center = _ExplodedPiePainter.chartCenter(size);
    final radiusX = chartBounds.width * 0.42;
    final radiusY = chartBounds.height * 0.23;
    final explode = chartBounds.width * 0.065;
    var startAngle = -math.pi * 0.10;

    for (final segment in widget.segments) {
      final sweep = (segment.value / total) * math.pi * 2;
      final midAngle = startAngle + sweep / 2;
      final offset = Offset(math.cos(midAngle), math.sin(midAngle)) * explode;
      final shifted = position - center - offset;
      final normalizedDistance = math.sqrt(
        math.pow(shifted.dx / radiusX, 2) + math.pow(shifted.dy / radiusY, 2),
      );

      if (normalizedDistance <= 1) {
        final angle = math.atan2(shifted.dy / radiusY, shifted.dx / radiusX);
        if (_angleInSweep(angle, startAngle, sweep)) {
          return segment;
        }
      }

      startAngle += sweep;
    }

    return null;
  }

  bool _angleInSweep(double angle, double startAngle, double sweep) {
    final normalizedAngle = _normalizeAngle(angle);
    final normalizedStart = _normalizeAngle(startAngle);
    final normalizedEnd = _normalizeAngle(startAngle + sweep);

    if (sweep >= math.pi * 2) {
      return true;
    }
    if (normalizedStart <= normalizedEnd) {
      return normalizedAngle >= normalizedStart &&
          normalizedAngle <= normalizedEnd;
    }
    return normalizedAngle >= normalizedStart ||
        normalizedAngle <= normalizedEnd;
  }

  double _normalizeAngle(double angle) {
    var result = angle % (math.pi * 2);
    if (result < 0) {
      result += math.pi * 2;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final chartSize = Size(widget.width, widget.height);
    final labelSegments = _ExplodedPiePainter.labelOrderedSegments(
      chartSize,
      widget.segments,
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: MouseRegion(
        onHover: (event) => _setActiveSegment(event.localPosition, chartSize),
        onExit: (_) => _clearActiveSegment(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) =>
              _setActiveSegment(details.localPosition, chartSize),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: chartSize,
                painter: _ExplodedPiePainter(
                  segments: widget.segments,
                  labelStyle: AppTypography.labelLarge(context).copyWith(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...[
                for (var index = 0; index < labelSegments.length; index++)
                  _PositionedChartLabel(
                    segment: labelSegments[index],
                    top: _ExplodedPiePainter.labelRowCenterY(
                          chartSize,
                          index,
                          labelSegments.length,
                        ) -
                        _DonutVisual.labelRowHeight / 2,
                  ),
              ],
              if (_activeSegment != null && _tooltipPosition != null)
                _ChartSliceTooltip(
                  segment: _activeSegment!,
                  position: _tooltipPosition!,
                  chartSize: chartSize,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PositionedChartLabel extends StatelessWidget {
  const _PositionedChartLabel({
    required this.segment,
    required this.top,
  });

  final _Seg segment;
  final double top;

  @override
  Widget build(BuildContext context) => Positioned(
        left: 0,
        right: AppSpacing.xs,
        top: top,
        height: _DonutVisual.labelRowHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final labelLeft =
                constraints.maxWidth * _DonutVisual.labelStartFraction;
            return Padding(
              padding: EdgeInsets.only(left: labelLeft),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: segment.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      '${segment.label}(${segment.totalAcres.round()} ${segment.totalAcres.round() == 1 ? 'Acre' : 'Acres'})',
                      style: AppTypography.labelLarge(context).copyWith(
                        color: segment.color,
                        fontWeight: FontWeight.w600,
                        height: 1.05,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
}

class _ChartSliceTooltip extends StatelessWidget {
  const _ChartSliceTooltip({
    required this.segment,
    required this.position,
    required this.chartSize,
  });

  final _Seg segment;
  final Offset position;
  final Size chartSize;

  @override
  Widget build(BuildContext context) {
    const tooltipWidth = 156.0;
    final left = (position.dx + AppSpacing.sm)
        .clamp(AppSpacing.xs, chartSize.width - tooltipWidth);
    final top = (position.dy - AppSpacing.xl)
        .clamp(AppSpacing.xs, chartSize.height - AppSpacing.xxl);

    return Positioned(
      left: left,
      top: top,
      width: tooltipWidth,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.onBackground.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: AppSpacing.md,
                offset: const Offset(0, AppSpacing.xs),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  segment.label,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  '${segment.totalAcres.round()} Acres '
                  '(${segment.exportAcres.round()} Export, '
                  '${segment.localAcres.round()} Local)',
                  style: AppTypography.labelLarge(context).copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExplodedPiePainter extends CustomPainter {
  const _ExplodedPiePainter({
    required this.segments,
    required this.labelStyle,
  });

  final List<_Seg> segments;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final total =
        segments.fold<double>(0, (sum, segment) => sum + segment.value);
    if (total <= 0) {
      return;
    }

    final chartBounds = chartRect(size);
    final center = chartCenter(size);
    final radiusX = chartBounds.width * 0.42;
    final radiusY = chartBounds.height * 0.23;
    final depth = chartBounds.height * 0.24;
    final explode = chartBounds.width * 0.065;
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + chartBounds.width * 0.18, center.dy + depth),
        width: radiusX * 2.1,
        height: radiusY * 0.92,
      ),
      shadowPaint,
    );

    var startAngle = -math.pi * 0.10;
    for (final segment in segments) {
      final sweep = (segment.value / total) * math.pi * 2;
      final midAngle = startAngle + sweep / 2;
      final offset = Offset(math.cos(midAngle), math.sin(midAngle)) * explode;
      final depthPaint = Paint()..color = _darken(segment.color, 0.32);

      for (var y = depth; y > 0; y -= 2) {
        canvas.drawPath(
          _sectorPath(center, radiusX, radiusY, startAngle, sweep,
              offset + Offset(0, y)),
          depthPaint,
        );
      }
      startAngle += sweep;
    }

    startAngle = -math.pi * 0.10;
    for (final segment in segments) {
      final sweep = (segment.value / total) * math.pi * 2;
      final midAngle = startAngle + sweep / 2;
      final offset = Offset(math.cos(midAngle), math.sin(midAngle)) * explode;
      final bounds = Rect.fromCenter(
        center: center + offset,
        width: radiusX * 2,
        height: radiusY * 2,
      );
      final topPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _lighten(segment.color, 0.18),
            segment.color,
            _darken(segment.color, 0.10),
          ],
        ).createShader(bounds);
      final path =
          _sectorPath(center, radiusX, radiusY, startAngle, sweep, offset);

      canvas
        ..drawPath(path, topPaint)
        ..drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = Colors.white.withValues(alpha: 0.50),
        );
      _paintSliceNumber(
        canvas,
        center +
            offset +
            Offset(
              math.cos(midAngle) * radiusX * 0.42,
              math.sin(midAngle) * radiusY * 0.42,
            ),
        segment,
      );

      startAngle += sweep;
    }
  }

  static Rect chartRect(Size size) => Rect.fromLTWH(
        0,
        0,
        size.width * _DonutVisual.chartWidthFraction,
        size.height,
      );

  static Offset chartCenter(Size size) {
    final bounds = chartRect(size);
    return Offset(bounds.width * 0.48, size.height * 0.46);
  }

  static List<_Seg> labelOrderedSegments(Size size, List<_Seg> segments) {
    final total =
        segments.fold<double>(0, (sum, segment) => sum + segment.value);
    if (total <= 0) {
      return segments;
    }

    final chartBounds = chartRect(size);
    final center = chartCenter(size);
    final radiusY = chartBounds.height * 0.23;
    final explode = chartBounds.width * 0.065;
    var startAngle = -math.pi * 0.10;
    final placements = <_SegmentLabelPlacement>[];

    for (final segment in segments) {
      final sweep = (segment.value / total) * math.pi * 2;
      final midAngle = startAngle + sweep / 2;
      placements.add(
        _SegmentLabelPlacement(
          segment,
          center.dy +
              math.sin(midAngle) * explode +
              math.sin(midAngle) * radiusY * 1.14,
        ),
      );
      startAngle += sweep;
    }

    return (placements..sort((a, b) => a.y.compareTo(b.y)))
        .map((placement) => placement.segment)
        .toList();
  }

  static double labelRowCenterY(Size size, int index, int count) {
    if (count <= 1) {
      return size.height * 0.48;
    }

    final top = size.height * 0.15;
    final bottom = size.height * 0.85;
    final gap = (bottom - top) / (count - 1);
    return top + gap * index;
  }

  Path _sectorPath(
    Offset center,
    double radiusX,
    double radiusY,
    double startAngle,
    double sweep,
    Offset offset,
  ) {
    final shiftedCenter = center + offset;
    final rect = Rect.fromCenter(
      center: shiftedCenter,
      width: radiusX * 2,
      height: radiusY * 2,
    );
    return Path()
      ..moveTo(shiftedCenter.dx, shiftedCenter.dy)
      ..arcTo(rect, startAngle, sweep, false)
      ..close();
  }

  void _paintSliceNumber(Canvas canvas, Offset center, _Seg segment) {
    final textColor = _readableTextColor(segment.color);
    final painter = TextPainter(
      text: TextSpan(
        text: '${segment.totalAcres.round()}',
        style: labelStyle.copyWith(color: textColor),
      ),
      textDirection: ui.TextDirection.ltr,
      maxLines: 1,
    )..layout();
    const platePadding = AppSpacing.xs;
    final plateRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: painter.width + platePadding * 2,
        height: painter.height + platePadding,
      ),
      const Radius.circular(AppSpacing.radiusFull),
    );

    canvas.drawRRect(
      plateRect,
      Paint()..color = _numberPlateColor(textColor),
    );
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color _readableTextColor(Color color) {
    return color.computeLuminance() > 0.48
        ? AppColors.onBackground
        : Colors.white;
  }

  static Color _numberPlateColor(Color textColor) {
    return textColor == Colors.white
        ? Colors.black.withValues(alpha: 0.22)
        : Colors.white.withValues(alpha: 0.34);
  }

  @override
  bool shouldRepaint(covariant _ExplodedPiePainter oldDelegate) =>
      oldDelegate.segments != segments || oldDelegate.labelStyle != labelStyle;
}

class _SegmentLabelPlacement {
  const _SegmentLabelPlacement(this.segment, this.y);

  final _Seg segment;
  final double y;
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
