import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../domain/entities/activity_entity.dart';

/// Material 3-style activity carousel for the dashboard.
class HorizontalActivityStepper extends StatefulWidget {
  const HorizontalActivityStepper({
    required this.activities,
    required this.onStepTapped,
    required this.onViewAllActivities,
    this.selectedActivity,
    super.key,
  });

  final List<ActivityEntity> activities;
  final ValueChanged<ActivityEntity> onStepTapped;
  final VoidCallback onViewAllActivities;
  final ActivityEntity? selectedActivity;

  @override
  State<HorizontalActivityStepper> createState() =>
      _HorizontalActivityStepperState();
}

class _HorizontalActivityStepperState extends State<HorizontalActivityStepper> {
  static const _carouselWeights = <int>[5, 3, 1];

  late ActivityEntity _selected;
  late CarouselController _carouselController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedActivity ??
        (widget.activities.isNotEmpty ? widget.activities.first : null)!;
    _currentIndex = _indexFor(_selected);
    _carouselController = CarouselController(initialItem: _currentIndex)
      ..addListener(_handleCarouselScroll);
  }

  @override
  void didUpdateWidget(HorizontalActivityStepper old) {
    super.didUpdateWidget(old);
    if (widget.selectedActivity != null &&
        widget.selectedActivity != old.selectedActivity) {
      _selected = widget.selectedActivity!;
      final nextIndex = _indexFor(_selected);
      _currentIndex = nextIndex;
      if (_carouselController.hasClients) {
        _carouselController.animateToItem(
          nextIndex,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _carouselController
      ..removeListener(_handleCarouselScroll)
      ..dispose();
    super.dispose();
  }

  int _indexFor(ActivityEntity activity) {
    final index =
        widget.activities.indexWhere((item) => item.id == activity.id);
    return index < 0 ? 0 : index;
  }

  int _dayCount(ActivityEntity activity) {
    if (activity.startedAt == null) {
      return 0;
    }
    final end = activity.completedAt ?? DateTime.now();
    return end.difference(activity.startedAt!).inDays + 1;
  }

  void _handleCarouselScroll() {
    if (!_carouselController.hasClients ||
        !_carouselController.position.hasViewportDimension) {
      return;
    }

    final viewportWidth = _carouselController.position.viewportDimension;
    if (viewportWidth <= 0) {
      return;
    }

    final totalWeight =
        _carouselWeights.reduce((value, weight) => value + weight);
    final itemStride = viewportWidth * _carouselWeights.first / totalWeight;
    final nextIndex = (_carouselController.offset / itemStride)
        .round()
        .clamp(0, widget.activities.length - 1);

    if (nextIndex != _currentIndex && mounted) {
      setState(() {
        _currentIndex = nextIndex;
        _selected = widget.activities[nextIndex];
      });
    }
  }

  void _openItem(int index) {
    _carouselController.animateToItem(
      index,
      curve: Curves.easeOutCubic,
    );
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
        Semantics(
          label: 'Activities carousel',
          hint:
              'Scroll horizontally to browse activities. Each activity becomes the large card in turn.',
          child: SizedBox(
            height: 124,
            child: CarouselView.weightedBuilder(
              controller: _carouselController,
              flexWeights: _carouselWeights,
              itemCount: widget.activities.length,
              itemSnapping: true,
              shrinkExtent: 40,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
              itemBuilder: (context, index) {
                final activity = widget.activities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  child: _ActivityCarouselCard(
                    activity: activity,
                    stepNumber: index + 1,
                    totalSteps: widget.activities.length,
                    selected: index == _currentIndex,
                    dayCount: _dayCount(activity),
                    onTap: () {
                      if (index == _currentIndex) {
                        widget.onStepTapped(activity);
                      } else {
                        _openItem(index);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.activities.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            label:
                'Showing activity ${_currentIndex + 1} of ${widget.activities.length}',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var index = 0; index < widget.activities.length; index++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: index == _currentIndex ? 22 : 7,
                      height: 7,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        color: index == _currentIndex
                            ? cs.primary
                            : cs.outlineVariant,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ActivityCarouselCard extends StatelessWidget {
  const _ActivityCarouselCard({
    required this.activity,
    required this.stepNumber,
    required this.totalSteps,
    required this.selected,
    required this.dayCount,
    required this.onTap,
  });

  final ActivityEntity activity;
  final int stepNumber;
  final int totalSteps;
  final bool selected;
  final int dayCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final colors = _ActivityCarouselColors.forActivity(context, activity);

    return Semantics(
      button: true,
      selected: selected,
      label:
          '${activity.type.displayName}, ${_statusLabel.toLowerCase()}, item $stepNumber of $totalSteps',
      hint: 'Opens activity details',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: selected ? 2 : 0,
        clipBehavior: Clip.antiAlias,
        color: selected ? colors.container : cs.surfaceContainerHigh,
        surfaceTintColor: cs.surfaceTint,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: BorderSide(
            color: selected
                ? colors.accent.withValues(alpha: 0.46)
                : cs.outlineVariant,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 120;
              final icon = Container(
                width: compact ? 32 : 34,
                height: compact ? 32 : 34,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  activity.type.icon,
                  color: colors.accent,
                  size: compact ? 18 : 20,
                ),
              );

              if (compact) {
                return Center(child: icon);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.smMd,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        icon,
                        if (selected) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _StatusPill(activity: activity),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                activity.type.displayName,
                                style:
                                    AppTypography.titleMedium(context).copyWith(
                                  color: cs.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              _subtitle,
                              style: AppTypography.bodyMedium(context).copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: stepNumber / totalSteps,
                              minHeight: 6,
                              backgroundColor: cs.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colors.accent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '$stepNumber/$totalSteps',
                          style: AppTypography.labelLarge(context).copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String get _subtitle {
    if (activity.isActive) {
      return dayCount > 0 ? 'In progress for $dayCount days' : 'In progress';
    }
    if (activity.isCompleted) {
      return dayCount > 0
          ? 'Completed activity • $dayCount days'
          : 'Completed activity';
    }
    return 'Upcoming activity stage';
  }

  String get _statusLabel {
    if (activity.isActive) return 'Current';
    if (activity.isCompleted) return 'Done';
    return 'Upcoming';
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.activity});

  final ActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    final colors = _ActivityCarouselColors.forActivity(context, activity);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 74),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, color: colors.accent, size: 14),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                _label,
                style: AppTypography.labelLarge(context).copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    if (activity.isActive) return Icons.radio_button_checked_rounded;
    if (activity.isCompleted) return Icons.check_circle_rounded;
    return Icons.schedule_rounded;
  }

  String get _label {
    if (activity.isActive) return 'Current';
    if (activity.isCompleted) return 'Done';
    return 'Upcoming';
  }
}

class _ActivityCarouselColors {
  const _ActivityCarouselColors({
    required this.accent,
    required this.container,
  });

  final Color accent;
  final Color container;

  static _ActivityCarouselColors forActivity(
    BuildContext context,
    ActivityEntity activity,
  ) {
    final cs = Theme.of(context).colorScheme;
    if (activity.isActive) {
      return _ActivityCarouselColors(
        accent: cs.primary,
        container: cs.primaryContainer.withValues(alpha: 0.46),
      );
    }
    if (activity.isCompleted) {
      return _ActivityCarouselColors(
        accent: Colors.green.shade700,
        container: Colors.green.shade50,
      );
    }
    return _ActivityCarouselColors(
      accent: cs.onSurfaceVariant,
      container: cs.surfaceContainerHighest,
    );
  }
}
