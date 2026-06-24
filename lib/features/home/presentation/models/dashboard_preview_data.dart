import 'package:flutter/material.dart';

import 'dashboard_models.dart';

class DashboardPreviewData {
  const DashboardPreviewData._();

  static List<MarketInsightModel> marketInsights() => const [
        MarketInsightModel(
          id: 'grape_rate',
          title: 'Export Grape Rate',
          value: '₹82 / kg',
          trendLabel: '+6% this week',
          status: MarketInsightStatus.positive,
          icon: Icons.currency_rupee_rounded,
        ),
        MarketInsightModel(
          id: 'arrival',
          title: 'Market Arrival',
          value: 'Moderate',
          trendLabel: 'Good selling window',
          status: MarketInsightStatus.neutral,
          icon: Icons.local_shipping_outlined,
        ),
      ];

  static List<ConsultantRecommendationModel> recommendations() => [
        ConsultantRecommendationModel(
          id: 'rec_powdery',
          title: 'Monitor powdery mildew risk',
          message:
              'Humidity is rising. Inspect canopy and complete preventive spray if symptoms appear.',
          consultantName: 'Dr. Patil',
          priority: RecommendationPriority.medium,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ];
}
