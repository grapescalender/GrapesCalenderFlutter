import 'package:flutter/material.dart';
import '../../core/design_system/spacing/app_spacing.dart';

/// Modern Card Widget
/// Minimal, clean card design inspired by Groww
/// Supports elevation, padding, and custom styling
class AppCard extends StatelessWidget {

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    
    final cardColor = color ?? cs.surface;
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
                  color: cs.shadow.withOpacity(0.08),
                  blurRadius: (cardElevation * 2).clamp(2, 12),
                  offset: Offset(0, cardElevation.clamp(1, 6)),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      cardContent = Semantics(
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          child: cardContent,
        ),
      );
    } else {
      cardContent = Semantics(container: true, child: cardContent);
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
