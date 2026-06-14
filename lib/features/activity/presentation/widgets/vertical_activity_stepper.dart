import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../domain/entities/activity_entity.dart';
import 'activity_card.dart';
import 'step_indicator.dart';

/// Vertical Activity Stepper Widget
/// Displays activities vertically with timeline on the left side
/// Perfect for "View All Activities" page
class VerticalActivityStepper extends StatefulWidget {
  final List<ActivityEntity> activities;
  final Function(ActivityEntity) onActivityTapped;
  final double lineHeight;

  const VerticalActivityStepper({
    Key? key,
    required this.activities,
    required this.onActivityTapped,
    this.lineHeight = 2.0,
  }) : super(key: key);

  @override
  State<VerticalActivityStepper> createState() =>
      _VerticalActivityStepperState();
}

class _VerticalActivityStepperState extends State<VerticalActivityStepper> {
  late ActivityEntity? selectedActivity;

  @override
  void initState() {
    super.initState();
    selectedActivity = null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activities.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Text('No activities found'),
        ),
      );
    }

    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        children: List.generate(
          widget.activities.length,
          (index) {
            final activity = widget.activities[index];
            final isLast = index == widget.activities.length - 1;
            final stepState = _getStepState(activity);
            final isClickable = stepState != ActivityStepState.upcoming;
            final dayCount = _calculateDayCount(activity);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Timeline (indicator + line)
                Column(
                  children: [
                    // Step Indicator
                    StepIndicator(
                      state: stepState,
                      stepNumber: index + 1,
                      icon: activity.type.icon,
                      isLast: isLast,
                      isClickable: isClickable,
                      size: 44,
                    ),

                    // Vertical connector line (if not last)
                    if (!isLast)
                      Container(
                        width: widget.lineHeight,
                        height: 60,
                        color: stepState == ActivityStepState.completed
                            ? cs.secondary
                            : cs.outlineVariant,
                      ),
                  ],
                ),

                SizedBox(width: AppSpacing.md),

                // Right: Activity Card
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: isClickable
                            ? () {
                                setState(() {
                                  selectedActivity = selectedActivity?.id == activity.id
                                      ? null
                                      : activity;
                                });
                                widget.onActivityTapped(activity);
                              }
                            : null,
                        child: OpacityAnimator(
                          opacity: isClickable ? 1.0 : 0.6,
                          child: ActivityCard(
                            activity: activity,
                            isSelected: selectedActivity?.id == activity.id,
                            isClickable: isClickable,
                            dayCount: dayCount,
                            startDay: 1,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Get step state based on activity status
  ActivityStepState _getStepState(ActivityEntity activity) {
    if (activity.isCompleted) return ActivityStepState.completed;
    if (activity.isActive) return ActivityStepState.current;
    return ActivityStepState.upcoming;
  }

  /// Calculate day count for activity
  int _calculateDayCount(ActivityEntity activity) {
    if (activity.startedAt == null) return 0;
    
    final endDate = activity.completedAt ?? DateTime.now();
    return endDate.difference(activity.startedAt!).inDays + 1;
  }
}

/// Opacity Animator Widget
/// Helper widget for smooth opacity transitions
class OpacityAnimator extends StatelessWidget {
  final double opacity;
  final Widget child;

  const OpacityAnimator({
    Key? key,
    required this.opacity,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        ignoring: opacity < 1.0,
        child: child,
      ),
    );
  }
}
