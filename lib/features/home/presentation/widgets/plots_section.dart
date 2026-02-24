import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/responsive/responsive_utils.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../domain/entities/plot_entity.dart';
import '../providers/plot_notifier.dart';
import '../providers/plot_state.dart';
import 'add_plot_card.dart';
import 'plot_card.dart';

/// Plots Section Widget
/// Modern horizontal scrolling section with compact plot cards
/// Inspired by Groww's stock list design
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

  @override
  Widget build(BuildContext context) {
    final plotState = ref.watch(plotNotifierProvider);
    final plotNotifier = ref.read(plotNotifierProvider.notifier);

    // Loading
    if (plotState.isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, plotState, plotNotifier),
          SizedBox(height: AppSpacing.md),
          _buildLoadingState(context),
        ],
      );
    }

    // Error
    if (plotState.errorMessage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, plotState, plotNotifier),
          SizedBox(height: AppSpacing.md),
          _buildErrorState(context, plotState.errorMessage!, plotNotifier),
        ],
      );
    }

    // Empty
    if (plotState.plots.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, plotState, plotNotifier),
          SizedBox(height: AppSpacing.md),
          _buildEmptyState(context),
        ],
      );
    }

    // Get running plots or all plots
    final displayPlots = plotNotifier.hasRunningPlots
        ? plotNotifier.runningPlots
        : plotState.plots;

    // Determine if we should show "Start Plot" card
    final showStartPlot = !plotNotifier.hasRunningPlots;

    // Determine if add card should be enabled
    final isAddCardEnabled = !plotNotifier.areAllPlotsRunning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with Sort
        _buildSectionHeader(context, plotState, plotNotifier),
        SizedBox(height: AppSpacing.md),
        // Horizontal Scrollable Plot Cards
        _buildPlotCardsList(
          context,
          displayPlots,
          plotState.selectedPlotId,
          showStartPlot,
          isAddCardEnabled,
          plotNotifier,
        ),
      ],
    );
  }

  /// Section Header
  Widget _buildSectionHeader(
    BuildContext context,
    PlotState plotState,
    PlotNotifier plotNotifier,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Plots',
            style: AppTypography.headlineMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          // Sort Button
          _buildSortButton(context, plotState, plotNotifier),
        ],
      ),
    );
  }

  /// Sort Button Widget
  Widget _buildSortButton(
    BuildContext context,
    PlotState plotState,
    PlotNotifier plotNotifier,
  ) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
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
              plotState.sortOrder == PlotSortOrder.highToLow
                  ? 'High to Low'
                  : 'Low to High',
              style: AppTypography.bodySmall(context).copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Plot Cards List - Compact horizontal scroll
  Widget _buildPlotCardsList(
    BuildContext context,
    List<PlotEntity> plots,
    String? selectedPlotId,
    bool showStartPlot,
    bool isAddCardEnabled,
    PlotNotifier plotNotifier,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = ResponsiveUtils.isTablet(context);
    
    // Compact card width - Groww-inspired sizing
    final cardWidth = isTablet
        ? screenWidth * 0.32 // ~32% for tablets
        : screenWidth * 0.65; // ~65% for phones (shows partial next card)
    
    // Clamp width for consistency
    final clampedWidth = cardWidth.clamp(200.0, 280.0);
    
    // Compact height
    final cardHeight = isTablet ? 130.0 : 120.0;

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        itemCount: plots.length + (showStartPlot || isAddCardEnabled ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          // Add card at the end
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

          // Plot card
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
                // Smooth scroll to selected card
                _scrollToIndex(index, clampedWidth);
              },
            ),
          );
        },
      ),
    );
  }

  /// Smooth scroll to selected index
  void _scrollToIndex(int index, double cardWidth) {
    if (!_scrollController.hasClients) return;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final scrollPosition = index * (cardWidth + AppSpacing.md);
    final maxScroll = _scrollController.position.maxScrollExtent;
    final targetPosition = scrollPosition.clamp(0.0, maxScroll);

    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = ResponsiveUtils.isTablet(context);
    final cardWidth = (isTablet ? screenWidth * 0.32 : screenWidth * 0.65).clamp(200.0, 280.0);
    final cardHeight = isTablet ? 130.0 : 120.0;

    return AppShimmer(
      child: SizedBox(
        height: cardHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
          itemBuilder: (context, index) => SizedBox(
            width: cardWidth,
            child: ShimmerBox(height: cardHeight, radius: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, PlotNotifier notifier) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: cs.errorContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.error.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: cs.error),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Failed to load plots',
              style: AppTypography.bodyLarge(context).copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall(context).copyWith(color: cs.onErrorContainer),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton.icon(
              onPressed: () => notifier.loadPlots(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outline.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.agriculture_outlined, color: cs.onSurfaceVariant, size: 40),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No plots found',
              style: AppTypography.bodyLarge(context).copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Add your first plot to get started',
              style: AppTypography.bodySmall(context).copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
