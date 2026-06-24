import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/entities/activity_entity.dart';
import 'activity_item.dart';

/// Activity Stepper Widget
/// Vertical stepper/timeline showing:
/// - Last 2 completed activities
/// - 1 current activity
/// - 1 next upcoming activity
class ActivityStepper extends StatelessWidget {
  const ActivityStepper({
    Key? key,
    required this.activities,
    this.onActivityTap,
    this.onViewAll,
  }) : super(key: key);
  final List<ActivityEntity> activities;
  final ValueChanged<ActivityEntity>? onActivityTap;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Compute visible activities
    final visibleActivities = _computeVisibleActivities(activities);
    final hasMore = activities.length > visibleActivities.length;

    if (visibleActivities.isEmpty) {
      return AppCard.defaultStyle(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Icon(
                  Icons.timeline_outlined,
                  color: cs.onSurfaceVariant,
                  size: 32,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No activities found',
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AppCard.defaultStyle(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Activity Items
          ...visibleActivities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            final isLast = index == visibleActivities.length - 1 && !hasMore;

            return ActivityItem(
              key: ValueKey('activity_${activity.id}'),
              activity: activity,
              isCompleted: activity.isCompleted,
              isCurrent: activity.isActive,
              isUpcoming: activity.isPending,
              showConnector: !isLast,
              onTap: (activity.isCompleted || activity.isActive)
                  ? () => onActivityTap?.call(activity)
                  : null,
            );
          }),

          // View All Activities Row
          if (hasMore) _buildViewAllRow(context),
        ],
      ),
    );
  }

  /// Compute visible activities:
  /// - Last 2 completed
  /// - 1 current
  /// - 1 next upcoming
  List<ActivityEntity> _computeVisibleActivities(List<ActivityEntity> all) {
    if (all.isEmpty) return [];

    // Sort by order
    final orderedTypes = ActivityType.orderedTypes;
    final sorted = <ActivityEntity>[];

    for (final type in orderedTypes) {
      try {
        final activity = all.firstWhere((a) => a.type == type);
        sorted.add(activity);
      } catch (e) {
        // Activity type not found, skip
      }
    }

    if (sorted.isEmpty) return all.take(4).toList(); // Fallback

    // Get completed activities
    final completed = sorted.where((a) => a.isCompleted).toList();
    final last2Completed = completed.length >= 2
        ? completed.sublist(completed.length - 2)
        : completed;

    // Get current activity
    ActivityEntity? current;
    try {
      current = sorted.firstWhere((a) => a.isActive);
    } catch (e) {
      try {
        current = sorted.firstWhere((a) => a.isPending);
      } catch (e) {
        current = sorted.first;
      }
    }

    // Get next upcoming activity
    ActivityEntity? nextUpcoming;
    final currentIndex = orderedTypes.indexOf(current.type);
    if (currentIndex >= 0 && currentIndex < orderedTypes.length - 1) {
      final nextType = orderedTypes[currentIndex + 1];
      try {
        final next = sorted.firstWhere((a) => a.type == nextType);
        if (next.isPending) {
          nextUpcoming = next;
        }
      } catch (e) {
        // Next activity not found
      }
    }

    // Combine: last 2 completed + current + next upcoming
    final visible = <ActivityEntity>[];
    visible.addAll(last2Completed);
    if (!visible.contains(current)) {
      visible.add(current);
    }
    if (nextUpcoming != null && !visible.contains(nextUpcoming)) {
      visible.add(nextUpcoming);
    }

    // Sort by order again
    visible.sort((a, b) {
      final aIndex = orderedTypes.indexOf(a.type);
      final bIndex = orderedTypes.indexOf(b.type);
      return aIndex.compareTo(bIndex);
    });

    return visible;
  }

  /// View All Activities Row
  Widget _buildViewAllRow(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onViewAll,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.xs,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All Activities',
                style: AppTypography.body(context).copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
