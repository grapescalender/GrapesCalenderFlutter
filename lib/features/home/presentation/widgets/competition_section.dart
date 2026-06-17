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
///   ② Two dropdowns side-by-side: Pruning Window + Radius
///   ③ Two metric cards: Total Registered Plots | Matching Plots
///   ④ Donut chart with variety breakdown
///   ⑤ Insight banner
class CompetitionSection extends ConsumerStatefulWidget {
  const CompetitionSection({super.key});

  @override
  ConsumerState<CompetitionSection> createState() =>
      _CompetitionSectionState();
}

class _CompetitionSectionState extends ConsumerState<CompetitionSection> {
  // ── Filter state ──────────────────────────────────────────────
  String _window = '±5 Days';
  String _radius = '10 KM';

  static const List<String> _windowOptions = [
    'Same Day',
    '±1 Day',
    '±2 Days',
    '±3 Days',
    '±4 Days',
    '±5 Days',
    '±6 Days',
    '±7 Days',
    '±8 Days',
    '±9 Days',
    '±10 Days',
  ];

  static const List<String> _radiusOptions = [
    '1 KM',
    '2 KM',
    '5 KM',
    '10 KM',
    '15 KM',
    '20 KM',
    '25 KM',
    '50 KM',
  ];

  // ── Mock data ─────────────────────────────────────────────────
  static const int _totalRegisteredPlots = 12450;
  // Matching changes based on filter (mock logic)
  int get _matchingPlots {
    final radiusKm = int.tryParse(_radius.replaceAll(' KM', '')) ?? 10;
    final windowDays = _window == 'Same Day'
        ? 0
        : int.tryParse(
                _window.replaceAll('±', '').replaceAll(' Days', '').replaceAll(' Day', '')) ??
            5;
    // Mock formula: more radius + wider window = more plots
    return ((radiusKm * 2.8) + (windowDays * 4)).round().clamp(12, 850);
  }

  // Donut segments (variety distribution)
  List<_Seg> get _segments => [
        _Seg('Thompson Seedless', 80, AppColors.chartGreen),
        _Seg('Sonaka', 65, AppColors.chartMint),
        _Seg('Sharad Seedless', 45, AppColors.chartBlue),
        _Seg('Manik Chaman', 25, AppColors.chartAmber),
        _Seg('Others', 30, AppColors.chartGray),
      ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(plotNotifierProvider);
    if (state.plots.isEmpty) return const SizedBox.shrink();

    final myPlot = state.plots.firstWhere(
      (p) => p.id == state.selectedPlotId,
      orElse: () => state.plots.first,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ────────────────────────────────────
          _SectionHeader(myPlot: myPlot),
          const SizedBox(height: AppSpacing.smMd),

          // ── Card ──────────────────────────────────────────────
          _OutlinedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ① Two dropdown filters
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.cardPadding,
                      AppSpacing.cardPadding,
                      AppSpacing.cardPadding,
                      0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _FilterDropdown(
                          label: 'Pruning Window',
                          value: _window,
                          items: _windowOptions,
                          onChanged: (v) => setState(() => _window = v),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.smMd),
                      Expanded(
                        child: _FilterDropdown(
                          label: 'Radius',
                          value: _radius,
                          items: _radiusOptions,
                          onChanged: (v) => setState(() => _radius = v),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.smMd),
                const Divider(height: 1, color: AppColors.outline),

                // ② Two metric cards
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.cardPadding,
                      AppSpacing.smMd,
                      AppSpacing.cardPadding,
                      0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.location_city_rounded,
                          iconBg: AppColors.infoLight,
                          iconColor: AppColors.info,
                          value: _fmt(_totalRegisteredPlots),
                          label: 'Total Registered\nPlots',
                          highlight: false,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.smMd),
                      Expanded(
                        child: _MetricCard(
                          icon: Icons.groups_2_rounded,
                          iconBg: AppColors.primaryContainer,
                          iconColor: AppColors.primary,
                          value: _fmt(_matchingPlots),
                          label: 'Matching\nPlots',
                          highlight: true,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.smMd),
                const Divider(height: 1, color: AppColors.outline),

                // ③ Donut chart title
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.cardPadding,
                      AppSpacing.smMd,
                      AppSpacing.cardPadding,
                      0),
                  child: Text(
                    'Variety Distribution',
                    style: AppTypography.titleLarge(context)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),

                // ④ Donut chart
                _DonutChart(
                  matching: _matchingPlots,
                  segments: _segments,
                ),

                const Divider(height: 1, color: AppColors.outline),

                // ⑤ Insight banner
                _InsightBanner(
                  window: _window,
                  radius: _radius,
                  matching: _matchingPlots,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000) {
      return NumberFormat('#,##0').format(n);
    }
    return '$n';
  }
}

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
                style: AppTypography.headlineSmall(context)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                'Nearby Similar Pruning Activity',
                style: AppTypography.bodySmall(context)
                    .copyWith(color: AppColors.onSurface),
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

// ── Dropdown filter ───────────────────────────────────────────────────────────
class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall(context)
              .copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.smMd),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.outline),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              isExpanded: true,
              icon: const Icon(Icons.expand_more_rounded,
                  size: 16, color: AppColors.onSurface),
              style: AppTypography.bodyMedium(context)
                  .copyWith(color: AppColors.onBackground),
              items: items
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s,
                            style: AppTypography.bodyMedium(context)
                                .copyWith(color: AppColors.onBackground)),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ── Metric card ───────────────────────────────────────────────────────────────
