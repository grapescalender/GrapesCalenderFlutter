import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/entities/plot_entity.dart';

class PlotListCard extends StatelessWidget {
  const PlotListCard({
    super.key,
    required this.plot,
    required this.onViewDetails,
    this.currentActivityLabel,
  });

  final PlotEntity plot;
  final VoidCallback onViewDetails;
  final String? currentActivityLabel;

  bool get _hasCuttingDate => plot.pruningDate != null;
  bool get _hasActiveSeason => plot.isRunning && _hasCuttingDate;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = cs.primary;

    return AppCard(
      padding: EdgeInsets.zero,
      color: accent,
      borderRadius: AppSpacing.radiusLg,
      boxBorder: Border.all(color: cs.outlineVariant),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Stack(
          children: [
            Positioned(
              right: -AppSpacing.xl,
              top: -AppSpacing.xl,
              child: _DecorCircle(color: cs.onPrimary),
            ),
            Positioned(
              left: -AppSpacing.xl,
              bottom: -AppSpacing.xxl,
              child: _DecorCircle(color: cs.onPrimary),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.smMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${plot.name} - ${_displayVariety(plot.cropType)}',
                    style: AppTypography.titleLarge(context).copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (_hasActiveSeason)
                    Row(
                      children: [
                        _LightChip(label: _cycleName(plot.pruningDate)),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            _seasonName(plot.pruningDate),
                            style: AppTypography.labelLarge(context).copyWith(
                              color: cs.onPrimary.withValues(alpha: 0.78),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  else
                    _LightChip(
                      label: _hasCuttingDate
                          ? 'No Active Season'
                          : 'Cutting Date Not Added',
                    ),
                  const SizedBox(height: AppSpacing.smMd),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricBox(
                          label: 'Cutting Date',
                          value: _hasCuttingDate
                              ? DateFormat('dd MMM yyyy')
                                  .format(plot.pruningDate!)
                              : 'Not Added',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: _MetricBox(
                          label: 'Day After Pruning',
                          value: _hasCuttingDate
                              ? '${plot.daysSincePruning}'
                              : '--',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.smMd),
                  Row(
                    children: [
                      Expanded(
                        child: _LightChip(
                          label: _statusLabel,
                          icon: _hasActiveSeason
                              ? Icons.eco_rounded
                              : Icons.info_outline_rounded,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      AppButton(
                        label: _actionLabel,
                        icon: Icons.arrow_forward_rounded,
                        variant: AppButtonVariant.text,
                        size: AppButtonSize.small,
                        foregroundColor: cs.onPrimary,
                        onPressed: onViewDetails,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _statusLabel {
    if (!_hasCuttingDate) return 'Cutting Date Not Added';
    if (!plot.isRunning) return 'No Active Season';
    return 'Current Stage: ${currentActivityLabel ?? _deriveStage(plot.daysSincePruning)}';
  }

  String get _actionLabel {
    if (!_hasCuttingDate) return 'Add Cutting Date';
    if (!plot.isRunning) return 'Start Season';
    return 'View Details';
  }

  String _displayVariety(String cropType) {
    if (cropType.trim().isEmpty || cropType.toLowerCase() == 'grapes') {
      return 'Thompson Seedless';
    }
    return cropType;
  }

  String _cycleName(DateTime? pruningDate) {
    if (pruningDate == null) return 'Cycle not set';
    if (pruningDate.month >= DateTime.april &&
        pruningDate.month <= DateTime.september) {
      return 'April Cycle';
    }
    return 'October Cycle';
  }

  String _seasonName(DateTime? pruningDate) {
    if (pruningDate == null) return 'Season not set';
    final nextYear = ((pruningDate.year + 1) % 100).toString().padLeft(2, '0');
    return 'Season ${pruningDate.year}-$nextYear';
  }

  String _deriveStage(int days) {
    if (days <= 14) return 'Post-pruning: Shoot Emergence';
    if (days <= 35) return 'Vegetative Growth';
    if (days <= 70) return 'Berry Setting';
    return 'Ripening & Canopy';
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: AppSpacing.xxl),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: cs.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: cs.onPrimary.withValues(alpha: 0.28)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.titleMedium(context).copyWith(
              color: cs.onPrimary,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelLarge(context).copyWith(
              color: cs.onPrimary.withValues(alpha: 0.76),
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _LightChip extends StatelessWidget {
  const _LightChip({
    required this.label,
    this.icon,
  });

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: cs.onPrimary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: cs.onPrimary.withValues(alpha: 0.52)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Text(
              label,
              style: AppTypography.labelLarge(context).copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.xhuge,
      height: AppSpacing.xhuge,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.08),
      ),
    );
  }
}
