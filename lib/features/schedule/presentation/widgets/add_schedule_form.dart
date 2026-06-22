import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../activity/domain/entities/activity_entity.dart';
import '../../../activity/presentation/providers/activity_providers.dart';
import '../../domain/entities/schedule_entity.dart';
import '../providers/schedule_notifier.dart';
import '../providers/schedule_providers.dart';
import 'activity_selector_widget.dart';

/// Add Schedule Form Widget
/// Modal form for creating new schedules
class AddScheduleForm extends ConsumerStatefulWidget {
  const AddScheduleForm({
    Key? key,
    required this.plotId,
    required this.plotName,
  }) : super(key: key);
  final String plotId;
  final String plotName;

  @override
  ConsumerState<AddScheduleForm> createState() => _AddScheduleFormState();
}

class _AddScheduleFormState extends ConsumerState<AddScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ScheduleType _selectedType = ScheduleType.spray;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  ActivityType _selectedCurrentActivityType = ActivityType.cutting;
  List<String> _selectedActivityIds = [];
  String? _activitySelectionError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(activityNotifierProvider.notifier)
            .loadActivities(
              plotId: widget.plotId,
              plotName: widget.plotName,
            )
            .then((_) {
          if (!mounted) {
            return;
          }
          final activeActivity =
              ref.read(activityNotifierProvider).activeActivity;
          if (activeActivity != null) {
            setState(() {
              _selectedCurrentActivityType = activeActivity.type;
              _selectedActivityIds = [
                _activityIdForType(activeActivity.type),
              ];
            });
          } else {
            setState(() {
              _selectedActivityIds = [
                _activityIdForType(_selectedCurrentActivityType),
              ];
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final scheduleNotifier = ref.read(scheduleNotifierProvider.notifier);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Schedule',
                    style: AppTypography.headlineLarge(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Plot Name
                      AppCard.flat(
                        child: Row(
                          children: [
                            Icon(
                              Icons.agriculture,
                              color: cs.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                widget.plotName,
                                style:
                                    AppTypography.bodyMedium(context).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Schedule Type
                      Text(
                        'Type',
                        style: AppTypography.titleMedium(context),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildTypeSelector(context),
                      const SizedBox(height: AppSpacing.md),
                      // Title
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter schedule title',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Date and Time
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker(context),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _buildTimePicker(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Activity Selection
                      _buildActivitySelector(context),
                      const SizedBox(height: AppSpacing.md),
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description (Optional)',
                          hintText: 'Enter description',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      // Submit Button
                      AppButton.primary(
                        label: scheduleState.isCreating
                            ? 'Creating...'
                            : 'Create Schedule',
                        onPressed: scheduleState.isCreating
                            ? null
                            : () => _handleSubmit(context, scheduleNotifier),
                        isLoading: scheduleState.isCreating,
                        isFullWidth: true,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    return Row(
      children: [
        Expanded(
          child: _buildTypeChip(
            context,
            ScheduleType.spray,
            Icons.water_drop_outlined,
            semantic.info,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildTypeChip(
            context,
            ScheduleType.nutrition,
            Icons.grass_outlined,
            semantic.warning,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildTypeChip(
            context,
            ScheduleType.work,
            Icons.construction_outlined,
            cs.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeChip(
    BuildContext context,
    ScheduleType type,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedType == type;
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color:
              isSelected ? color.withOpacity(0.1) : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: isSelected
              ? Border.all(color: color, width: 2)
              : Border.all(color: cs.outline),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : cs.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              type.displayName,
              style: AppTypography.bodySmall(context).copyWith(
                color: isSelected ? color : cs.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AppCard.flat(
        border: Border.all(color: cs.outline),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: cs.primary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                    style: AppTypography.bodyMedium(context),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: AppCard.flat(
        border: Border.all(color: cs.outline),
        child: Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              color: cs.primary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _selectedTime.format(context),
                    style: AppTypography.bodyMedium(context),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Widget _buildActivitySelector(BuildContext context) {
    final activities = _availableActivitiesForSchedule(watch: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<ActivityType>(
          initialValue: _selectedCurrentActivityType,
          decoration: const InputDecoration(
            labelText: 'Current Activity',
            prefixIcon: Icon(Icons.timeline_rounded),
          ),
          items: ActivityType.orderedTypes
              .map(
                (type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                ),
              )
              .toList(),
          onChanged: (type) {
            if (type == null) {
              return;
            }
            setState(() {
              _selectedCurrentActivityType = type;
              _selectedActivityIds = [_activityIdForType(type)];
              _activitySelectionError = null;
            });
          },
        ),
        const SizedBox(height: AppSpacing.md),
        ActivitySelectorWidget(
          activities: activities,
          selectedActivityIds: _selectedActivityIds,
          onSelectionChanged: (ids) {
            setState(() {
              final currentActivityId =
                  _activityIdForType(_selectedCurrentActivityType);
              _selectedActivityIds = ids.contains(currentActivityId)
                  ? ids
                  : [currentActivityId, ...ids].take(2).toList();
              _activitySelectionError = null;
            });
          },
          errorText: _activitySelectionError,
          helperText: 'Bind this schedule with current or previous activity.',
        ),
      ],
    );
  }

  Future<void> _handleSubmit(
    BuildContext context,
    ScheduleNotifier notifier,
  ) async {
    // Validate activity selection
    if (_selectedActivityIds.isEmpty) {
      setState(() {
        _activitySelectionError = 'Please select at least one activity';
      });
      return;
    }

    if (_selectedActivityIds.length > 2) {
      setState(() {
        _activitySelectionError = 'Maximum 2 activities allowed';
      });
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final success = await notifier.createSchedule(
      plotId: widget.plotId,
      plotName: widget.plotName,
      type: _selectedType,
      title: _titleController.text.trim(),
      scheduledDate: scheduledDateTime,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      activityIds: _selectedActivityIds,
    );

    if (success && context.mounted) {
      await _startSelectedCurrentActivity();

      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Schedule created successfully'),
          backgroundColor:
              Theme.of(context).extension<AppSemanticColors>()!.success,
        ),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to create schedule'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  List<ActivityEntity> _availableActivitiesForSchedule({
    required bool watch,
  }) {
    final activityState = watch
        ? ref.watch(activityNotifierProvider)
        : ref.read(activityNotifierProvider);
    final existingActivities = activityState.activities;
    final options = <ActivityEntity>[];
    final previousType = _previousActivityType(_selectedCurrentActivityType);

    if (previousType != null) {
      options.add(_activityForType(
        previousType,
        existingActivities,
        fallbackStatus: ActivityStatus.completed,
      ));
    }

    options.add(_activityForType(
      _selectedCurrentActivityType,
      existingActivities,
      fallbackStatus: ActivityStatus.active,
    ));

    return options;
  }

  Future<void> _startSelectedCurrentActivity() async {
    await ref.read(activityNotifierProvider.notifier).startActivity(
          plotId: widget.plotId,
          type: _selectedCurrentActivityType,
        );
  }

  ActivityEntity _activityForType(
    ActivityType type,
    List<ActivityEntity> existingActivities, {
    required ActivityStatus fallbackStatus,
  }) {
    final now = DateTime.now();
    return existingActivities.firstWhere(
      (activity) => activity.type == type,
      orElse: () => ActivityEntity(
        id: _activityIdForType(type),
        plotId: widget.plotId,
        plotName: widget.plotName,
        type: type,
        status: fallbackStatus,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  ActivityType? _previousActivityType(ActivityType currentType) {
    final orderedTypes = ActivityType.orderedTypes;
    final currentIndex = orderedTypes.indexOf(currentType);
    if (currentIndex <= 0) {
      return null;
    }
    return orderedTypes[currentIndex - 1];
  }

  String _activityIdForType(ActivityType type) =>
      'activity_${widget.plotId}_${type.value}';
}
