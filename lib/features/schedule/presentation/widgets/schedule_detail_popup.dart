import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/theme/app_status_colors.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../domain/entities/schedule_entity.dart';

/// Modern Material 3 bottom sheet for schedule details.
class ScheduleDetailPopup extends StatelessWidget {
  const ScheduleDetailPopup({
    Key? key,
    required this.schedule,
    this.pruningDate,
  }) : super(key: key);

  final ScheduleEntity schedule;
  final DateTime? pruningDate;

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(schedule.type);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
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
                top: Radius.circular(AppSpacing.radiusHuge),
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
                      AppSpacing.screenHorizontal,
                      AppSpacing.smMd,
                    ),
                    child: _Header(
                      schedule: schedule,
                      typeColor: typeColor,
                      statusLabel: _statusLabel,
                      statusColor: _statusColor(context),
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
                          _SectionTitle(title: 'Summary'),
                          const SizedBox(height: AppSpacing.sm),
                          _SummaryGrid(
                            items: [
                              _InfoItem(
                                icon: Icons.landscape_outlined,
                                label: 'Plot',
                                value: schedule.plotName,
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
                                icon: _typeIcon(schedule.type),
                                label: 'Type',
                                value: schedule.type.displayName,
                                valueColor: typeColor,
                              ),
                              _InfoItem(
                                icon: Icons.event_available_outlined,
                                label: 'Due Status',
                                value: _dueStatusLabel,
                                valueColor: _dueStatusColor(context),
                              ),
                              _InfoItem(
                                icon: Icons.calendar_today_outlined,
                                label: 'Schedule Date',
                                value: _formatDate(schedule.scheduledDate),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _SectionTitle(title: 'Details'),
                          const SizedBox(height: AppSpacing.sm),
                          _DetailCard(
                            items: _detailItems(typeColor),
                          ),
                          if (_hasDescription) ...[
                            const SizedBox(height: AppSpacing.md),
                            _SectionTitle(title: 'Notes'),
                            const SizedBox(height: AppSpacing.sm),
                            _NoteCard(text: schedule.description!),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _ActionBar(
                    isCompleted: schedule.isCompleted,
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _hasDescription =>
      schedule.description != null && schedule.description!.trim().isNotEmpty;

  String get _statusLabel {
    if (schedule.isCompleted) return 'Completed';
    if (_isOverdue || _isToday) return 'Pending';
    return 'Upcoming';
  }

  String get _dueStatusLabel {
    if (schedule.isCompleted) return 'Completed';
    if (_isToday) return 'Due Today';
    if (_isTomorrow) return 'Due Tomorrow';
    if (_isOverdue) return 'Overdue';
    return 'Upcoming';
  }

  String get _dayAfterPruning {
    if (pruningDate == null) return 'Not set';
    final scheduleDay = DateTime(
      schedule.scheduledDate.year,
      schedule.scheduledDate.month,
      schedule.scheduledDate.day,
    );
    final pruningDay = DateTime(
      pruningDate!.year,
      pruningDate!.month,
      pruningDate!.day,
    );
    final day = scheduleDay.difference(pruningDay).inDays;
    return day > 0 ? 'Day $day' : 'Not set';
  }

  String get _activityLabel {
    if (schedule.activityIds.isEmpty) return 'Not linked';
    final raw = schedule.activityIds.first.split('_').last;
    return raw
        .split(RegExp(r'[-_\s]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  bool get _isToday {
    final now = DateTime.now();
    final date = schedule.scheduledDate;
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool get _isTomorrow {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final date = schedule.scheduledDate;
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  bool get _isOverdue {
    if (schedule.isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = schedule.scheduledDate;
    final scheduleDay = DateTime(date.year, date.month, date.day);
    return scheduleDay.isBefore(today);
  }

  Color _statusColor(BuildContext context) {
    final statusColors = Theme.of(context).extension<AppStatusColors>()!;
    if (schedule.isCompleted) return statusColors.completed;
    if (_isToday || _isOverdue) return AppColors.warning;
    return statusColors.upcoming;
  }

  Color _dueStatusColor(BuildContext context) {
    if (schedule.isCompleted) return _statusColor(context);
    if (_isOverdue) return AppColors.error;
    if (_isToday || _isTomorrow) return AppColors.primary;
    return AppColors.onSurfaceVariant;
  }

  List<_InfoItem> _detailItems(Color typeColor) {
    final items = <_InfoItem>[
      _InfoItem(
        icon: _typeIcon(schedule.type),
        label: _detailNameLabel,
        value: schedule.title,
        valueColor: typeColor,
      ),
      _InfoItem(
        icon: Icons.play_circle_outline_rounded,
        label: 'Start Date',
        value: _formatDate(schedule.scheduledDate),
      ),
      _InfoItem(
        icon: Icons.flag_outlined,
        label: 'Due Date',
        value: _formatDate(schedule.scheduledDate),
      ),
    ];

    if (_hasDescription) {
      items.add(
        _InfoItem(
          icon: Icons.notes_outlined,
          label: _instructionLabel,
          value: schedule.description!.trim(),
        ),
      );
    }

    return items;
  }

  String get _detailNameLabel {
    switch (schedule.type) {
      case ScheduleType.spray:
        return 'Spray Name';
      case ScheduleType.nutrition:
        return 'Nutrition Name';
      case ScheduleType.work:
        return 'Activity Name';
      case ScheduleType.all:
        return 'Schedule Name';
    }
  }

  String get _instructionLabel {
    switch (schedule.type) {
      case ScheduleType.spray:
        return 'Application Instructions';
      case ScheduleType.nutrition:
        return 'Application Method';
      case ScheduleType.work:
        return 'Work Instructions';
      case ScheduleType.all:
        return 'Instructions';
    }
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

  static String _formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy').format(date);
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.outline,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.schedule,
    required this.typeColor,
    required this.statusLabel,
    required this.statusColor,
  });

  final ScheduleEntity schedule;
  final Color typeColor;
  final String statusLabel;
  final Color statusColor;

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
            ScheduleDetailPopup._typeIcon(schedule.type),
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
                '${schedule.type.displayName} Schedule',
                style: AppTypography.bodySmall(context).copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        DashboardPill(
          label: statusLabel,
          color: statusColor,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.titleLarge(context).copyWith(
        color: AppColors.onBackground,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useSingleColumn = constraints.maxWidth < 340;
        if (useSingleColumn) {
          return Column(
            children: [
              for (final item in items) ...[
                _InfoTile(item: item),
                if (item != items.last) const SizedBox(height: AppSpacing.xs),
              ],
            ],
          );
        }

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: items
              .map(
                (item) => SizedBox(
                  width: (constraints.maxWidth - AppSpacing.sm) / 2,
                  child: _InfoTile(item: item),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          for (final item in items) ...[
            _InfoRow(item: item),
            if (item != items.last)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Divider(height: 1, color: AppColors.outlineVariant),
              ),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.item});

  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: _InfoRow(item: item),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.item});

  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color:
                (item.valueColor ?? AppColors.primary).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(
            item.icon,
            size: 16,
            color: item.valueColor ?? AppColors.primary,
          ),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                item.value,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: item.valueColor ?? AppColors.onBackground,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Text(
        text,
        style: AppTypography.bodyMedium(context).copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isCompleted,
    required this.onClose,
  });

  final bool isCompleted;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.smMd,
        AppSpacing.screenHorizontal,
        AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: null,
              child: Text(isCompleted ? 'Completed' : 'Mark as Completed'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          OutlinedButton(
            onPressed: null,
            child: const Text('Edit'),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            onPressed: onClose,
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
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
