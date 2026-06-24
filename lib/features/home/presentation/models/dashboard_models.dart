import 'package:flutter/material.dart';

class MarketInsightModel {
  const MarketInsightModel({
    required this.id,
    required this.title,
    required this.value,
    required this.trendLabel,
    required this.status,
    required this.icon,
  });

  final String id;
  final String title;
  final String value;
  final String trendLabel;
  final MarketInsightStatus status;
  final IconData icon;
}

enum MarketInsightStatus {
  positive,
  neutral,
  caution,
}

class ConsultantRecommendationModel {
  const ConsultantRecommendationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.consultantName,
    required this.priority,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String message;
  final String consultantName;
  final RecommendationPriority priority;
  final DateTime createdAt;
}

enum RecommendationPriority {
  low,
  medium,
  high,
}
