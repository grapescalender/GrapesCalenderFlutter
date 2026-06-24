import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../activity/domain/entities/activity_entity.dart';
import '../../../home/domain/entities/plot_entity.dart';
import '../../domain/entities/schedule_entity.dart';

class ScheduleDetailsForm extends StatelessWidget {
  const ScheduleDetailsForm({
    super.key,
    required this.plots,
    required this.selectedPlotId,
    required this.selectedType,
    required this.selectedActivityType,
    required this.scheduleDate,
    required this.dueDate,
    required this.onPlotChanged,
    required this.onTypeChanged,
    required this.onActivityChanged,
    required this.onScheduleDateTap,
    required this.onDueDateTap,
    required this.onTimeTap,
  });

  final List<PlotEntity> plots;
  final String selectedPlotId;
  final ScheduleType selectedType;
  final ActivityType selectedActivityType;
  final DateTime scheduleDate;
  final DateTime dueDate;
  final ValueChanged<String> onPlotChanged;
  final ValueChanged<ScheduleType> onTypeChanged;
  final ValueChanged<ActivityType> onActivityChanged;
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
            meta: 'Tap to change growth stage',
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

  void _openPlotSelector(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
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
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
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
            for (final type in ActivityType.orderedTypes)
              _StageOptionTile(
                type: type,
                selected: type == selectedActivityType,
                onTap: () {
                  onActivityChanged(type);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
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
    const options = [
      (ScheduleType.work, Icons.construction_outlined),
      (ScheduleType.spray, Icons.water_drop_outlined),
      (ScheduleType.nutrition, Icons.grass_outlined),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.outlineVariant),
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
    final color = selected ? AppColors.primary : AppColors.onSurfaceVariant;
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
            color: selected ? AppColors.primaryContainer : Colors.transparent,
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
                  style: AppTypography.chipText(context).copyWith(
                    color: selected ? AppColors.primary : AppColors.onSurface,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
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
  });

  final String label;
  final String value;
  final String meta;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.smMd),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.xl,
                height: AppSpacing.xl,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child:
                    Icon(icon, size: AppSpacing.md, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTypography.caption(context).copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      value,
                      style: AppTypography.cardTitle(context).copyWith(
                        color: AppColors.onBackground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      meta,
                      style: AppTypography.caption(context).copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.onSurfaceVariant,
                size: AppSpacing.mdLg,
              ),
            ],
          ),
        ),
      );
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
  Widget build(BuildContext context) => Material(
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
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primary, size: AppSpacing.md),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    '$label · $value',
                    style: AppTypography.chipText(context).copyWith(
                      color: AppColors.onBackground,
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
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.72,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.smMd,
            AppSpacing.screenHorizontal,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSpacing.xl,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Container(
                    width: AppSpacing.xl,
                    height: AppSpacing.xl,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary,
                      size: AppSpacing.mdLg,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.smMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.headlineSmall(context).copyWith(
                            color: AppColors.onBackground,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: AppTypography.bodySmall(context).copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1)
                  const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
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
    required this.selected,
    required this.onTap,
  });

  final ActivityType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _OptionTile(
        title: '${type.displayName} Stage',
        subtitle: 'Use this stage for the schedule activity',
        icon: Icons.timeline_rounded,
        selected: selected,
        onTap: onTap,
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
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smMd,
            vertical: AppSpacing.smMd,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryContainer : AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.4)
                  : AppColors.outline,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.xxl,
                height: AppSpacing.xxl,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.25)
                        : AppColors.outline,
                  ),
                ),
                child: Icon(
                  icon,
                  color:
                      selected ? AppColors.primary : AppColors.onSurfaceVariant,
                  size: AppSpacing.mdLg,
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleLarge(context).copyWith(
                        color: selected
                            ? AppColors.primary
                            : AppColors.onBackground,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall(context).copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: AppSpacing.mdLg,
                height: AppSpacing.mdLg,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.outline,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        size: AppSpacing.smMd,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
}

class ScheduleFormSectionCard extends _SectionCard {
  const ScheduleFormSectionCard({
    super.key,
    required super.title,
    required super.icon,
    required super.child,
    super.action,
  });
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.action,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: AppSpacing.mdLg, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.titleMedium(context).copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: AppSpacing.smMd),
            child,
          ],
        ),
      );
}
