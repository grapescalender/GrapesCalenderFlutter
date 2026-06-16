import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';

/// Schedule Header Widget
/// Clean header with title on left and Add Schedule icon button on right
/// Minimal, inline design
class ScheduleHeader extends StatelessWidget {

  const ScheduleHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.onAddTap,
  }) : super(key: key);
  final String title;
  final String? subtitle;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.headlineMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall(context).copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Right: Add Schedule Icon Button (+)
          if (onAddTap != null)
            IconButton(
              icon: const Icon(Icons.add),
              iconSize: 24,
              color: cs.primary,
              onPressed: onAddTap,
              tooltip: 'Add Schedule',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
        ],
      ),
    );
  }
}
