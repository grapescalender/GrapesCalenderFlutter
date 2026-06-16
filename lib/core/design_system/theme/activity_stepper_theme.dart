import 'package:flutter/material.dart';

/// Theme extension for Activity Stepper component theming
/// Provides customizable colors for different activity states
class ActivityStepperTheme extends ThemeExtension<ActivityStepperTheme> {

  const ActivityStepperTheme({
    required this.completedColor,
    required this.currentColor,
    required this.upcomingColor,
    required this.stepIndicatorBorderColor,
    required this.connectorLineColor,
    required this.connectorLineFilledColor,
    required this.cardSelectedBackgroundColor,
    required this.cardActiveBackgroundColor,
    required this.cardSelectedBorderColor,
  });

  /// Default light theme
  factory ActivityStepperTheme.light(ColorScheme colorScheme) {
    return ActivityStepperTheme(
      completedColor: colorScheme.secondary, // Green
      currentColor: colorScheme.primary, // Indigo
      upcomingColor: colorScheme.outlineVariant,
      stepIndicatorBorderColor: colorScheme.outlineVariant,
      connectorLineColor: colorScheme.outlineVariant,
      connectorLineFilledColor: colorScheme.primary,
      cardSelectedBackgroundColor: colorScheme.primary.withOpacity(0.08),
      cardActiveBackgroundColor: colorScheme.primary.withOpacity(0.05),
      cardSelectedBorderColor: colorScheme.primary.withOpacity(0.3),
    );
  }

  /// Default dark theme
  factory ActivityStepperTheme.dark(ColorScheme colorScheme) {
    return ActivityStepperTheme(
      completedColor: colorScheme.secondary, // Green
      currentColor: colorScheme.primary, // Indigo
      upcomingColor: colorScheme.outlineVariant,
      stepIndicatorBorderColor: colorScheme.outlineVariant,
      connectorLineColor: colorScheme.outlineVariant,
      connectorLineFilledColor: colorScheme.primary,
      cardSelectedBackgroundColor: colorScheme.primary.withOpacity(0.12),
      cardActiveBackgroundColor: colorScheme.primary.withOpacity(0.08),
      cardSelectedBorderColor: colorScheme.primary.withOpacity(0.4),
    );
  }
  /// Color for completed activities
  final Color completedColor;

  /// Color for current/active activities
  final Color currentColor;

  /// Color for upcoming activities
  final Color upcomingColor;

  /// Color for step indicator border (upcoming state)
  final Color stepIndicatorBorderColor;

  /// Color for connector lines
  final Color connectorLineColor;

  /// Color for connector line (filled/completed)
  final Color connectorLineFilledColor;

  /// Color for activity card background when selected
  final Color cardSelectedBackgroundColor;

  /// Color for activity card background when active
  final Color cardActiveBackgroundColor;

  /// Color for activity card border when selected
  final Color cardSelectedBorderColor;

  @override
  ActivityStepperTheme copyWith({
    Color? completedColor,
    Color? currentColor,
    Color? upcomingColor,
    Color? stepIndicatorBorderColor,
    Color? connectorLineColor,
    Color? connectorLineFilledColor,
    Color? cardSelectedBackgroundColor,
    Color? cardActiveBackgroundColor,
    Color? cardSelectedBorderColor,
  }) => ActivityStepperTheme(
      completedColor: completedColor ?? this.completedColor,
      currentColor: currentColor ?? this.currentColor,
      upcomingColor: upcomingColor ?? this.upcomingColor,
      stepIndicatorBorderColor:
          stepIndicatorBorderColor ?? this.stepIndicatorBorderColor,
      connectorLineColor: connectorLineColor ?? this.connectorLineColor,
      connectorLineFilledColor:
          connectorLineFilledColor ?? this.connectorLineFilledColor,
      cardSelectedBackgroundColor:
          cardSelectedBackgroundColor ?? this.cardSelectedBackgroundColor,
      cardActiveBackgroundColor:
          cardActiveBackgroundColor ?? this.cardActiveBackgroundColor,
      cardSelectedBorderColor:
          cardSelectedBorderColor ?? this.cardSelectedBorderColor,
    );

  @override
  ActivityStepperTheme lerp(
    ThemeExtension<ActivityStepperTheme>? other,
    double t,
  ) {
    if (other is! ActivityStepperTheme) {
      return this;
    }

    return ActivityStepperTheme(
      completedColor: Color.lerp(completedColor, other.completedColor, t) ??
          completedColor,
      currentColor:
          Color.lerp(currentColor, other.currentColor, t) ?? currentColor,
      upcomingColor:
          Color.lerp(upcomingColor, other.upcomingColor, t) ?? upcomingColor,
      stepIndicatorBorderColor: Color.lerp(stepIndicatorBorderColor,
              other.stepIndicatorBorderColor, t) ??
          stepIndicatorBorderColor,
      connectorLineColor: Color.lerp(
              connectorLineColor, other.connectorLineColor, t) ??
          connectorLineColor,
      connectorLineFilledColor: Color.lerp(connectorLineFilledColor,
              other.connectorLineFilledColor, t) ??
          connectorLineFilledColor,
      cardSelectedBackgroundColor: Color.lerp(cardSelectedBackgroundColor,
              other.cardSelectedBackgroundColor, t) ??
          cardSelectedBackgroundColor,
      cardActiveBackgroundColor: Color.lerp(cardActiveBackgroundColor,
              other.cardActiveBackgroundColor, t) ??
          cardActiveBackgroundColor,
      cardSelectedBorderColor: Color.lerp(
              cardSelectedBorderColor, other.cardSelectedBorderColor, t) ??
          cardSelectedBorderColor,
    );
  }
}
