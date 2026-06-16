import 'package:flutter/material.dart';

/// Branding tokens that don't belong in Material ColorScheme (e.g., gradients).
class AppBranding extends ThemeExtension<AppBranding> {

  const AppBranding({
    required this.gradientStart,
    required this.gradientEnd,
  });
  final Color gradientStart;
  final Color gradientEnd;

  LinearGradient get headerGradient => LinearGradient(
        end: Alignment.centerRight,
        colors: [gradientStart, gradientEnd],
      );

  @override
  AppBranding copyWith({
    Color? gradientStart,
    Color? gradientEnd,
  }) => AppBranding(
      gradientStart: gradientStart ?? this.gradientStart,
      gradientEnd: gradientEnd ?? this.gradientEnd,
    );

  @override
  AppBranding lerp(ThemeExtension<AppBranding>? other, double t) {
    if (other is! AppBranding) return this;
    return AppBranding(
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t) ?? gradientStart,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t) ?? gradientEnd,
    );
  }
}

