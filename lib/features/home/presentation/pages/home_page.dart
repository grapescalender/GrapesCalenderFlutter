import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/theme/app_branding.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../shared/responsive/responsive_utils.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../activity/presentation/widgets/activity_section.dart';
import '../../../schedule/presentation/widgets/schedule_section.dart';
import '../widgets/plots_section.dart';
import '../widgets/market_insight_section.dart';

/// Home Page
/// Main dashboard with header, plots, schedule, and activity sections
/// Fully responsive for small phones, large phones, and tablets
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: LayoutBuilder(
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(BuildContext context, BoxConstraints constraints) {
    final cs = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = ResponsiveUtils.isTablet(context);
    final isSmallPhone = screenWidth < 360;

    // Responsive spacing
    final sectionSpacing = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: AppSpacing.lg,
      tablet: AppSpacing.xl,
    );

    final bottomPadding = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: AppSpacing.xl,
      tablet: AppSpacing.xxl,
    );

    // compute horizontal padding once and reuse so sections align
      final horizontalPadding = ResponsiveUtils.responsiveValue(
        context: context,
        mobile: isSmallPhone ? AppSpacing.md : AppSpacing.screenHorizontal,
        tablet: AppSpacing.xl,
      );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(context, isTablet, isSmallPhone, horizontalPadding),
          SizedBox(height: sectionSpacing),
          
          // Plots Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: _buildPlotsSection(context),
          ),
          SizedBox(height: sectionSpacing),
          
          // Schedule Section
          const ScheduleSection(),
          SizedBox(height: sectionSpacing),
          // Market Intelligence (flagship)
          const MarketInsightSection(),
          SizedBox(height: sectionSpacing),
          
          // Activity Section
          const ActivitySection(),
          SizedBox(height: bottomPadding), // Extra space at bottom
        ],
      ),
    );
  }

  /// Header Section - Responsive
  Widget _buildHeader(
    BuildContext context,
    bool isTablet,
    bool isSmallPhone,
    double horizontalPadding,
  ) {
    final cs = Theme.of(context).colorScheme;
    final branding = Theme.of(context).extension<AppBranding>()!;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive padding
    final horizontalPadding = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: isSmallPhone ? AppSpacing.md : AppSpacing.screenHorizontal,
      tablet: AppSpacing.xl,
    );

    final verticalPadding = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: AppSpacing.md,
      tablet: AppSpacing.lg,
    );

    // Icon sizes
    final iconSize = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: 18.0,
      tablet: 22.0,
    );

    final iconContainerSize = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: 38.0,
      tablet: 46.0,
    );

    // Compact header: single top row with brand, title and actions.
    // Removed search row per request and removed corner rounding.
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        gradient: branding.headerGradient,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // single top row: menu + brand + title + actions
          Row(
            children: [
              // Menu button (top-left) - opens app drawer if available
              _buildHeaderIconButton(
                context,
                icon: Icons.menu,
                iconSize: iconSize,
                containerSize: iconContainerSize,
                onPressed: () => Scaffold.maybeOf(context)?.openDrawer(),
              ),
              const SizedBox(width: 10),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: cs.shadow.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0,4))],
                ),
                child: const Icon(Icons.agriculture_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Grapes', style: AppTypography.titleLarge(context).copyWith(color: cs.onPrimary, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text('Manage plots, schedules & insights', style: AppTypography.bodySmall(context).copyWith(color: cs.onPrimary.withValues(alpha: 0.92), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              CircleAvatar(
                radius: ResponsiveUtils.responsiveValue(context: context, mobile: 18, tablet: 22),
                backgroundColor: cs.onPrimary.withValues(alpha: 0.14),
                child: Text('S', style: AppTypography.bodyLarge(context).copyWith(color: cs.onPrimary, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildHeaderIconButton(
                context,
                icon: Icons.notifications_outlined,
                iconSize: iconSize,
                containerSize: iconContainerSize,
                onPressed: () {},
              ),
            ],
          ),

          // Removed inline plot-name UI per request; plots selector is in the hero section now.
        ],
      ),
    );
  }

  /// Header Icon Button - Responsive
  Widget _buildHeaderIconButton(
    BuildContext context, {
    required IconData icon,
    required double iconSize,
    required double containerSize,
    required VoidCallback onPressed,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: cs.onPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.responsiveValue(
            context: context,
            mobile: AppSpacing.radiusSm,
            tablet: AppSpacing.radiusMd,
          ),
        ),
      ),
      child: IconButton(
        icon: Icon(icon, size: iconSize),
        color: cs.onPrimary,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Plots Section - Horizontal Scrollable
  Widget _buildPlotsSection(BuildContext context) => PlotsSection();
}
