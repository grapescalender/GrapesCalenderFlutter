import 'package:flutter/material.dart';
import '../../../core/design_system/spacing/app_spacing.dart';
import '../../../core/design_system/typography/app_typography.dart';
import '../accessibility/app_accessibility.dart';
import '../app_button.dart';

/// Standard section header with optional trailing action.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.padding,
  });
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    var actionWidget = trailing;
    if (actionWidget == null && actionLabel != null && onAction != null) {
      actionWidget = AppButton.text(
        label: actionLabel!,
        onPressed: onAction,
        icon: actionIcon,
        size: AppButtonSize.small,
      );
    }

    return AppSemantics(
      header: true,
      label: subtitle != null ? '$title, $subtitle' : title,
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.headlineMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: AppTypography.labelLarge(context).copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (actionWidget != null) actionWidget,
          ],
        ),
      ),
    );
  }
}
