import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../domain/entities/activity_entity.dart';
import 'activity_card.dart';
import 'step_indicator.dart';

/// Vertical Activity Stepper — used on ViewAllActivitiesPage
class VerticalActivityStepper extends StatefulWidget {
  const VerticalActivityStepper({
    Key? key,
    required this.activities,
    required this.onActivityTapped,
    this.lineHeight = 2.0,
  }) : super(key: key);

  final List<ActivityEntity> activities;
  final Function(ActivityEntity) onActivityTapped;
  final double lineHeight;

  @override
  State<VerticalActivityStepper> createState() =>
      _VerticalActivityStepperState();
}

class _VerticalActivityStepperState extends State<VerticalActivityStepper> {
  ActivityEntity? _selected;

  ActivityStepState _stepState(ActivityEntity a) {
    if (a.isCompleted) return ActivityStepState.completed;
    if (a.isActive) return ActivityStepState.current;
    return ActivityStepState.upcoming;
  }

  int _dayCount(ActivityEntity a) {
    if (a.startedAt == null) return 0;
    return (a.completedAt ?? DateTime.now())
            .difference(a.startedAt!)
            .inDays +
        1;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activities.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Text('No activities found'),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: AppSpacing.md),
      child: Column(
        children: List.generate(widget.activities.length, (idx) {
          final activity = widget.activities[idx];
          final isLast = idx == widget.activities.length - 1;
          final state = _stepState(activity);
          final isClickable = state != ActivityStepState.upcoming;
          final isSelected = _selected?.id == activity.id;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Left timeline column ─────────────────────────────────
              Column(
                children: [
                  StepIndicator(
                    state: state,
                    stepNumber: idx + 1,
                    icon: activity.type.icon,
                    isLast: isLast,
                    isClickable: isClickable,
                    size: 42,
                  ),
                  if (!isLast)
                    Container(
                      width: widget.lineHeight,
                      height: 56,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: state == ActivityStepState.completed
                            ? AppColors.success
                            : AppColors.outline,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: AppSpacing.smMd),

              // ── Right card ───────────────────────────────────────────
              Expanded(
                child: Column(
                  children: [
                    AnimatedOpacity(
                      opacity: isClickable ? 1.0 : 0.55,
                      duration: const Duration(milliseconds: 250),
                      child: IgnorePointer(
                        ignoring: !isClickable,
                        child: ActivityCard(
                          activity: activity,
                          isSelected: isSelected,
                          isClickable: isClickable,
                          dayCount: _dayCount(activity),
                          startDay: 1,
                          onTap: () {
                            setState(() {
                              _selected = isSelected ? null : activity;
                            });
                            widget.onActivityTapped(activity);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: isLast ? 0 : AppSpacing.smMd),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
