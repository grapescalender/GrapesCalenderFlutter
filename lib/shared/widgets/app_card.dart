import 'package:flutter/material.dart';
import '../../core/design_system/colors/app_colors.dart';
import '../../core/design_system/spacing/app_spacing.dart';

/// Modern Card Widget
/// Minimal, clean card design inspired by Groww
/// Supports elevation, padding, and custom styling
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final double? borderRadius;
  final VoidCallback? onTap;
  final Border? border;
  final BoxBorder? boxBorder;
  final bool showShadow;

  const AppCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.border,
    this.boxBorder,
    this.showShadow = true,
  }) : super(key: key);

  /// Card with default styling
  const AppCard.defaultStyle({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Border? border,
    VoidCallback? onTap,
  }) : this(
          key: key,
          child: child,
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          margin: margin,
          color: color,
          border: border,
          elevation: AppSpacing.elevationSubtle,
          borderRadius: AppSpacing.radiusMd,
          onTap: onTap,
        );

  /// Card with elevated styling
  const AppCard.elevated({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) : this(
          key: key,
          child: child,
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          margin: margin,
          elevation: AppSpacing.elevationMedium,
          borderRadius: AppSpacing.radiusMd,
          onTap: onTap,
        );

  /// Card with flat styling (no elevation)
  const AppCard.flat({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    Border? border,
  }) : this(
          key: key,
          child: child,
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          margin: margin,
          elevation: 0,
          borderRadius: AppSpacing.radiusMd,
          onTap: onTap,
          border: border,
          showShadow: false,
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final cardColor = color ?? 
        (isDark ? AppColors.darkSurface : AppColors.surface);
    final cardElevation = elevation ?? AppSpacing.elevationSubtle;
    final cardBorderRadius = borderRadius ?? AppSpacing.radiusMd;
    final cardPadding = padding ?? const EdgeInsets.all(AppSpacing.cardPadding);
    final cardMargin = margin ?? EdgeInsets.zero;

    Widget cardContent = Container(
      padding: cardPadding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: boxBorder ?? border,
        boxShadow: showShadow && cardElevation > 0
            ? [
                BoxShadow(
                  color: isDark
                      ? AppColors.darkShadow
                      : AppColors.shadow,
                  blurRadius: cardElevation * 2,
                  offset: Offset(0, cardElevation),
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: cardContent,
      );
    }

    if (cardMargin != EdgeInsets.zero) {
      cardContent = Padding(
        padding: cardMargin,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
