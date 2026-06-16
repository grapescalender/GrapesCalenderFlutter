import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';

class CompetitionAnalysisCard extends StatelessWidget {
  const CompetitionAnalysisCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Data
    final totalMarket = 250.0;
    final competitionWindow = 25.0;
    final segments = <_SegmentData>[
      _SegmentData('Thompson Seedless', 5, const Color(0xFF0D8A5A)),
      _SegmentData('Sonaka', 5, const Color(0xFF34D399)),
      _SegmentData('Sharad Seedless', 1, const Color(0xFF60A5FA)),
      _SegmentData('Manik Chaman', 1, const Color(0xFFF59E0B)),
      _SegmentData('Others', 13, const Color(0xFFCBD5E1)),
    ];

    final double chartSize = 220;
    // Increased stroke width for a bolder donut appearance
    final double strokeWidth = 36;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0,6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text('Competition Analysis', style: AppTypography.headlineSmall(context).copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Nearby Harvest Competition', style: AppTypography.bodySmall(context).copyWith(color: Colors.grey[500])),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart + center
              SizedBox(
                width: chartSize,
                height: chartSize,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Oval effect by scaling horizontally
                      Transform.scale(
                        scaleX: 1.12,
                        child: SizedBox(
                          width: chartSize,
                          height: chartSize,
                          child: SfCircularChart(
                            margin: EdgeInsets.zero,
                            series: <DoughnutSeries<_SegmentData, String>>[
                              DoughnutSeries<_SegmentData, String>(
                                dataSource: segments,
                                xValueMapper: (_SegmentData d, _) => d.label,
                                yValueMapper: (_SegmentData d, _) => d.value,
                                pointColorMapper: (_SegmentData d, _) => d.color,
                                innerRadius: '${((chartSize - strokeWidth) / chartSize * 100).toStringAsFixed(0)}%',
                                radius: '100%',
                                startAngle: 270,
                                endAngle: 270 + 360,
                                // Rounded segment ends
                                explode: false,
                                cornerStyle: CornerStyle.bothCurve,
                                animationDuration: 800,
                                dataLabelMapper: (_SegmentData d, _) => '',
                                // stroke width control via gapWidth isn't directly available; innerRadius sets thickness
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Center content
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${competitionWindow.toInt()}', style: AppTypography.displaySmall(context).copyWith(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text('Acres', style: AppTypography.bodyMedium(context).copyWith(color: Colors.grey[700])),
                          const SizedBox(height: 6),
                          Text('Competition Window', style: AppTypography.bodySmall(context).copyWith(color: Colors.grey[500])),
                          const SizedBox(height: 4),
                          Text('${((competitionWindow / totalMarket) * 100).toStringAsFixed(0)}% of Market', style: AppTypography.bodySmall(context).copyWith(color: Colors.grey[500])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Legend & stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Legend
                    Column(
                      children: segments.map((s) {
                        final pct = (s.value / segments.fold<double>(0, (p, e) => p + e.value)) * 100;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            children: [
                              Container(width: 12, height: 12, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                              const SizedBox(width: 12),
                              Expanded(child: Text(s.label, style: AppTypography.bodyMedium(context).copyWith(fontWeight: FontWeight.w700))),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${s.value.toInt()} Acres', style: AppTypography.bodySmall(context).copyWith(color: Colors.grey[700], fontWeight: FontWeight.w700)),
                                  Text('${pct.toStringAsFixed(0)}%', style: AppTypography.bodySmall(context).copyWith(color: Colors.grey[500])),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    // Insight card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFEFFAF4), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFFECFDF6), shape: BoxShape.circle),
                            child: const Icon(Icons.trending_up, color: Color(0xFF059669), size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nearby competition is concentrated in Thompson Seedless and Sonaka varieties.', style: AppTypography.bodySmall(context).copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 6),
                                Text('Expected market competition: Medium', style: AppTypography.bodySmall(context).copyWith(color: Colors.grey[700])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Summary metrics
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.04), borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Market', style: AppTypography.bodySmall(context).copyWith(color: Colors.grey[600])),
                                const SizedBox(height: 6),
                                Text('250 Acres', style: AppTypography.titleSmall(context).copyWith(fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.04), borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Competition Window', style: AppTypography.bodySmall(context).copyWith(color: Colors.grey[600])),
                                const SizedBox(height: 6),
                                Text('25 Acres', style: AppTypography.titleSmall(context).copyWith(fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.04), borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Competition Level', style: AppTypography.bodySmall(context).copyWith(color: Colors.grey[600])),
                                const SizedBox(height: 6),
                                Text('Medium', style: AppTypography.titleSmall(context).copyWith(fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Action
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(onPressed: () {}, child: Text('View Detailed Market Analysis →', style: AppTypography.bodyMedium(context).copyWith(color: const Color(0xFF0D8A5A), fontWeight: FontWeight.w700))),
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
}

class _SegmentData {
  final String label;
  final double value;
  final Color color;
  _SegmentData(this.label, this.value, this.color);
}
