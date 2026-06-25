import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../activity/domain/entities/activity_entity.dart';
import '../../../activity/presentation/providers/activity_providers.dart';
import '../../../home/domain/entities/plot_entity.dart';
import '../../../home/presentation/providers/plot_notifier.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/providers/product_providers.dart';
import '../../domain/entities/schedule_entity.dart';
import '../models/add_schedule_request.dart';
import '../providers/schedule_providers.dart';
import 'compact_plot_selector.dart';
import 'animated_plot_summary_card.dart';
import 'schedule_details_form.dart';
import 'selected_product_card.dart';
import 'sticky_save_action.dart';
import 'product_search_bottom_sheet.dart';
import 'product_config_bottom_sheet.dart';

class AddSchedulePopup extends ConsumerStatefulWidget {
  const AddSchedulePopup({
    required this.plotId,
    required this.plotName,
    super.key,
  });

  final String plotId;
  final String plotName;

  @override
  ConsumerState<AddSchedulePopup> createState() => _AddSchedulePopupState();
}

class _AddSchedulePopupState extends ConsumerState<AddSchedulePopup> {
  final _formKey = GlobalKey<FormState>();
  final _productSearchController = TextEditingController();
  final _productSearchFocusNode = FocusNode();
  final _instructionsController = TextEditingController();
  final _notesController = TextEditingController();
  final _workNameController = TextEditingController();
  final _labourController = TextEditingController();
  final _durationController = TextEditingController();

  Timer? _searchDebounce;
  late String _selectedPlotId;
  late String _selectedPlotName;
  ScheduleType _selectedType = ScheduleType.spray;
  ActivityType _selectedActivityType = ActivityType.cutting;
  DateTime _scheduleDate = DateTime.now();
  DateTime _dueDate = DateTime.now();
  bool _isAlreadyApplied = false;
  List<ScheduleProductDraft> _products = const [];
  List<ProductEntity> _searchResults = const [];
  bool _isSearching = false;
  String? _productError;

  bool get _usesProducts =>
      _selectedType == ScheduleType.spray ||
      _selectedType == ScheduleType.nutrition;
  String get _combinationName =>
      _products.map((product) => product.productName).join(' + ');