class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.highlight,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primaryContainer : AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: highlight
              ? AppColors.primary.withValues(alpha: 0.25)
              : AppColors.outline,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: iconColor, size: 17),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTypography.headlineMedium(context).copyWith(
                    fontWeight: FontWeight.w800,
                    color: highlight
                        ? AppColors.primary
                        : AppColors.onBackground,
                  ),
                ),
                Text(
                  label,
                  style: AppTypography.labelSmall(context).copyWith(
                    color: highlight
                        ? AppColors.onPrimaryContainer
                        : AppColors.onSurface,
                    height: 1.4,
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

// ── Donut chart ───────────────────────────────────────────────────────────────
class _DonutChart extends StatefulWidget {
  const _DonutChart({required this.matching, required this.segments});

  final int matching;
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
      format: 'point.x\npoint.y plots',
      color: AppColors.onBackground,
      textStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
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
    const chartSize = 160.0;
    final total =
        widget.segments.fold<double>(0, (s, e) => s + e.value);

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.cardPadding,
          AppSpacing.sm, AppSpacing.cardPadding, AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Donut ──────────────────────────────────────────────
          SizedBox(
            width: chartSize,
            height: chartSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SfCircularChart(
                  margin: EdgeInsets.zero,
                  tooltipBehavior: _tooltip,
                  series: <DoughnutSeries<_Seg, String>>[
                    DoughnutSeries<_Seg, String>(
                      dataSource: widget.segments,
                      xValueMapper: (_Seg d, _) => d.label,
                      yValueMapper: (_Seg d, _) => d.value,
                      pointColorMapper: (_Seg d, _) => d.color,
                      innerRadius: '60%',
                      radius: '100%',
                      startAngle: 270,
                      endAngle: 270 + 360,
                      cornerStyle: CornerStyle.bothCurve,
                      animationDuration: 700,
                      // Enable selection highlight on tap
                      selectionBehavior: SelectionBehavior(
                        enable: true,
                        selectedOpacity: 1.0,
                        unselectedOpacity: 0.6,
                        toggleSelection: true,
                      ),
                    ),
                  ],
                ),
                // Centre overlay — updates to show tapped segment
                IgnorePointer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.matching}',
                        style:
                            AppTypography.headlineLarge(context).copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.onBackground,
                        ),
                      ),
                      Text(
                        'Matching',
                        style: AppTypography.labelSmall(context)
                            .copyWith(color: AppColors.onSurface),
                      ),
                      Text(
                        'Plots',
                        style: AppTypography.labelSmall(context)
                            .copyWith(color: AppColors.onSurface),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // ── Legend ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.segments.map((s) {
                final pct =
                    total > 0 ? (s.value / total) * 100 : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: s.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          s.label,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: AppColors.onBackground,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${s.value.toInt()}',
                        style: AppTypography.labelMedium(context).copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Insight banner ────────────────────────────────────────────────────────────
class _InsightBanner extends StatelessWidget {
  const _InsightBanner({
    required this.window,
    required this.radius,
    required this.matching,
  });

  final String window;
  final String radius;
  final int matching;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: const BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusLg),
          bottomRight: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.lightbulb_rounded,
                color: AppColors.primary, size: 14),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '$matching plots with similar pruning found within $radius. '
              'Window: $window. Competition concentrated in Thompson Seedless & Sonaka.',
              style: AppTypography.bodySmall(context).copyWith(
                color: AppColors.onPrimaryContainer,
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class _Seg {
  final String label;
  final double value;
  final Color color;
  const _Seg(this.label, this.value, this.color);
}
