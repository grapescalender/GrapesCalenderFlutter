import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';

/// Add Plot Card Widget
/// Compact design matching PlotCard style
/// Shows "Add Running Plot" or "Start Plot" based on state
class AddPlotCard extends StatelessWidget {
  final bool isEnabled;
  final bool showStartPlot;
  final VoidCallback onTap;

  const AddPlotCard({
    Key? key,
    required this.isEnabled,
    required this.showStartPlot,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isEnabled
              ? (isDark ? AppColors.darkSurface : AppColors.surfaceVariant)
              : (isDark 
                  ? AppColors.darkSurface.withOpacity(0.5)
                  : AppColors.surfaceVariant.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isEnabled
                ? (isDark ? AppColors.darkOutline : AppColors.outline)
                : (isDark 
                    ? AppColors.darkOutline.withOpacity(0.3)
                    : AppColors.outline.withOpacity(0.3)),
            width: isEnabled ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
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
                showStartPlot ? Icons.play_circle_outline : Icons.add_circle_outline,
                size: 32,
                color: isEnabled
                    ? AppColors.primary
                    : AppColors.onSurfaceDisabled,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                showStartPlot ? 'Start Plot' : 'Add Plot',
                style: AppTypography.titleSmall(context).copyWith(
                  color: isEnabled
                      ? AppColors.onSurface
                      : AppColors.onSurfaceDisabled,
                  fontWeight: FontWeight.w600,
                  fontSize: _responsiveFontSize(context, 13, 14, 15),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!isEnabled) ...[
                const SizedBox(height: 4),
                Text(
                  'All running',
                  style: AppTypography.bodySmall(context).copyWith(
                    color: AppColors.onSurfaceDisabled,
                    fontSize: 10,
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

  /// Responsive font size helper
  double _responsiveFontSize(
    BuildContext context,
    double mobile,
    double tablet,
    double desktop,
  ) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return desktop;
    if (width >= 600) return tablet;
    return mobile;
  }
}
