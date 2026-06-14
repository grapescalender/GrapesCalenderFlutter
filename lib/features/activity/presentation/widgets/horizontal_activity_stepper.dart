import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/activity_entity.dart';
import 'activity_card.dart';
import 'step_indicator.dart';

/// Horizontal Activity Stepper Widget
/// Shows activities in a horizontal layout at the top of home screen
/// Features:
/// - Circular step indicators with progress line
/// - Tappable completed and current steps
/// - Selected activity summary card
class HorizontalActivityStepper extends StatefulWidget {
  final List<ActivityEntity> activities;
  final Function(ActivityEntity) onStepTapped;
  final VoidCallback onViewAllActivities;
  final ActivityEntity? selectedActivity;

  const HorizontalActivityStepper({
    Key? key,
    required this.activities,
    required this.onStepTapped,
    required this.onViewAllActivities,
    this.selectedActivity,
  }) : super(key: key);

  @override
  State<HorizontalActivityStepper> createState() =>
      _HorizontalActivityStepperState();
}

class _HorizontalActivityStepperState extends State<HorizontalActivityStepper> {
  late ActivityEntity selectedActivity;

  @override
  void initState() {
    super.initState();
    selectedActivity = widget.selectedActivity ??
        (widget.activities.isNotEmpty ? widget.activities.first : null) as ActivityEntity;
  }

  @override
  void didUpdateWidget(HorizontalActivityStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedActivity != oldWidget.selectedActivity &&
        widget.selectedActivity != null) {
      selectedActivity = widget.selectedActivity!;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activities.isEmpty) {
      return const SizedBox.shrink();
    }

    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal Stepper
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Progress stepper with indicators and line
              _buildProgressStepper(context),
              SizedBox(height: AppSpacing.lg),

              // View all activities button
              SizedBox(
                width: double.infinity,
                height: 40,
                child: FilledButton.tonal(
                  onPressed: widget.onViewAllActivities,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('View All Activities'),
                      SizedBox(width: AppSpacing.sm),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),

        // Selected Activity Summary Card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: ActivityCard(
            activity: selectedActivity,
            isSelected: true,
            isClickable: false,
            dayCount: _calculateDayCount(),
            startDay: 1,
          ),
        ),
      ],
    );
  }

  /// Build horizontal progress stepper
  Widget _buildProgressStepper(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final totalSteps = widget.activities.length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            totalSteps * 2 - 1,
            (index) {
              // Even indices are step indicators, odd indices are connector lines
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                final activity = widget.activities[stepIndex];
                final isSelected = selectedActivity.id == activity.id;
                final stepState = _getStepState(activity);
                final isClickable = stepState != ActivityStepState.upcoming;

                return GestureDetector(
                  onTap: isClickable
                      ? () => _onStepTapped(activity)
                      : null,
                  child: StepIndicator(
                    state: stepState,
                    stepNumber: stepIndex + 1,
                    icon: activity.type.icon,
                    isLast: stepIndex == totalSteps - 1,
                    isClickable: isClickable,
                    size: 36,
                  ),
                );
              } else {
                // Connector line
                final stepIndex = index ~/ 2;
                final activity = widget.activities[stepIndex];
                final nextActivity = widget.activities[stepIndex + 1];
                
                final isFilled = _getStepState(activity) == ActivityStepState.completed ||
                    (_getStepState(activity) == ActivityStepState.current &&
                        _getStepState(nextActivity) != ActivityStepState.upcoming);

                return Container(
                  width: 30,
                  height: 3,
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: isFilled ? cs.primary : cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }
            },
          ),
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

  /// Handle step tapped
  void _onStepTapped(ActivityEntity activity) {
    setState(() {
      selectedActivity = activity;
    });
    widget.onStepTapped(activity);
  }

  /// Calculate day count for the selected activity
  int _calculateDayCount() {
    if (selectedActivity.startedAt == null) return 0;
    
    final endDate = selectedActivity.completedAt ?? DateTime.now();
    return endDate.difference(selectedActivity.startedAt!).inDays + 1;
  }
}
