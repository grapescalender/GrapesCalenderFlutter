import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

/// Semantic colors that are NOT part of Material ColorScheme (success/warning/info).
/// Kept in Theme to avoid hardcoding colors in widgets.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {

  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
  });
  final Color success;
  final Color warning;
  final Color info;

  static const AppSemanticColors light = AppSemanticColors(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
  );

  static const AppSemanticColors dark = AppSemanticColors(
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
  }) => AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
    );
  }
}

