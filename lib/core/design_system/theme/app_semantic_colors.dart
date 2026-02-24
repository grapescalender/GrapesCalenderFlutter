import 'package:flutter/material.dart';

/// Semantic colors that are NOT part of Material ColorScheme (success/warning/info).
/// Kept in Theme to avoid hardcoding colors in widgets.
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color success;
  final Color warning;
  final Color info;

  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.info,
  });

  static const AppSemanticColors light = AppSemanticColors(
    success: Colors.green,
    warning: Colors.orange,
    info: Colors.blue,
  );

  static const AppSemanticColors dark = AppSemanticColors(
    success: Colors.greenAccent,
    warning: Colors.orangeAccent,
    info: Colors.lightBlueAccent,
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

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

