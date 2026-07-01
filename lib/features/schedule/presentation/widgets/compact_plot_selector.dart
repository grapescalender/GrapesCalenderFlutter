import 'package:flutter/material.dart';

import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../home/domain/entities/plot_entity.dart';

class CompactPlotSelector extends StatelessWidget {
  const CompactPlotSelector({
    required this.plots,
    required this.selectedPlotId,
    required this.onPlotChanged,
    super.key,
  });

  final List<PlotEntity> plots;
  final String selectedPlotId;
  final ValueChanged<String> onPlotChanged;

  @override
  Widget build(BuildContext context) {
    final selectedPlot = plots.firstWhere(
      (plot) => plot.id == selectedPlotId,
      orElse: () => plots.first,
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: () => _openSelector(context),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smMd,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.24),
                Colors.white.withValues(alpha: 0.12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.34),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: AppSpacing.md,
                offset: const Offset(0, AppSpacing.sm),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Plot',
                style: AppTypography.labelLarge(context).copyWith(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${selectedPlot.name} - ${selectedPlot.cropType}',
                      style: AppTypography.titleLarge(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.05,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: AppSpacing.lg,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openSelector(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: 640,
        maxHeight: MediaQuery.sizeOf(context).height * 0.72,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      builder: (sheetContext) => DashboardBottomSheetFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DashboardSheetHeader(
              title: 'Select Plot',
              subtitle: 'Choose the plot for this schedule',
              icon: Icons.agriculture_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final plot in plots) ...[
              DashboardListItem(
                title: plot.name,
                subtitle: plot.cropType,
                icon: Icons.agriculture_rounded,
                selected: plot.id == selectedPlotId,
                trailing: plot.id == selectedPlotId
                    ? Icon(
                        Icons.check_rounded,
                        color: DashboardStyle.of(sheetContext).primary,
                      )
                    : null,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onPlotChanged(plot.id);
                },
              ),
              if (plot != plots.last) const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}