  @override
  void initState() {
    super.initState();
    _selectedPlotId = widget.plotId;
    _selectedPlotName = widget.plotName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActivities();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _productSearchController.dispose();
    _productSearchFocusNode.dispose();
    _instructionsController.dispose();
    _notesController.dispose();
    _workNameController.dispose();
    _labourController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState = ref.watch(scheduleNotifierProvider);
    final activityState = ref.watch(activityNotifierProvider);
    final plots = ref.watch(plotNotifierProvider).plots;
    final availablePlots = plots.isEmpty
        ? [
            PlotEntity(
              id: _selectedPlotId,
              name: _selectedPlotName,
              area: 0,
              location: '',
              cropType: 'Grapes',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ]
        : plots;
    final selectedPlot = availablePlots.firstWhere(
      (plot) => plot.id == _selectedPlotId,
      orElse: () => availablePlots.first,
    );
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final cs = Theme.of(context).colorScheme;

    return FractionallySizedBox(
      heightFactor: 0.96,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusHuge),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                const DashboardDragHandle(),
                _AppBar(
                  onClose: () => Navigator.of(context).pop(),
                  onSave: scheduleState.isCreating ? null : _submit,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenHorizontal,
                        AppSpacing.sm,
                        AppSpacing.screenHorizontal,
                        AppSpacing.lg,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Plot Selection Section
                          CompactPlotSelector(
                            plots: availablePlots,
                            selectedPlotId: selectedPlot.id,
                            onPlotChanged: _changePlot,
                          ),
                          const SizedBox(height: AppSpacing.smMd),

                          // 2. Plot Summary Section
                          AnimatedPlotSummaryCard(
                            plotName: selectedPlot.name,
                            dayAfterPruning:
                                _dayAfterPruning(selectedPlot.pruningDate),
                            scheduleType: _selectedType,
                            stageName: _selectedActivityType.displayName,
                            productCount: _products.length,
                            pruningDate: selectedPlot.pruningDate,
                          ),
                          const SizedBox(height: AppSpacing.smMd),

                          // 3. Schedule Details Section
                          ScheduleDetailsForm(
                            activities: activityState.activities,
                            selectedType: _selectedType,
                            selectedActivityType: _selectedActivityType,
                            scheduleDate: _scheduleDate,
                            dueDate: _dueDate,
                            onTypeChanged: _changeType,
                            onActivityChanged: _changeActivity,
                            onScheduleDateChanged: _changeScheduleDate,
                            onScheduleDateTap: _selectScheduleDate,
                            onDueDateTap: _selectDueDate,
                            onTimeTap: _selectTime,
                            contextMessage: _scheduleDateContextMessage(
                              activities: activityState.activities,
                              pruningDate: selectedPlot.pruningDate,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.smMd),

                          if (_selectedType == ScheduleType.work) ...[
                            _buildWorkSection(),
                            const SizedBox(height: AppSpacing.smMd),
                          ] else if (_selectedType == ScheduleType.water) ...[
                            _buildWaterSection(),
                            const SizedBox(height: AppSpacing.smMd),
                          ],

                          // 4. Product to Apply Section
                          if (_usesProducts) ...[
                            _buildProductSection(),
                            const SizedBox(height: AppSpacing.smMd),
                          ],

                          // 5. Notes / Additional Info Section
                          _buildInstructionsSection(),
                          const SizedBox(height: AppSpacing.smMd),
                          _buildStatusSection(),
                        ],
                      ),
                    ),
                  ),
                ),
                StickySaveAction(
                  isSaving: scheduleState.isCreating,
                  onSave: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_productError != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 14, color: AppColors.error),
                const SizedBox(width: 4),
                Text(
                  _productError!,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        ScheduleFormSectionCard(
          title: 'Products to Apply',
          icon: Icons.science_outlined,
          action: _AddProductPill(onTap: _openProductSearchSheet),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: _products.isEmpty
                ? _ProductEmptyState(onAdd: _openProductSearchSheet)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var index = 0;
                          index < _products.length;
                          index++) ...[
                        SelectedProductCard(
                          product: _products[index],
                          onRemove: () => _removeProduct(index),
                          onEdit: () => _editProduct(index),
                        ),
                        if (index != _products.length - 1)
                          const SizedBox(height: AppSpacing.sm),
                      ],
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    final cs = Theme.of(context).colorScheme;
    return DashboardSectionCard(
      title: 'Final status',
      icon: Icons.fact_check_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose how it should appear after saving.',
            style: AppTypography.labelLarge(context).copyWith(
              color: cs.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.smMd),
          _ScheduleStatusToggle(
            isAlreadyApplied: _isAlreadyApplied,
            onChanged: (value) => setState(() => _isAlreadyApplied = value),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkSection() {
    return ScheduleFormSectionCard(
      title: 'Work Details',
      icon: Icons.construction_outlined,
      child: Column(
        children: [
          TextFormField(
            controller: _workNameController,
            decoration: DashboardField.decoration(
              context: context,
              label: 'Work Activity Name',
              hint: 'e.g. Weeding, tying, pruning',
              icon: Icons.task_alt_rounded,
            ),
            validator: (value) {
              if (_selectedType != ScheduleType.work) return null;
              if (value == null || value.trim().isEmpty) {
                return 'Work activity is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.smMd),
          TextFormField(
            controller: _instructionsController,
            minLines: 2,
            maxLines: 4,
            decoration: DashboardField.decoration(
              context: context,
              label: 'Work Instructions',
              hint: 'Explain what the team should do',
              icon: Icons.assignment_outlined,
            ),
            validator: (value) {
              if (_selectedType != ScheduleType.work) return null;
              if (value == null || value.trim().isEmpty) {
                return 'Work instructions are required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.smMd),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _labourController,
                  decoration: DashboardField.decoration(
                    context: context,
                    label: 'Labour / Team',
                    hint: 'e.g. 4 workers',
                    icon: Icons.groups_outlined,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextFormField(
                  controller: _durationController,
                  decoration: DashboardField.decoration(
                    context: context,
                    label: 'Duration',
                    hint: 'e.g. 3 hours',
                    icon: Icons.timer_outlined,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaterSection() {
    return ScheduleFormSectionCard(
      title: 'Water Details',
      icon: Icons.water_outlined,
      child: TextFormField(
        controller: _instructionsController,
        minLines: 2,
        maxLines: 4,
        decoration: DashboardField.decoration(
          context: context,
          label: 'Irrigation Notes',
          hint: 'Water quantity, duration, drip line, or field instructions',
          icon: Icons.water_drop_outlined,
        ),
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return ScheduleFormSectionCard(
      title: _usesProducts ? 'Application Instructions' : 'Notes',
      icon: Icons.notes_outlined,
      child: Column(
        children: [
          if (_usesProducts) ...[
            TextFormField(
              controller: _instructionsController,
              minLines: 2,
              maxLines: 4,
              decoration: DashboardField.decoration(
                context: context,
                label: 'Instructions',
                hint: 'Mixing order, application method, safety guidance',
              ),
            ),
            const SizedBox(height: AppSpacing.smMd),
          ],
          TextFormField(
            controller: _notesController,
            minLines: 2,
            maxLines: 4,
            decoration: DashboardField.decoration(
              context: context,
              label: 'Notes (Optional)',
              hint: 'Add any reminder or comment',
            ),
          ),
        ],
      ),
    );
  }

  void _changeType(ScheduleType type) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedType = type;
      _productError = null;
      _productSearchController.clear();
      _searchResults = const [];
    });
  }

  Future<void> _changePlot(String plotId) async {
    final plots = ref.read(plotNotifierProvider).plots;
    final plot = plots.firstWhere((item) => item.id == plotId);
    setState(() {
      _selectedPlotId = plot.id;
      _selectedPlotName = plot.name;
      _selectedActivityType = ActivityType.cutting;
    });
    await _loadActivities();
  }

  void _changeActivity(ActivityType type) {
    setState(() => _selectedActivityType = type);
  }

  void _changeScheduleDate(DateTime value) {
    setState(() {
      _scheduleDate = DateTime(
        value.year,
        value.month,
        value.day,
        _scheduleDate.hour,
        _scheduleDate.minute,
      );
      if (_dueDate.isBefore(_scheduleDate)) {
        _dueDate = _scheduleDate;
      }
      final matchedActivity = _activityForDate(
        ref.read(activityNotifierProvider).activities,
        _scheduleDate,
      );
      if (matchedActivity != null) {
        _selectedActivityType = matchedActivity.type;
      }
    });
  }

  Future<void> _loadActivities() async {
    await ref.read(activityNotifierProvider.notifier).loadActivities(
          plotId: _selectedPlotId,
          plotName: _selectedPlotName,
        );
    if (!mounted) return;
    final active = ref.read(activityNotifierProvider).activeActivity;
    if (active != null) {
      setState(() => _selectedActivityType = active.type);
    }
  }

  void _searchProducts(String query, [VoidCallback? refreshSheet]) {
    _searchDebounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = const [];
      });
      refreshSheet?.call();
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;
      setState(() => _isSearching = true);
      refreshSheet?.call();
      final repository = ref.read(productRepositoryProvider);
      final result = await repository.searchProducts(keyword: query.trim());
      if (!mounted) return;
      result.fold(
        (_) => setState(() {
          _isSearching = false;
          _searchResults = const [];
        }),
        (products) => setState(() {
          _isSearching = false;
          _searchResults = products.where(_matchesSelectedType).toList();
        }),
      );
      refreshSheet?.call();
    });
  }

  bool _matchesSelectedType(ProductEntity product) {
    if (_selectedType == ScheduleType.nutrition) {
      return product.category == ProductCategory.fertilizers ||
          product.category == ProductCategory.nutrition ||
          product.category == ProductCategory.bioProducts;
    }
    return product.category != ProductCategory.fertilizers &&
        product.category != ProductCategory.nutrition;
  }

  void _addProduct(ProductEntity product) {
    if (_products.any((item) => item.productId == product.id)) {
      setState(() => _productError = 'This product is already added.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This product is already added.')),
      );
      return;
    }
    final defaultUnit =
        product.dosage.toLowerCase().contains('ml') ? 'ml' : 'gm';
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
    _openProductConfigSheet(
      ScheduleProductDraft(
        productId: product.id,
        productName: product.name,
        categoryId: product.category.value,
        categoryLabel: product.category.displayName,
        manufacturer: product.company,
        doseUnit: defaultUnit,
        sequenceNo: _products.length + 1,
      ),
    );
  }

  void _removeProduct(int index) {
    setState(() {
      final updated = [..._products]..removeAt(index);
      _products = [
        for (var i = 0; i < updated.length; i++)
          updated[i].copyWith(sequenceNo: i + 1),
      ];
    });
  }

  void _editProduct(int index) {
    FocusScope.of(context).unfocus();
    _openProductConfigSheet(_products[index], index: index);
  }

  void _openProductSearchSheet() {
    setState(() {
      _productError = null;
      _productSearchController.clear();
      _searchResults = const [];
    });
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: DashboardStyle.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => ProductSearchBottomSheet(
          controller: _productSearchController,
          results: _searchResults,
          isLoading: _isSearching,
          onChanged: (query) =>
              _searchProducts(query, () => setSheetState(() {})),
          onSelected: _addProduct,
          addedProductIds:
              _products.map((product) => product.productId).toSet(),
          focusNode: _productSearchFocusNode,
        ),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _productSearchFocusNode.requestFocus();
    });
  }

  void _openProductConfigSheet(
    ScheduleProductDraft initial, {
    int? index,
  }) {
    var draft = initial;
    var showErrors = false;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: DashboardStyle.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) => ProductConfigBottomSheet(
            draft: draft,
            showErrors: showErrors,
            onChanged: (value) => setSheetState(() => draft = value),
            onConfirm: () {
              if (!_isProductComplete(draft)) {
                setSheetState(() => showErrors = true);
                return;
              }
              setState(() {
                if (index == null) {
                  _products = [..._products, draft];
                } else {
                  final updated = [..._products];
                  updated[index] = draft;
                  _products = updated;
                }
                _productError = null;
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  bool _isProductComplete(ScheduleProductDraft product) =>
      product.dose.trim().isNotEmpty &&
      product.perWaterQuantity.trim().isNotEmpty &&
      (double.tryParse(product.dose) ?? 0) > 0 &&
      (double.tryParse(product.perWaterQuantity) ?? 0) > 0;

  Future<void> _selectScheduleDate() async {
    final plots = ref.read(plotNotifierProvider).plots;
    final selectedPlot = plots.firstWhere(
      (plot) => plot.id == _selectedPlotId,
      orElse: () => PlotEntity(
        id: _selectedPlotId,
        name: _selectedPlotName,
        area: 0,
        location: '',
        cropType: 'Grapes',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    final firstDate = _firstAllowedScheduleDate(selectedPlot.pruningDate);
    final lastDate = DateUtils.dateOnly(DateTime.now()).add(
      const Duration(days: 365),
    );
    final initialDate = _clampDate(
      DateUtils.dateOnly(_scheduleDate),
      firstDate,
      lastDate,
    );
    final value = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (value == null) return;
    _changeScheduleDate(value);
    if (!mounted) return;
    final selectedDate = DateUtils.dateOnly(value);
    final matchedActivity = _activityForDate(
      ref.read(activityNotifierProvider).activities,
      selectedDate,
    );
    if (matchedActivity != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Schedule date is within ${matchedActivity.type.displayName}. It will be linked to that activity.',
          ),
        ),
      );
    } else if (selectedDate.isBefore(DateUtils.dateOnly(DateTime.now()))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Past schedule selected. Choose the matching activity stage if needed.',
          ),
        ),
      );
    }
  }

  Future<void> _selectDueDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _dueDate.isBefore(_scheduleDate) ? _scheduleDate : _dueDate,
      firstDate: DateUtils.dateOnly(_scheduleDate),
      lastDate: _scheduleDate.add(const Duration(days: 365)),
    );
    if (value != null) {
      setState(() => _dueDate = value);
    }
  }

  Future<void> _selectTime() async {
    final value = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduleDate),
    );
    if (value != null) {
      setState(() {
        _scheduleDate = DateTime(
          _scheduleDate.year,
          _scheduleDate.month,
          _scheduleDate.day,
          value.hour,
          value.minute,
        );
      });
    }
  }

  int? _dayAfterPruning(DateTime? pruningDate) {
    if (pruningDate == null) return null;
    return DateUtils.dateOnly(_scheduleDate)
        .difference(DateUtils.dateOnly(pruningDate))
        .inDays;
  }

  DateTime _firstAllowedScheduleDate(DateTime? pruningDate) {
    final baseDate = pruningDate ?? DateTime.now();
    return DateUtils.dateOnly(baseDate).subtract(const Duration(days: 15));
  }

  DateTime _clampDate(DateTime value, DateTime firstDate, DateTime lastDate) {
    if (value.isBefore(firstDate)) return firstDate;
    if (value.isAfter(lastDate)) return lastDate;
    return value;
  }

  ActivityEntity? _activityForDate(
    List<ActivityEntity> activities,
    DateTime date,
  ) {
    final selectedDate = DateUtils.dateOnly(date);
    for (final activity in activities) {
      final start = activity.startedAt;
      if (start == null) continue;

      final end = activity.completedAt ?? DateTime.now();
      if (!selectedDate.isBefore(DateUtils.dateOnly(start)) &&
          !selectedDate.isAfter(DateUtils.dateOnly(end))) {
        return activity;
      }
    }
    return null;
  }

  String? _scheduleDateContextMessage({
    required List<ActivityEntity> activities,
    required DateTime? pruningDate,
  }) {
    final formatter = DateFormat('d MMM');
    final firstDate = _firstAllowedScheduleDate(pruningDate);
    final matchedActivity = _activityForDate(activities, _scheduleDate);
    if (matchedActivity != null) {
      final start = matchedActivity.startedAt;
      final end = matchedActivity.completedAt ?? DateTime.now();
      final range = start == null
          ? null
          : '${formatter.format(start)} - ${formatter.format(end)}';
      return range == null
          ? 'This schedule will be linked to ${matchedActivity.type.displayName}.'
          : 'This date falls inside ${matchedActivity.type.displayName} ($range), so the schedule will be linked to that activity.';
    }

    if (DateUtils.dateOnly(_scheduleDate)
        .isBefore(DateUtils.dateOnly(DateTime.now()))) {
      return 'You can backfill missing schedules from ${formatter.format(firstDate)}. Select the activity stage that matches this past schedule.';
    }

    return 'You can select dates from ${formatter.format(firstDate)} to add missed schedules around the pruning/activity window.';
  }

  Future<void> _submit() async {
    if (ref.read(scheduleNotifierProvider).isCreating) return;
    FocusScope.of(context).unfocus();
    final formValid = _formKey.currentState?.validate() ?? false;
    final productValid = !_usesProducts ||
        (_products.isNotEmpty && _products.every(_isProductComplete));

    if (_usesProducts && _products.isEmpty) {
      setState(() => _productError = 'Add at least one product');
    } else if (_usesProducts && !productValid) {
      setState(() => _productError = 'Complete dose details for every product');
    } else {
      setState(() => _productError = null);
    }

    if (!formValid || !productValid) return;

    final activityId =
        'activity_${_selectedPlotId}_${_selectedActivityType.value}';
    final request = AddScheduleRequest(
      plotId: _selectedPlotId,
      scheduleType: _selectedType,
      activityId: activityId,
      stageId: _selectedActivityType.value,
      scheduleDate: _scheduleDate,
      dueDate: _dueDate,
      totalWaterQuantity: null,
      totalWaterUnit: 'L',
      tankCount: null,
      instructions: _instructionsController.text.trim(),
      notes: _notesController.text.trim(),
      labourTeam: _labourController.text.trim(),
      estimatedDuration: _durationController.text.trim(),
      products: _usesProducts ? _products : const [],
      combinationName: _usesProducts ? _combinationName : '',
    );

    final success =
        await ref.read(scheduleNotifierProvider.notifier).createSchedule(
              plotId: request.plotId,
              plotName: _selectedPlotName,
              type: request.scheduleType,
              title: _scheduleTitle(request),
              scheduledDate: request.scheduleDate,
              description: request.legacyDescription.isEmpty
                  ? null
                  : request.legacyDescription,
              activityIds: [request.activityId],
              isCompleted: _isAlreadyApplied,
            );

    if (!mounted) return;
    if (!success) {
      final message = ref.read(scheduleNotifierProvider).errorMessage ??
          'Failed to create schedule';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_isAlreadyApplied) {
      await ref.read(activityNotifierProvider.notifier).startActivity(
            plotId: _selectedPlotId,
            type: _selectedActivityType,
          );
    }
    if (!mounted) return;
    ref.read(plotNotifierProvider.notifier).selectPlot(_selectedPlotId);
    ref.read(scheduleNotifierProvider.notifier).setFilter(ScheduleType.all);
    await ref.read(scheduleNotifierProvider.notifier).loadSchedules(
          plotId: _selectedPlotId,
          plotName: _selectedPlotName,
          filterType: ScheduleType.all,
        );
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Schedule created successfully'),
        backgroundColor:
            Theme.of(context).extension<AppSemanticColors>()!.success,
      ),
    );
  }

  String _scheduleTitle(AddScheduleRequest request) {
    if (request.scheduleType == ScheduleType.work) {
      return _workNameController.text.trim();
    }
    if (request.scheduleType == ScheduleType.water) {
      return 'Irrigation';
    }
    return request.combinationName;
  }
}

