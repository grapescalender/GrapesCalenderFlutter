import 'package:flutter/material.dart';
import '../../core/design_system/colors/app_colors.dart';
import '../../core/design_system/spacing/app_spacing.dart';
import '../../core/design_system/typography/app_typography.dart';

/// Modern Bottom Navigation Bar
/// Minimal, clean design inspired by Groww
/// Supports icons, labels, and badges
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppBottomNavItem> items;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;

  const AppBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? AppColors.darkSurface : AppColors.background),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.darkShadow : AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavItem(
                context,
                item,
                isSelected,
                isDark,
                () => onTap(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    AppBottomNavItem item,
    bool isSelected,
    bool isDark,
    VoidCallback onTap,
  ) {
    final selectedColorValue = selectedColor ?? AppColors.primary;
    final unselectedColorValue = unselectedColor ??
        (isDark ? AppColors.darkOnSurfaceVariant : AppColors.onSurfaceVariant);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? item.selectedIcon : item.icon,
                    size: 24,
                    color: isSelected ? selectedColorValue : unselectedColorValue,
                  ),
                  if (item.badge != null && item.badge! > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          item.badge! > 9 ? '9+' : '${item.badge}',
                          style: AppTypography.labelSmall(context).copyWith(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                item.label,
                style: AppTypography.labelSmall(context).copyWith(
                  color: isSelected ? selectedColorValue : unselectedColorValue,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom Navigation Item
class AppBottomNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int? badge;

  const AppBottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badge,
  });
}
