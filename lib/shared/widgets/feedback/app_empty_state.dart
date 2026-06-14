import 'package:flutter/material.dart';
import '../../../core/design_system/spacing/app_spacing.dart';
import '../../../core/design_system/typography/app_typography.dart';
import '../accessibility/app_accessibility.dart';
import '../app_button.dart';
import '../app_card.dart';

/// Production empty state — icon, title, optional subtitle and CTA.
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;
  final EdgeInsetsGeometry? padding;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.compact = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final iconSize = compact ? 32.0 : 40.0;
    final verticalPad = compact ? AppSpacing.md : AppSpacing.lg;

    return AppSemantics(
      label: '$title${subtitle != null ? ', $subtitle' : ''}',
      child: AppCard.defaultStyle(
        padding: padding ?? EdgeInsets.all(verticalPad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: cs.onSurfaceVariant),
            SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall(context).copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
              AppButton.primary(
                label: actionLabel!,
                onPressed: onAction,
                size: compact ? AppButtonSize.small : AppButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