class _ScheduleStatusToggle extends StatelessWidget {
  const _ScheduleStatusToggle({
    required this.isAlreadyApplied,
    required this.onChanged,
  });

  final bool isAlreadyApplied;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pendingSegment = _StatusSegment(
      label: 'Need to Apply',
      icon: Icons.pending_actions_rounded,
      color: AppColors.warning,
      selected: !isAlreadyApplied,
      onTap: () => onChanged(false),
    );
    final appliedSegment = _StatusSegment(
      label: 'Already Applied',
      icon: Icons.verified_rounded,
      color: AppColors.success,
      selected: isAlreadyApplied,
      onTap: () => onChanged(true),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        return Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(
              compact ? AppSpacing.radiusLg : AppSpacing.radiusFull,
            ),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: compact
              ? Column(
                  children: [
                    pendingSegment,
                    const SizedBox(height: AppSpacing.xs),
                    appliedSegment,
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: pendingSegment),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: appliedSegment),
                  ],
                ),
        );
      },
    );
  }
}

class _StatusSegment extends StatelessWidget {
  const _StatusSegment({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final foregroundColor =
        selected ? Theme.of(context).colorScheme.onPrimary : cs.onSurface;
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
            horizontal: AppSpacing.smMd,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.18),
                      blurRadius: AppSpacing.md,
                      offset: const Offset(0, AppSpacing.xs),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: foregroundColor,
                size: AppSpacing.md,
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: foregroundColor,
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

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.onClose,
    required this.onSave,
  });

  final VoidCallback onClose;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Close',
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
          ),
          Expanded(
            child: Text(
              'Add Schedule',
              style: AppTypography.titleLarge(context).copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Save schedule',
            onPressed: onSave,
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
    );
  }
}

// ─── Add Product Pill ────────────────────────────────────────────────────────

class _AddProductPill extends StatelessWidget {
  const _AddProductPill({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Tooltip(
      message: 'Add Product',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: 12,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Add',
                style: AppTypography.labelLarge(context).copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Product Empty State ─────────────────────────────────────────────────────

class _ProductEmptyState extends StatelessWidget {
  const _ProductEmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onAdd,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.smMd,
        ),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                Icons.add_shopping_cart_rounded,
                size: 20,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.smMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No products added yet',
                    style: AppTypography.titleMedium(context).copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to search and add pesticide, fungicide or fertilizer',
                    style: AppTypography.bodyMedium(context).copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
