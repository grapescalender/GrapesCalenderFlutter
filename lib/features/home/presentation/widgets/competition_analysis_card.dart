import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';

class CompetitionAnalysisCard extends StatelessWidget {
  const CompetitionAnalysisCard({super.key});

  // ── Static data (unchanged – no business logic change) ──────────
  static const double _totalMarket = 250;
  static const double _competitionWindow = 25;
  static const String _competitionLevel = 'Medium';

  static const List<_SegmentData> _segments = [
    _SegmentData('Thompson Seedless', 5, Color(0xFF0D8A5A)),
    _SegmentData('Sonaka', 5, Color(0xFF34D399)),
    _SegmentData('Sharad Seedless', 1, Color(0xFF60A5FA)),
    _SegmentData('Manik Chaman', 1, Color(0xFFF59E0B)),
    _SegmentData('Others', 13, Color(0xFFCBD5E1)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ─────────────────────────────────────────
          _buildHeader(context),

          const Divider(height: 1, color: AppColors.outline),

          // ── Chart + Legend ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: _buildChartAndLegend(context),
          ),

          // ── Summary Metrics ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.cardPadding, 0, AppSpacing.cardPadding, AppSpacing.cardPadding),
            child: _buildSummaryRow(context),
          ),

          // ── Insight Banner ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.cardPadding, 0, AppSpacing.cardPadding, AppSpacing.cardPadding),
            child: _buildInsightBanner(context),
          ),

          // ── Footer CTA ──────────────────────────────────────────
          _buildFooterCta(context),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.donut_large_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Competition Analysis',
                  style: AppTypography.headlineSmall(context).copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onBackground,
                  ),
                ),
                Text(
                  'Nearby harvest competition breakdown',
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          _CompetitionBadge(level: _competitionLevel),
        ],
      ),
    );
  }

  // ── Donut Chart + Legend ──────────────────────────────────────────────────
  Widget _buildChartAndLegend(BuildContext context) {
    const double chartSize = 190;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Chart
        SizedBox(
          width: chartSize,
          height: chartSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SfCircularChart(
                margin: EdgeInsets.zero,
                series: <DoughnutSeries<_SegmentData, String>>[
                  DoughnutSeries<_SegmentData, String>(
                    dataSource: _segments,
                    xValueMapper: (_SegmentData d, _) => d.label,
                    yValueMapper: (_SegmentData d, _) => d.value,
                    pointColorMapper: (_SegmentData d, _) => d.color,
                    innerRadius: '62%',
                    radius: '100%',
                    startAngle: 270,
                    endAngle: 270 + 360,
                    cornerStyle: CornerStyle.bothCurve,
                    animationDuration: 800,
                  ),
                ],
              ),
              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_competitionWindow.toInt()}',
                    style: AppTypography.displaySmall(context).copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.onBackground,
                    ),
                  ),
                  Text(
                    'Acres',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      '${((_competitionWindow / _totalMarket) * 100).toStringAsFixed(0)}%',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        // Legend
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _segments.map((s) {
              final total = _segments.fold<double>(0, (p, e) => p + e.value);
              final pct = (s.value / total) * 100;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: s.color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.label,
                        style: AppTypography.bodySmall(context).copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${s.value.toInt()} ac',
                          style: AppTypography.bodySmall(context).copyWith(
                            color: AppColors.onBackground,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${pct.toStringAsFixed(0)}%',
                          style: AppTypography.bodySmall(context).copyWith(
                            color: AppColors.onSurface,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── 3-Metric Summary Row ─────────────────────────────────────────────────
  Widget _buildSummaryRow(BuildContext context) {
    return Row(
      children: [
        _SummaryTile(
          label: 'Total Market',
          value: '${_totalMarket.toInt()} Ac',
          icon: Icons.landscape_rounded,
          iconColor: AppColors.info,
          bgColor: const Color(0xFFEFF6FF),
        ),
        const SizedBox(width: AppSpacing.smMd),
        _SummaryTile(
          label: 'Competition',
          value: '${_competitionWindow.toInt()} Ac',
          icon: Icons.groups_rounded,
          iconColor: const Color(0xFFF59E0B),
          bgColor: const Color(0xFFFFFBEB),
        ),
        const SizedBox(width: AppSpacing.smMd),
        _SummaryTile(
          label: 'Level',
          value: _competitionLevel,
          icon: Icons.speed_rounded,
          iconColor: const Color(0xFFF59E0B),
          bgColor: const Color(0xFFFFF7ED),
        ),
      ],
    );
  }

  // ── Insight Banner ────────────────────────────────────────────────────────
  Widget _buildInsightBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.lightbulb_rounded, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Market Insight',
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Nearby competition is concentrated in Thompson Seedless and Sonaka varieties. Expected market competition: Medium.',
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Footer CTA ────────────────────────────────────────────────────────────
  Widget _buildFooterCta(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusLg),
          bottomRight: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.smMd,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Updated today',
              style: AppTypography.bodySmall(context).copyWith(
                color: AppColors.onSurface,
                fontSize: 11,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'View Full Analysis',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Competition Badge ─────────────────────────────────────────────────────
class _CompetitionBadge extends StatelessWidget {
  const _CompetitionBadge({required this.level});
  final String level;

  Color get _color {
    switch (level.toUpperCase()) {
      case 'LOW':
        return AppColors.success;
      case 'HIGH':
        return AppColors.error;
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Color get _bg {
    switch (level.toUpperCase()) {
      case 'LOW':
        return AppColors.successLight;
      case 'HIGH':
        return AppColors.errorLight;
      default:
        return const Color(0xFFFFF7ED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: _color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            level,
            style: AppTypography.bodySmall(context).copyWith(
              color: _color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary Tile ─────────────────────────────────────────────────────────
class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
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
        padding: const EdgeInsets.all(AppSpacing.smMd),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(icon, color: iconColor, size: 14),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTypography.titleSmall(context).copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.bodySmall(context).copyWith(
                color: AppColors.onSurface,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data Model ────────────────────────────────────────────────────────────
class _SegmentData {
  final String label;
  final double value;
  final Color color;
  const _SegmentData(this.label, this.value, this.color);
}
