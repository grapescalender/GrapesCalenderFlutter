import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';

/// Add Plot Card Widget
/// Compact design matching PlotCard style
/// Shows "Add Running Plot" or "Start Plot" based on state
class AddPlotCard extends StatelessWidget {
  const AddPlotCard({
    Key? key,
    required this.isEnabled,
    required this.showStartPlot,
    required this.onTap,
  }) : super(key: key);
  final bool isEnabled;
  final bool showStartPlot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isEnabled
              ? cs.surfaceContainerHighest
              : (isDark
                  ? cs.surfaceContainerHighest.withOpacity(0.5)
                  : cs.surfaceContainerHighest.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isEnabled
                ? cs.outline
                : (isDark
                    ? cs.outline.withOpacity(0.3)
                    : cs.outline.withOpacity(0.3)),
            width: isEnabled ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(isDark ? 0.5 : 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                showStartPlot
                    ? Icons.play_circle_outline
                    : Icons.add_circle_outline,
                size: 32,
                color: isEnabled ? cs.primary : cs.onSurface.withOpacity(0.38),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                showStartPlot ? 'Start Plot' : 'Add Plot',
                style: AppTypography.titleMedium(context).copyWith(
                  color:
                      isEnabled ? cs.onSurface : cs.onSurface.withOpacity(0.38),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isEnabled) ...[
                const SizedBox(height: 4),
                Text(
                  'All running',
                  style: AppTypography.labelLarge(context).copyWith(
                    color: cs.onSurface.withOpacity(0.38),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
