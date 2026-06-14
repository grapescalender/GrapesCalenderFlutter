import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/responsive/responsive_utils.dart';
import '../../../../shared/widgets/app_ui.dart';
import '../../domain/entities/plot_entity.dart';
import '../providers/plot_notifier.dart';
import '../providers/plot_state.dart';
import 'add_plot_card.dart';
import 'plot_card.dart';

/// Plots Section Widget
/// Modern horizontal scrolling section with compact plot cards
class PlotsSection extends ConsumerStatefulWidget {
  const PlotsSection({Key? key}) : super(key: key);

  @override
  ConsumerState<PlotsSection> createState() => _PlotsSectionState();
}

class _PlotsSectionState extends ConsumerState<PlotsSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  AsyncViewStatus _status(PlotState plotState) {
    if (plotState.isLoading) return AsyncViewStatus.loading;
    if (plotState.errorMessage != null) return AsyncViewStatus.error;
    if (plotState.plots.isEmpty) return AsyncViewStatus.empty;
    return AsyncViewStatus.success;
  }

  (double width, double height) _cardDimensions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = ResponsiveUtils.isTablet(context);
    final cardWidth = (isTablet ? screenWidth * 0.32 : screenWidth * 0.65)
        .clamp(200.0, 280.0);
    final cardHeight = isTablet ? 130.0 : 120.0;
    return (cardWidth, cardHeight);
  }

  @override
  Widget build(BuildContext context) {
    final plotState = ref.watch(plotNotifierProvider);
    final plotNotifier = ref.read(plotNotifierProvider.notifier);
    final (cardWidth, cardHeight) = _cardDimensions(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: 'My Plots',
          trailing: _buildSortButton(context, plotState, plotNotifier),
        ),
        const SizedBox(height: AppSpacing.md),
        AppAsyncContent(
          status: _status(plotState),
          errorTitle: 'Failed to load plots',
          errorMessage: plotState.errorMessage,
          onRetry: plotNotifier.loadPlots,
          emptyIcon: Icons.agriculture_outlined,
          emptyTitle: 'No plots found',
          emptySubtitle: 'Add your first plot to get started',
          loading: AppLoadingState.horizontalCards(
            cardWidth: cardWidth,
            cardHeight: cardHeight,
          ),
          builder: (context) {
            final displayPlots = plotNotifier.hasRunningPlots
                ? plotNotifier.runningPlots
                : plotState.plots;
            final showStartPlot = !plotNotifier.hasRunningPlots;
            final isAddCardEnabled = !plotNotifier.areAllPlotsRunning;

            return _buildPlotCardsList(
              context,
              displayPlots,
              plotState.selectedPlotId,
              showStartPlot,
              isAddCardEnabled,
              plotNotifier,
              cardWidth,
              cardHeight,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSortButton(
    BuildContext context,
    PlotState plotState,
    PlotNotifier plotNotifier,
  ) {
    final cs = Theme.of(context).colorScheme;
    final label = plotState.sortOrder == PlotSortOrder.highToLow
        ? 'High to Low'
        : 'Low to High';

    return AppMinTouchTarget(
      child: Semantics(
        button: true,
        label: 'Sort plots, $label',
        child: InkWell(
          onTap: () => plotNotifier.toggleSortOrder(),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  plotState.sortOrder == PlotSortOrder.highToLow
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 14,
                  color: cs.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: AppTypography.bodySmall(context).copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlotCardsList(
    BuildContext context,
    List<PlotEntity> plots,
    String? selectedPlotId,
    bool showStartPlot,
    bool isAddCardEnabled,
    PlotNotifier plotNotifier,
    double clampedWidth,
    double cardHeight,
  ) {
    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        itemCount: plots.length + (showStartPlot || isAddCardEnabled ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          if (index == plots.length) {
            return SizedBox(
              key: const ValueKey('add_plot_card'),
              width: clampedWidth,
              child: AddPlotCard(
                isEnabled: isAddCardEnabled,
                showStartPlot: showStartPlot,
                onTap: () {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          showStartPlot
                              ? 'Start Plot clicked'
                              : 'Add Running Plot clicked',
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            );
          }

          final plot = plots[index];
          final isSelected = plot.id == selectedPlotId;

          return SizedBox(
            key: ValueKey('plot_${plot.id}'),
            width: clampedWidth,
            child: PlotCard(
              plot: plot,
              isSelected: isSelected,
              onTap: () {
                plotNotifier.selectPlot(plot.id);
                _scrollToIndex(index, clampedWidth);
              },
            ),
          );
        },
      ),
    );
  }

  void _scrollToIndex(int index, double cardWidth) {
    if (!_scrollController.hasClients) return;

    final scrollPosition = index * (cardWidth + AppSpacing.md);
    final maxScroll = _scrollController.position.maxScrollExtent;
    final targetPosition = scrollPosition.clamp(0.0, maxScroll);

    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }
}
