import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../activity/presentation/providers/activity_providers.dart';
import '../../../activity/presentation/providers/activity_state.dart';
import '../../domain/entities/schedule_entity.dart';
import '../providers/schedule_notifier.dart';
import '../providers/schedule_providers.dart';
import 'activity_selector_widget.dart';

/// Add Schedule Form Widget
/// Modal form for creating new schedules
class AddScheduleForm extends ConsumerStatefulWidget {
  final String plotId;
  final String plotName;

  const AddScheduleForm({
    Key? key,
    required this.plotId,
    required this.plotName,
  }) : super(key: key);

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
  List<String> _selectedActivityIds = [];
  String? _activitySelectionError;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final scheduleNotifier = ref.read(scheduleNotifierProvider.notifier);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Schedule',
                    style: AppTypography.headlineLarge(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
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
                              color: AppColors.primary,
                              size: 20,
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                widget.plotName,
                                style: AppTypography.bodyMedium(context).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      // Schedule Type
                      Text(
                        'Type',
                        style: AppTypography.titleMedium(context),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      _buildTypeSelector(context),
                      SizedBox(height: AppSpacing.md),
                      // Title
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
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
                      SizedBox(height: AppSpacing.md),
                      // Date and Time
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker(context),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _buildTimePicker(context),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),
                      // Activity Selection
                      _buildActivitySelector(context),
                      SizedBox(height: AppSpacing.md),
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description (Optional)',
                          hintText: 'Enter description',
                        ),
                        maxLines: 3,
                      ),
                      SizedBox(height: AppSpacing.xl),
                      // Submit Button
                      AppButton.primary(
                        label: scheduleState.isCreating ? 'Creating...' : 'Create Schedule',
                        onPressed: scheduleState.isCreating
                            ? null
                            : () => _handleSubmit(context, scheduleNotifier),
                        isLoading: scheduleState.isCreating,
                        isFullWidth: true,
                      ),
                      SizedBox(height: AppSpacing.lg),
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
    return Row(
      children: [
        Expanded(
          child: _buildTypeChip(
            context,
            ScheduleType.spray,
            Icons.water_drop_outlined,
            AppColors.info,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildTypeChip(
            context,
            ScheduleType.nutrition,
            Icons.grass_outlined,
            AppColors.warning,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildTypeChip(
            context,
            ScheduleType.work,
            Icons.construction_outlined,
            AppColors.primary,
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
    
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: isSelected
              ? Border.all(color: color, width: 2)
              : Border.all(color: AppColors.outline),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              type.displayName,
              style: AppTypography.bodySmall(context).copyWith(
                color: isSelected ? color : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AppCard.flat(
        border: Border.all(color: AppColors.outline),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                    style: AppTypography.bodyMedium(context),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: AppCard.flat(
        border: Border.all(color: AppColors.outline),
        child: Row(
          children: [
            Icon(
              Icons.access_time_outlined,
              color: AppColors.primary,
              size: 20,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: AppTypography.bodySmall(context).copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    _selectedTime.format(context),
                    style: AppTypography.bodyMedium(context),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.onSurfaceVariant,
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
    final activityState = ref.watch(activityNotifierProvider);
    
    if (activityState.activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(
          'No activities available. Please create activities first.',
          style: AppTypography.bodySmall(context).copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );
    }

    return ActivitySelectorWidget(
      activities: activityState.activities,
      selectedActivityIds: _selectedActivityIds,
      onSelectionChanged: (ids) {
        setState(() {
          _selectedActivityIds = ids;
          _activitySelectionError = null;
        });
      },
      errorText: _activitySelectionError,
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

    if (!_formKey.currentState!.validate()) return;

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
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Schedule created successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notifier.state.errorMessage ?? 'Failed to create schedule'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
