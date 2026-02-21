import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/responsive/responsive_utils.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../activity/presentation/widgets/activity_section.dart';
import '../../../schedule/presentation/widgets/schedule_section.dart';
import '../widgets/plots_section.dart';

/// Home Page
/// Main dashboard with header, plots, schedule, and activity sections
/// Fully responsive for small phones, large phones, and tablets
class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _buildBody(context, constraints);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, BoxConstraints constraints) {
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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          _buildHeader(context, isTablet, isSmallPhone),
          SizedBox(height: sectionSpacing),
          
          // Plots Section
          _buildPlotsSection(context),
          SizedBox(height: sectionSpacing),
          
          // Schedule Section
          const ScheduleSection(),
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
  ) {
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

    // Responsive icon size
    final iconSize = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: 20.0,
      tablet: 24.0,
    );

    // Responsive icon container size
    final iconContainerSize = ResponsiveUtils.responsiveValue(
      context: context,
      mobile: 40.0,
      tablet: 48.0,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting and Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning',
                      style: AppTypography.headlineSmall(context).copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.responsiveValue(
                        context: context,
                        mobile: AppSpacing.xs,
                        tablet: AppSpacing.sm,
                      ),
                    ),
                    Text(
                      'John Doe', // Placeholder
                      style: AppTypography.displaySmall(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Action Buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeaderIconButton(
                    context,
                    icon: Icons.notifications_outlined,
                    iconSize: iconSize,
                    containerSize: iconContainerSize,
                    onPressed: () {
                      // TODO: Navigate to notifications
                    },
                  ),
                  SizedBox(
                    width: ResponsiveUtils.responsiveValue(
                      context: context,
                      mobile: AppSpacing.sm,
                      tablet: AppSpacing.md,
                    ),
                  ),
                  _buildHeaderIconButton(
                    context,
                    icon: Icons.search_outlined,
                    iconSize: iconSize,
                    containerSize: iconContainerSize,
                    onPressed: () {
                      // TODO: Open search
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: ResponsiveUtils.responsiveValue(
              context: context,
              mobile: AppSpacing.md,
              tablet: AppSpacing.lg,
            ),
          ),
          // Farm Info Card
          AppCard.defaultStyle(
            child: Row(
              children: [
                // Farm Icon
                Container(
                  width: ResponsiveUtils.responsiveValue(
                    context: context,
                    mobile: 48.0,
                    tablet: 56.0,
                  ),
                  height: ResponsiveUtils.responsiveValue(
                    context: context,
                    mobile: 48.0,
                    tablet: 56.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.responsiveValue(
                        context: context,
                        mobile: AppSpacing.radiusMd,
                        tablet: AppSpacing.radiusLg,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.agriculture,
                    color: AppColors.primary,
                    size: ResponsiveUtils.responsiveValue(
                      context: context,
                      mobile: 24.0,
                      tablet: 28.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.responsiveValue(
                    context: context,
                    mobile: AppSpacing.md,
                    tablet: AppSpacing.lg,
                  ),
                ),
                // Farm Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Green Valley Farm',
                        style: AppTypography.headlineSmall(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: ResponsiveUtils.responsiveValue(
                          context: context,
                          mobile: AppSpacing.xs,
                          tablet: AppSpacing.sm,
                        ),
                      ),
                      Text(
                        '5 Active Plots',
                        style: AppTypography.bodySmall(context).copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                Icon(
                  Icons.chevron_right,
                  color: AppColors.onSurfaceVariant,
                  size: ResponsiveUtils.responsiveValue(
                    context: context,
                    mobile: 20.0,
                    tablet: 24.0,
                  ),
                ),
              ],
            ),
          ),
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
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
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
        color: AppColors.onSurface,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Plots Section - Horizontal Scrollable
  Widget _buildPlotsSection(BuildContext context) {
    return const PlotsSection();
  }
}
