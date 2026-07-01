import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/feedback/app_empty_state.dart';
import '../../../../shared/widgets/feedback/app_loading_state.dart';
import '../../../activity/presentation/providers/activity_providers.dart';
import '../../domain/entities/plot_entity.dart';
import '../providers/plot_notifier.dart';
import '../widgets/add_plot_form.dart';
import '../widgets/plot_list_card.dart';
import '../widgets/plots_section.dart';
import '../widgets/start_season_bottom_sheet.dart';

class PlotsPage extends ConsumerWidget {
  const PlotsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plotState = ref.watch(plotNotifierProvider);
    final activityState = ref.watch(activityNotifierProvider);
    final activeActivity = activityState.activities
            .where((activity) => activity.isActive)
            .firstOrNull ??
        activityState.activities
            .where((activity) => activity.isPending)
            .firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: _PlotsHeader()),
            if (plotState.isLoading)
              const SliverFillRemaining(
                child: AppLoadingState.listRows(),
              )
            else if (plotState.plots.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: AppEmptyState(
                  icon: Icons.agriculture_rounded,
                  title: 'No plots added yet',
                  subtitle: 'Add your first grape plot to start tracking.',
                  actionLabel: 'Add Plot',
                  onAction: () => _showAddPlotForm(context),
                ),
              )
            else ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  0,
                  AppSpacing.screenHorizontal,
                  AppSpacing.xl,
                ),
                sliver: SliverList.separated(
                  itemCount: plotState.plots.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final plot = plotState.plots[index];
                    final activityLabel = plot.id == plotState.selectedPlotId
                        ? activeActivity?.type.displayName
                        : null;
                    return PlotListCard(
                      plot: plot,
                      currentActivityLabel: activityLabel,
                      onViewDetails: () => plot.isRunning
                          ? _showPlotDetails(context, plot)
                          : _showStartSeason(context, plot, ref),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPlotForm(context),
        tooltip: 'Add Plot',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  static void _showAddPlotForm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: 640,
        maxHeight: MediaQuery.sizeOf(context).height * 0.76,
      ),
      builder: (_) => const AddPlotForm(),
    );
  }

  static void _showPlotDetails(BuildContext context, PlotEntity plot) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PlotDetailsSheet(plot: plot),
    );
  }

  static void _showStartSeason(
    BuildContext context,
    PlotEntity plot,
    WidgetRef ref,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: 640,
        maxHeight: MediaQuery.sizeOf(context).height * 0.76,
      ),
      builder: (_) => StartSeasonBottomSheet(
        plot: plot,
        onStart: ({
          required seasonYear,
          required cycle,
          required pruningDate,
        }) {
          ref.read(plotNotifierProvider.notifier).startSeason(
                plotId: plot.id,
                pruningDate: pruningDate,
              );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$cycle $seasonYear started for ${plot.name}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}

class _PlotsHeader extends StatelessWidget {
  const _PlotsHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.md,
        AppSpacing.screenHorizontal,
        AppSpacing.smMd,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.agriculture_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.smMd),
          Expanded(
            child: Text(
              'Plots',
              style: AppTypography.titleLarge(context).copyWith(
                color: AppColors.onBackground,
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
