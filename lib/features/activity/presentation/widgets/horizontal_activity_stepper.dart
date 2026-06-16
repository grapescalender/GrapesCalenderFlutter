import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/activity_entity.dart';
import 'activity_card.dart';
import 'step_indicator.dart';

/// Redesigned Horizontal Activity Stepper
///
/// Layout:
///   ┌──────────────────────────────────────────────┐
///   │  [●]──[●]──[◉]──[○]──[○]   View All →        │
///   │  Cut  Floor Form Harv Dip                     │
///   └──────────────────────────────────────────────┘
///   └── Selected ActivityCard ──────────────────────┘
class HorizontalActivityStepper extends StatefulWidget {
  const HorizontalActivityStepper({
    Key? key,
    required this.activities,
    required this.onStepTapped,
    required this.onViewAllActivities,
    this.selectedActivity,
  }) : super(key: key);

  final List<ActivityEntity> activities;
  final Function(ActivityEntity) onStepTapped;
  final VoidCallback onViewAllActivities;
  final ActivityEntity? selectedActivity;

  @override
  State<HorizontalActivityStepper> createState() =>
      _HorizontalActivityStepperState();
}

class _HorizontalActivityStepperState
    extends State<HorizontalActivityStepper> {
  late ActivityEntity _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedActivity ??
        (widget.activities.isNotEmpty ? widget.activities.first : null)!;
  }

  @override
  void didUpdateWidget(HorizontalActivityStepper old) {
    super.didUpdateWidget(old);
    if (widget.selectedActivity != null &&
        widget.selectedActivity != old.selectedActivity) {
      _selected = widget.selectedActivity!;
    }
  }

  ActivityStepState _stepState(ActivityEntity a) {
    if (a.isCompleted) return ActivityStepState.completed;
    if (a.isActive) return ActivityStepState.current;
    return ActivityStepState.upcoming;
  }

  int _dayCount() {
    if (_selected.startedAt == null) return 0;
    final end = _selected.completedAt ?? DateTime.now();
    return end.difference(_selected.startedAt!).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Stepper rail ────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.md),
          child: Column(
            children: [
              // Progress track row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: _buildTrack(context),
              ),

              const SizedBox(height: AppSpacing.smMd),
              const Divider(height: 1, color: AppColors.outline),
              const SizedBox(height: AppSpacing.smMd),

              // "View all" row
              GestureDetector(
                onTap: widget.onViewAllActivities,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View All Activities',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_rounded,
                        size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.smMd),

        // ── Selected activity card ───────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal),
          child: ActivityCard(
            activity: _selected,
            isSelected: true,
            isClickable: false,
            dayCount: _dayCount(),
            startDay: 1,
          ),
        ),
      ],
    );
  }

  /// Builds the horizontal step indicators with connector lines + labels
  Widget _buildTrack(BuildContext context) {
    final total = widget.activities.length;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(total * 2 - 1, (i) {
        // Odd indices = connector lines
        if (i.isOdd) {
          final stepIdx = i ~/ 2;
          final a = widget.activities[stepIdx];
          final filled = _stepState(a) == ActivityStepState.completed;
          return _Connector(filled: filled);
        }

        // Even indices = step + label
        final stepIdx = i ~/ 2;
        final activity = widget.activities[stepIdx];
        final state = _stepState(activity);
        final isClickable = state != ActivityStepState.upcoming;
        final isSelectedStep = _selected.id == activity.id;

        return _StepWithLabel(
          activity: activity,
          state: state,
          stepNumber: stepIdx + 1,
          isClickable: isClickable,
          isSelected: isSelectedStep,
          onTap: isClickable
              ? () {
                  setState(() => _selected = activity);
                  widget.onStepTapped(activity);
                }
              : null,
        );
      }),
    );
  }
}

// ── Connector line ────────────────────────────────────────────────────────
class _Connector extends StatelessWidget {
  const _Connector({required this.filled});
  final bool filled;

  @override
  Widget build(BuildContext context) => Container(
        width: 28,
        height: 2,
        margin: const EdgeInsets.only(top: 18, left: 2, right: 2),
        decoration: BoxDecoration(
          color: filled ? AppColors.success : AppColors.outline,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}

// ── Step + label column ───────────────────────────────────────────────────
class _StepWithLabel extends StatelessWidget {
  const _StepWithLabel({
    required this.activity,
    required this.state,
    required this.stepNumber,
    required this.isClickable,
    required this.isSelected,
    this.onTap,
  });

  final ActivityEntity activity;
  final ActivityStepState state;
  final int stepNumber;
  final bool isClickable;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 58,
        child: Column(
          children: [
            // Glow ring for selected active step
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: isSelected && state == ActivityStepState.current
                  ? const EdgeInsets.all(3)
                  : EdgeInsets.zero,
              decoration: isSelected && state == ActivityStepState.current
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    )
                  : null,
              child: StepIndicator(
                state: state,
                stepNumber: stepNumber,
                icon: activity.type.icon,
                isClickable: isClickable,
                size: 36,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              activity.type.displayName,
              style: AppTypography.bodySmall(context).copyWith(
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
