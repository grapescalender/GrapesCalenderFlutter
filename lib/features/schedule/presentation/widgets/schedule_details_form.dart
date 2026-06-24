import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../activity/domain/entities/activity_entity.dart';
import '../../../home/domain/entities/plot_entity.dart';
import '../../domain/entities/schedule_entity.dart';

class ScheduleDetailsForm extends StatelessWidget {
  const ScheduleDetailsForm({
    super.key,
    required this.plots,
    required this.activities,
    required this.selectedPlotId,
    required this.selectedType,
    required this.selectedActivityType,
    required this.scheduleDate,
    required this.dueDate,
    required this.onPlotChanged,
    required this.onTypeChanged,
    required this.onActivityChanged,
    required this.onScheduleDateChanged,
    required this.onScheduleDateTap,
    required this.onDueDateTap,
    required this.onTimeTap,
  });

  final List<PlotEntity> plots;
  final List<ActivityEntity> activities;
  final String selectedPlotId;
  final ScheduleType selectedType;
  final ActivityType selectedActivityType;
  final DateTime scheduleDate;
  final DateTime dueDate;
  final ValueChanged<String> onPlotChanged;
  final ValueChanged<ScheduleType> onTypeChanged;
  final ValueChanged<ActivityType> onActivityChanged;
  final ValueChanged<DateTime> onScheduleDateChanged;
  final VoidCallback onScheduleDateTap;
  final VoidCallback onDueDateTap;
  final VoidCallback onTimeTap;

