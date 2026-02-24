import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../domain/entities/plot_entity.dart';

/// Compact Plot Card Widget
/// Modern, lightweight design inspired by Groww's stock cards
/// Features: Compact layout, clean spacing, subtle selection state
class PlotCard extends StatelessWidget {
  final PlotEntity plot;
  final bool isSelected;
  final VoidCallback onTap;

  const PlotCard({
    Key? key,
    required this.plot,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        margin: EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark 
                  ? cs.primary.withOpacity(0.18)
                  : cs.primary.withOpacity(0.06))
              : cs.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : cs.outline,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cs.primary.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Plot Name Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plot Name
                  Expanded(
                    child: Text(
                      plot.name,
                      style: AppTypography.titleMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? cs.primary
                            : cs.onSurface,
                        fontSize: _responsiveFontSize(context, 15, 16, 17),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Running Badge
                  if (plot.isRunning)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: semantic.success.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                      ),
                      child: Text(
                        'Active',
                        style: AppTypography.labelSmall(context).copyWith(
                          color: semantic.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              // Day Count (Highlighted)
              if (plot.hasPruningDate) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? cs.primary.withOpacity(0.10)
                        : cs.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${plot.daysSincePruning}',
                        style: AppTypography.titleSmall(context).copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: _responsiveFontSize(context, 18, 20, 22),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'days',
                        style: AppTypography.bodySmall(context).copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: _responsiveFontSize(context, 11, 12, 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              
              // Pruning Date (Secondary)
              Text(
                plot.hasPruningDate
                    ? _formatDate(plot.pruningDate!)
                    : 'Not pruned',
                style: AppTypography.bodySmall(context).copyWith(
                  color: cs.onSurfaceVariant,
                  fontSize: _responsiveFontSize(context, 11, 12, 13),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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

  /// Format date to compact string
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    if (difference < 30) {
      final weeks = (difference / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    }
    
    return DateFormat('MMM dd').format(date);
  }
}
