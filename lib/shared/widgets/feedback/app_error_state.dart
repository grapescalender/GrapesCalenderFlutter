import 'package:flutter/material.dart';
import '../../../core/design_system/spacing/app_spacing.dart';
import '../../../core/design_system/typography/app_typography.dart';
import '../accessibility/app_accessibility.dart';
import '../app_button.dart';
import '../app_card.dart';

/// Production error state — supports inline (row) and full (column) layouts.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.retryLabel = 'Retry',
    this.onRetry,
    this.inline = false,
    this.padding,
  });
  final String title;
  final String? message;
  final String? retryLabel;
  final VoidCallback? onRetry;
  final bool inline;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (inline) {
      return AppSemantics(
        label: '$title${message != null ? ', $message' : ''}',
        child: AppCard.defaultStyle(
          color: cs.errorContainer,
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          border: Border.all(color: cs.error.withOpacity(0.2)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline, color: cs.error, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onErrorContainer,
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        message!,
                        style: AppTypography.labelLarge(context).copyWith(
                          color: cs.onErrorContainer,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onRetry != null)
                AppMinTouchTarget(
                  child: IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    color: cs.error,
                    tooltip: retryLabel,
                    onPressed: onRetry,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return AppSemantics(
      label: '$title${message != null ? ', $message' : ''}',
      child: AppCard.defaultStyle(
        color: cs.errorContainer,
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        border: Border.all(color: cs.error.withOpacity(0.2)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: cs.error, size: 40),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.bodyLarge(context).copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onErrorContainer,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: AppTypography.labelLarge(context).copyWith(
                  color: cs.onErrorContainer,
                ),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              AppButton.primary(
                label: retryLabel!,
                icon: Icons.refresh,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