  @override
  Widget build(BuildContext context) {
    final selectedPlot = plots.firstWhere(
      (plot) => plot.id == selectedPlotId,
      orElse: () => plots.first,
    );

    return _SectionCard(
      title: 'Schedule Details',
      icon: Icons.event_note_outlined,
      child: Column(
        children: [
          _PickerTile(
            label: 'Plot',
            value: selectedPlot.name,
            meta: _plotMeta(selectedPlot),
            icon: Icons.agriculture_rounded,
            dense: true,
            onTap: () => _openPlotSelector(context),
          ),
          const SizedBox(height: AppSpacing.smMd),
          _TypeSelector(
            selectedType: selectedType,
            onChanged: onTypeChanged,
          ),
          const SizedBox(height: AppSpacing.smMd),
          _PickerTile(
            label: 'Activity Stage',
            value: '${selectedActivityType.displayName} Stage',
            meta: _stageMeta(selectedActivityType),
            icon: Icons.timeline_rounded,
            onTap: () => _openStageSelector(context),
          ),
          const SizedBox(height: AppSpacing.smMd),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              final children = [
                _DateActionChip(
                  label: 'Schedule',
                  value: DateFormat('d MMM').format(scheduleDate),
                  icon: Icons.event_available_outlined,
                  onTap: onScheduleDateTap,
                ),
                _DateActionChip(
                  label: 'Time',
                  value: DateFormat('h:mm a').format(scheduleDate),
                  icon: Icons.schedule_rounded,
                  onTap: onTimeTap,
                ),
                _DateActionChip(
                  label: 'Due',
                  value: DateFormat('d MMM').format(dueDate),
                  icon: Icons.flag_outlined,
                  onTap: onDueDateTap,
                ),
              ];

              if (compact) {
                return Column(
                  children: [
                    for (var index = 0; index < children.length; index++) ...[
                      children[index],
                      if (index != children.length - 1)
                        const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  for (var index = 0; index < children.length; index++) ...[
                    Expanded(child: children[index]),
                    if (index != children.length - 1)
                      const SizedBox(width: AppSpacing.sm),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _plotMeta(PlotEntity plot) {
    final details = <String>[
      plot.cropType,
      '${plot.area} ha',
      if (plot.hasPruningDate) 'Day ${plot.daysSincePruning}',
    ];
    return details.join('  ·  ');
  }

  String _stageMeta(ActivityType type) {
    final activity = _activityFor(type);
    if (activity == null) return 'Tap to change growth stage';
    if (activity.isActive) return 'Current stage';
    if (activity.isCompleted) return _stageDateRange(activity);
    return 'Upcoming stage';
  }

  ActivityEntity? _activityFor(ActivityType type) {
    for (final activity in activities) {
      if (activity.type == type) return activity;
    }
    return null;
  }

  int _currentStageIndex() {
    final orderedTypes = ActivityType.orderedTypes;
    for (final activity in activities) {
      if (activity.isActive) return orderedTypes.indexOf(activity.type);
    }
    for (final activity in activities) {
      if (activity.isPending) return orderedTypes.indexOf(activity.type);
    }
    return orderedTypes.indexOf(selectedActivityType);
  }

  bool _dateInsideActivity(ActivityEntity activity) {
    final start = activity.startedAt;
    if (start == null) return true;
    final end = activity.completedAt ?? DateTime.now();
    final selectedDate = DateUtils.dateOnly(scheduleDate);
    return !selectedDate.isBefore(DateUtils.dateOnly(start)) &&
        !selectedDate.isAfter(DateUtils.dateOnly(end));
  }

  DateTime _adjustedDateFor(ActivityEntity activity) {
    final start = activity.startedAt;
    if (start == null) return scheduleDate;
    final end = activity.completedAt ?? DateTime.now();
    final selectedDate = DateUtils.dateOnly(scheduleDate);
    if (selectedDate.isBefore(DateUtils.dateOnly(start))) return start;
    if (selectedDate.isAfter(DateUtils.dateOnly(end))) return end;
    return scheduleDate;
  }

  String _stageDateRange(ActivityEntity activity) {
    final start = activity.startedAt;
    if (start == null) return 'Stage date not available';
    final end = activity.completedAt ?? DateTime.now();
    final formatter = DateFormat('d MMM');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  void _openPlotSelector(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DashboardStyle.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      builder: (context) => SafeArea(
        child: _SelectorSheet(
          title: 'Select Plot',
          subtitle: 'Tap a plot to use for this schedule',
          icon: Icons.agriculture_rounded,
          children: [
            for (final plot in plots)
              _PlotOptionTile(
                plot: plot,
                selected: plot.id == selectedPlotId,
                onTap: () {
                  onPlotChanged(plot.id);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  void _openStageSelector(BuildContext context) {
    final currentIndex = _currentStageIndex();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DashboardStyle.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      builder: (context) => SafeArea(
        child: _SelectorSheet(
          title: 'Select Activity Stage',
          subtitle: 'Choose the current grape stage for this schedule',
          icon: Icons.timeline_rounded,
          children: [
            for (var index = 0;
                index < ActivityType.orderedTypes.length;
                index++)
              Builder(
                builder: (context) {
                  final type = ActivityType.orderedTypes[index];
                  final activity = _activityFor(type);
                  final isPast = index < currentIndex;
                  final hasWindow = activity?.startedAt != null;
                  final isDateValid =
                      activity == null || _dateInsideActivity(activity);
                  final enabled = !isPast || hasWindow;
                  return _StageOptionTile(
                    type: type,
                    stepNumber: index + 1,
                    selected: type == selectedActivityType,
                    statusLabel: _stageStatusLabel(index, currentIndex),
                    dateLabel: activity == null
                        ? 'Date range not set'
                        : _stageMeta(type),
                    enabled: enabled,
                    warning: isPast && !isDateValid
                        ? 'Selected date is outside this stage'
                        : null,
                    onTap: () async {
                      await _handleStageTap(
                        context: context,
                        type: type,
                        activity: activity,
                        isPast: isPast,
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  String _stageStatusLabel(int index, int currentIndex) {
    if (index < currentIndex) return 'Completed';
    if (index == currentIndex) return 'Current';
    return 'Upcoming';
  }

  Future<void> _handleStageTap({
    required BuildContext context,
    required ActivityType type,
    required ActivityEntity? activity,
    required bool isPast,
  }) async {
    if (!isPast || activity == null || _dateInsideActivity(activity)) {
      onActivityChanged(type);
      Navigator.of(context).pop();
      return;
    }

    final start = activity.startedAt;
    if (start == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${type.displayName} stage date range is not set.'),
        ),
      );
      return;
    }

    final adjustedDate = _adjustedDateFor(activity);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Use ${type.displayName} stage?',
          style: AppTypography.titleLarge(dialogContext).copyWith(
            color: DashboardStyle.of(dialogContext).onBackground,
          ),
        ),
        content: Text(
          'This schedule date is outside ${type.displayName} stage '
          '(${_stageDateRange(activity)}). Do you want to continue and move '
          'the schedule date inside this stage?',
          style: AppTypography.bodyMedium(dialogContext).copyWith(
            color: DashboardStyle.of(dialogContext).onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('Use ${DateFormat('d MMM').format(adjustedDate)}'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    onActivityChanged(type);
    onScheduleDateChanged(adjustedDate);
    Navigator.of(context).pop();
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({
    required this.selectedType,
    required this.onChanged,
  });

  final ScheduleType selectedType;
  final ValueChanged<ScheduleType> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    const options = [
      (ScheduleType.work, Icons.construction_outlined),
      (ScheduleType.spray, Icons.water_drop_outlined),
      (ScheduleType.nutrition, Icons.grass_outlined),
      (ScheduleType.water, Icons.water_outlined),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        children: [
          for (var index = 0; index < options.length; index++) ...[
            Expanded(
              child: _TypeSegment(
                type: options[index].$1,
                icon: options[index].$2,
                selected: selectedType == options[index].$1,
                onTap: () => onChanged(options[index].$1),
              ),
            ),
            if (index != options.length - 1)
              const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _TypeSegment extends StatelessWidget {
  const _TypeSegment({
    required this.type,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final ScheduleType type;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    final color = selected ? colors.primary : colors.onSurfaceVariant;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppSpacing.md, color: color),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  type.displayName,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: selected ? colors.primary : colors.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.label,
    required this.value,
    required this.meta,
    required this.icon,
    required this.onTap,
    this.dense = false,
  });

  final String label;
  final String value;
  final String meta;
  final IconData icon;
  final VoidCallback onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: EdgeInsets.all(dense ? AppSpacing.sm : AppSpacing.smMd),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: colors.outline),
        ),
        child: Row(
          children: [
            Container(
              width: dense ? AppSpacing.lg : AppSpacing.xl,
              height: dense ? AppSpacing.lg : AppSpacing.xl,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                icon,
                size: dense ? AppSpacing.smMd : AppSpacing.md,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.labelLarge(context).copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    value,
                    style: (dense
                            ? AppTypography.titleMedium(context)
                            : AppTypography.titleMedium(context))
                        .copyWith(
                      color: colors.onBackground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    meta,
                    style: AppTypography.labelLarge(context).copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colors.onSurfaceVariant,
              size: AppSpacing.mdLg,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateActionChip extends StatelessWidget {
  const _DateActionChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smMd,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(color: colors.outline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colors.primary, size: AppSpacing.md),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  '$label · $value',
                  style: AppTypography.labelLarge(context).copyWith(
                    color: colors.onBackground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectorSheet extends StatelessWidget {
  const _SelectorSheet({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DashboardBottomSheetFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DashboardSheetHeader(
              title: title,
              subtitle: subtitle,
              icon: icon,
            ),
            const SizedBox(height: AppSpacing.md),
            for (var index = 0; index < children.length; index++) ...[
              children[index],
              if (index != children.length - 1)
                const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      );
}

class _PlotOptionTile extends StatelessWidget {
  const _PlotOptionTile({
    required this.plot,
    required this.selected,
    required this.onTap,
  });

  final PlotEntity plot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _OptionTile(
        title: plot.name,
        subtitle: [
          plot.cropType,
          '${plot.area} ha',
          if (plot.hasPruningDate) 'Day ${plot.daysSincePruning}',
        ].join('  ·  '),
        icon: Icons.agriculture_rounded,
        selected: selected,
        onTap: onTap,
      );
}

class _StageOptionTile extends StatelessWidget {
  const _StageOptionTile({
    required this.type,
    required this.stepNumber,
    required this.selected,
    required this.statusLabel,
    required this.dateLabel,
    required this.enabled,
    required this.onTap,
    this.warning,
  });

  final ActivityType type;
  final int stepNumber;
  final bool selected;
  final String statusLabel;
  final String dateLabel;
  final bool enabled;
  final VoidCallback onTap;
  final String? warning;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    final statusColor = switch (statusLabel) {
      'Completed' => AppColors.success,
      'Current' => colors.primary,
      _ => colors.onSurfaceVariant,
    };
    final effectiveColor = enabled ? statusColor : colors.onSurfaceDisabled;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSpacing.smMd),
        decoration: BoxDecoration(
          color: selected ? colors.primaryContainer : colors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: selected
                ? colors.primary.withValues(alpha: 0.4)
                : warning != null
                    ? AppColors.warning.withValues(alpha: 0.35)
                    : colors.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: AppSpacing.xxl,
                  height: AppSpacing.xxl,
                  decoration: BoxDecoration(
                    color: enabled
                        ? effectiveColor.withValues(alpha: 0.12)
                        : colors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: enabled
                          ? effectiveColor.withValues(alpha: 0.35)
                          : colors.outline,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$stepNumber',
                      style: AppTypography.labelLarge(context).copyWith(
                        color: effectiveColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          type.displayName,
                          style: AppTypography.titleMedium(context).copyWith(
                            color: enabled
                                ? colors.onBackground
                                : colors.onSurfaceDisabled,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _StageStatusPill(
                        label: statusLabel,
                        color: effectiveColor,
                        muted: !enabled,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    warning ?? dateLabel,
                    style: AppTypography.labelLarge(context).copyWith(
                      color: warning != null
                          ? AppColors.warningDark
                          : colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.chevron_right,
              color: selected ? colors.primary : colors.onSurfaceVariant,
              size: AppSpacing.mdLg,
            ),
          ],
        ),
      ),
    );
  }
}

class _StageStatusPill extends StatelessWidget {
  const _StageStatusPill({
    required this.label,
    required this.color,
    required this.muted,
  });

  final String label;
  final Color color;
  final bool muted;

  @override
  Widget build(BuildContext context) => DashboardStatusPill(
        label: label,
        color: color,
        muted: muted,
      );
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => DashboardListItem(
        title: title,
        subtitle: subtitle,
        icon: icon,
        selected: selected,
        onTap: onTap,
        trailing: _SelectionDot(selected: selected),
      );
}

class ScheduleFormSectionCard extends DashboardSectionCard {
  const ScheduleFormSectionCard({
    super.key,
    required super.title,
    required super.icon,
    required super.child,
    super.action,
  });
}

class _SectionCard extends DashboardSectionCard {
  const _SectionCard({
    required super.title,
    required super.icon,
    required super.child,
  });
}

class _SelectionDot extends StatelessWidget {
  const _SelectionDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Container(
      width: AppSpacing.mdLg,
      height: AppSpacing.mdLg,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? colors.primary : Colors.transparent,
        border: Border.all(
          color: selected ? colors.primary : colors.outlineStrong,
          width: 1.5,
        ),
      ),
      child: selected
          ? Icon(
              Icons.check_rounded,
              size: AppSpacing.smMd,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : null,
    );
  }
}
