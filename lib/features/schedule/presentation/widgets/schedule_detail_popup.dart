import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/theme/app_status_colors.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../activity/presentation/providers/activity_providers.dart';
import '../../domain/entities/schedule_entity.dart';
import '../providers/schedule_providers.dart';

/// Material 3 bottom sheet that presents each schedule value only once.
class ScheduleDetailPopup extends ConsumerStatefulWidget {
  const ScheduleDetailPopup({
    required this.schedule,
    super.key,
    this.pruningDate,
    this.hasCompletionPermission = true,
    this.isActive = true,
    this.isReadOnly = false,
  });

  final ScheduleEntity schedule;
  final DateTime? pruningDate;

  /// Eligibility supplied by the caller when authorization/lifecycle metadata
  /// is available outside the schedule entity.
  final bool hasCompletionPermission;
  final bool isActive;
  final bool isReadOnly;

  @override
  ConsumerState<ScheduleDetailPopup> createState() =>
      _ScheduleDetailPopupState();
}

class _ScheduleDetailPopupState extends ConsumerState<ScheduleDetailPopup> {
  late ScheduleEntity _schedule;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _schedule = widget.schedule;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _schedule.activityIds.isEmpty) return;
      final activityState = ref.read(activityNotifierProvider);
      if (activityState.isLoading ||
          (activityState.selectedPlotId == _schedule.plotId &&
              activityState.activities.isNotEmpty)) {
        return;
      }
      ref.read(activityNotifierProvider.notifier).loadActivities(
            plotId: _schedule.plotId,
            plotName: _schedule.plotName,
          );
    });
  }

  bool get _isAlreadyCompleted => _schedule.isCompleted;

  bool get _isActivityCompleted {
    if (_schedule.activityIds.isEmpty) return false;
    final activities = ref.read(activityNotifierProvider).activities;
    return activities.any(
      (activity) =>
          _schedule.activityIds.contains(activity.id) && activity.isCompleted,
    );
  }

  bool get _canMarkCompleted =>
      !_isAlreadyCompleted &&
      !_isActivityCompleted &&
      !ref.read(activityNotifierProvider).isLoading &&
      widget.hasCompletionPermission &&
      widget.isActive &&
      !widget.isReadOnly &&
      !_isCompleting;

  @override
  Widget build(BuildContext context) {
    ref.watch(activityNotifierProvider);
    final typeColor = _typeColor(_schedule.type);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.24),
                  blurRadius: 24,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  const _DragHandle(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.sm,
                      AppSpacing.xs,
                      AppSpacing.smMd,
                    ),
                    child: _Header(
                      schedule: _schedule,
                      typeColor: typeColor,
                      statusLabel: _statusLabel,
                      statusColor: _statusColor(context),
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenHorizontal,
                        0,
                        AppSpacing.screenHorizontal,
                        AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SectionTitle(title: 'Summary'),
                          const SizedBox(height: AppSpacing.sm),
                          _SummaryGrid(items: _summaryItems(context)),
                          if (_detailItems.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.md),
                            const _SectionTitle(title: 'Details'),
                            const SizedBox(height: AppSpacing.sm),
                            _DetailCard(items: _detailItems),
                          ],
                          if (_isActivityCompleted) ...[
                            const SizedBox(height: AppSpacing.md),
                            const _MutedMessage(
                              text: 'This activity is already completed.',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (_canMarkCompleted || _isCompleting)
                    _ActionBar(
                      isCompleting: _isCompleting,
                      onComplete: _completeSchedule,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<_InfoItem> _summaryItems(BuildContext context) => [
        _InfoItem(
          icon: Icons.landscape_outlined,
          label: 'Plot',
          value: _schedule.plotName.isEmpty ? 'Not set' : _schedule.plotName,
        ),
        _InfoItem(
          icon: Icons.timeline_rounded,
          label: 'Day After Pruning',
          value: _dayAfterPruning,
          valueColor: AppColors.primary,
        ),
        _InfoItem(
          icon: Icons.eco_outlined,
          label: 'Stage',
          value: _activityLabel,
        ),
        _InfoItem(
          icon: Icons.calendar_today_outlined,
          label: 'Schedule Date / Due Date',
          value: DateFormat('dd MMM yyyy').format(_schedule.scheduledDate),
        ),
        _InfoItem(
          icon: Icons.event_available_outlined,
          label: 'Due Status',
          value: _dueStatusLabel,
          valueColor: _dueStatusColor(context),
        ),
      ];

  List<_InfoItem> get _detailItems {
    final description = _schedule.description?.trim();
    if (description == null || description.isEmpty) return const [];

    return [
      _InfoItem(
        icon: _detailIcon,
        label: _detailLabel,
        value: description,
      ),
    ];
  }

  String get _detailLabel {
    switch (_schedule.type) {
      case ScheduleType.work:
        return 'Work Instructions';
      case ScheduleType.spray:
        return 'Application Instructions';
      case ScheduleType.nutrition:
        return 'Method / Notes';
      case ScheduleType.all:
        return 'Instructions / Notes';
    }
  }

  IconData get _detailIcon {
    switch (_schedule.type) {
      case ScheduleType.work:
        return Icons.assignment_outlined;
      case ScheduleType.spray:
        return Icons.water_drop_outlined;
      case ScheduleType.nutrition:
        return Icons.grass_outlined;
      case ScheduleType.all:
        return Icons.notes_outlined;
    }
  }

  Future<void> _completeSchedule() async {
    if (!_canMarkCompleted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Mark as completed?'),
        content: const Text('Mark this schedule as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Mark as Completed'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isCompleting = true);
    final error = await ref
        .read(scheduleNotifierProvider.notifier)
        .completeSchedule(_schedule);

    if (!mounted) return;

    if (error != null) {
      setState(() => _isCompleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    setState(() {
      _schedule = ScheduleEntity(
        id: _schedule.id,
        plotId: _schedule.plotId,
        plotName: _schedule.plotName,
        type: _schedule.type,
        title: _schedule.title,
        scheduledDate: _schedule.scheduledDate,
        description: _schedule.description,
        isCompleted: true,
        activityIds: _schedule.activityIds,
        createdAt: _schedule.createdAt,
        updatedAt: DateTime.now(),
      );
      _isCompleting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule marked as completed')),
    );
  }

  String get _statusLabel {
    if (_isAlreadyCompleted) return 'Completed';
    if (_isOverdue || _isToday) return 'Pending';
    return 'Upcoming';
  }

  String get _dueStatusLabel {
    if (_isAlreadyCompleted) return 'Completed';
    if (_isToday) return 'Due Today';
    if (_isTomorrow) return 'Due Tomorrow';
    if (_isOverdue) return 'Overdue';
    return 'Upcoming';
  }

  String get _dayAfterPruning {
    if (widget.pruningDate == null) return 'Not set';
    final scheduleDay = DateUtils.dateOnly(_schedule.scheduledDate);
    final pruningDay = DateUtils.dateOnly(widget.pruningDate!);
    final day = scheduleDay.difference(pruningDay).inDays;
    return day >= 0 ? 'Day $day' : 'Not set';
  }

  String get _activityLabel {
    if (_schedule.activityIds.isEmpty) return 'Not linked';
    final raw = _schedule.activityIds.first.split('_').last;
    return raw
        .split(RegExp(r'[-_\s]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  bool get _isToday =>
      DateUtils.isSameDay(_schedule.scheduledDate, DateTime.now());

  bool get _isTomorrow => DateUtils.isSameDay(
        _schedule.scheduledDate,
        DateTime.now().add(const Duration(days: 1)),
      );

  bool get _isOverdue =>
      !_isAlreadyCompleted &&
      DateUtils.dateOnly(_schedule.scheduledDate)
          .isBefore(DateUtils.dateOnly(DateTime.now()));

  Color _statusColor(BuildContext context) {
    final colors = Theme.of(context).extension<AppStatusColors>()!;
    if (_isAlreadyCompleted) return colors.completed;
    if (_isToday || _isOverdue) return AppColors.warning;
    return colors.upcoming;
  }

  Color _dueStatusColor(BuildContext context) {
    if (_isAlreadyCompleted) return _statusColor(context);
    if (_isOverdue) return AppColors.error;
    if (_isToday || _isTomorrow) return AppColors.primary;
    return AppColors.onSurfaceVariant;
  }

  static Color _typeColor(ScheduleType type) {
    switch (type) {
      case ScheduleType.work:
        return AppColors.success;
      case ScheduleType.spray:
        return AppColors.info;
      case ScheduleType.nutrition:
        return AppColors.warning;
      case ScheduleType.all:
        return AppColors.onSurface;
    }
  }

  static IconData _typeIcon(ScheduleType type) {
    switch (type) {
      case ScheduleType.spray:
        return Icons.water_drop_outlined;
      case ScheduleType.nutrition:
        return Icons.grass_outlined;
      case ScheduleType.work:
        return Icons.construction_outlined;
      case ScheduleType.all:
        return Icons.list_alt_outlined;
    }
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) => Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.outline,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header({
    required this.schedule,
    required this.typeColor,
    required this.statusLabel,
    required this.statusColor,
    required this.onClose,
  });

  final ScheduleEntity schedule;
  final Color typeColor;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: typeColor.withValues(alpha: 0.22)),
          ),
          child: Icon(
            _ScheduleDetailPopupState._typeIcon(schedule.type),
            color: typeColor,
            size: 22,
          ),
        ),
        const SizedBox(width: AppSpacing.smMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                schedule.title,
                style: AppTypography.headlineSmall(context).copyWith(
                  color: AppColors.onBackground,
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                schedule.type.displayName,
                style: AppTypography.bodySmall(context).copyWith(
                  color: typeColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        DashboardPill(label: statusLabel, color: statusColor),
        IconButton(
          tooltip: 'Close',
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: AppTypography.titleLarge(context).copyWith(
          color: AppColors.onBackground,
          fontWeight: FontWeight.w900,
        ),
      );
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth < 340
            ? constraints.maxWidth
            : (constraints.maxWidth - AppSpacing.sm) / 2;
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final item in items)
              SizedBox(width: width, child: _InfoTile(item: item)),
          ],
        );
      },
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.smMd),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Column(
          children: [for (final item in items) _InfoRow(item: item)],
        ),
      );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.item});

  final _InfoItem item;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.smMd),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: _InfoRow(item: item),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.item});

  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.valueColor ?? AppColors.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(item.icon, size: 16, color: color),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: AppTypography.labelSmall(context).copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.value,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: item.valueColor ?? AppColors.onBackground,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MutedMessage extends StatelessWidget {
  const _MutedMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.smMd),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(
          text,
          style: AppTypography.bodySmall(context).copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isCompleting,
    required this.onComplete,
  });

  final bool isCompleting;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.outlineVariant)),
        ),
        child: FilledButton.icon(
          onPressed: isCompleting ? null : onComplete,
          icon: isCompleting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check_circle_outline_rounded),
          label: Text(
            isCompleting ? 'Marking as Completed...' : 'Mark as Completed',
          ),
        ),
      );
}

class _InfoItem {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
}
