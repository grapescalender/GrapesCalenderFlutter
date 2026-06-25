import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/theme/app_semantic_colors.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_button.dart';
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
  final _waterDurationController = TextEditingController();
  final _waterQuantityController = TextEditingController();
  final _totalSprayWaterController = TextEditingController();

  Timer? _searchDebounce;
  late String _selectedPlotId;
  late String _selectedPlotName;
  ScheduleType _selectedType = ScheduleType.spray;
  ActivityType _selectedActivityType = ActivityType.cutting;
  String? _selectedActivityId;
  DateTime _scheduleDate = DateTime.now();
  DateTime? _dueDate;
  bool _isAlreadyApplied = false;
  WaterMethod _waterMethod = WaterMethod.drip;
  WaterDurationUnit _waterDurationUnit = WaterDurationUnit.minutes;
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
    _waterDurationController.dispose();
    _waterQuantityController.dispose();
    _totalSprayWaterController.dispose();
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
                          // 1. Plot Selection and Summary Hero
                          AnimatedPlotSummaryCard(
                            plotSelector: CompactPlotSelector(
                              plots: availablePlots,
                              selectedPlotId: selectedPlot.id,
                              onPlotChanged: _changePlot,
                            ),
                            plotName: selectedPlot.name,
                            dayAfterPruning:
                                _dayAfterPruning(selectedPlot.pruningDate),
                            scheduleType: _selectedType,
                            stageName: _selectedActivityType.displayName,
                            productCount: _products.length,
                            pruningDate: selectedPlot.pruningDate,
                          ),
                          const SizedBox(height: AppSpacing.smMd),

                          // 2. Schedule Details Section
                          ScheduleDetailsForm(
                            activities: activityState.activities,
                            selectedType: _selectedType,
                            selectedActivityType: _selectedActivityType,
                            scheduleDate: _scheduleDate,
                            onTypeChanged: _changeType,
                            onActivityChanged: _changeActivity,
                            onScheduleDateTap: _selectScheduleDate,
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

                          if (_selectedType == ScheduleType.spray) ...[
                            _buildSprayWaterSection(),
                            const SizedBox(height: AppSpacing.smMd),
                          ],

                          if (_selectedType == ScheduleType.nutrition) ...[
                            _buildNutritionWaterSection(),
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
            'Is this schedule completed?',
            style: AppTypography.labelLarge(context).copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.smMd),
          _ScheduleStatusToggle(
            isAlreadyApplied: _isAlreadyApplied,
            onChanged: (value) {
              setState(() {
                _isAlreadyApplied = value;
                if (value) _dueDate = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkSection() {
    final labourField = TextFormField(
      controller: _labourController,
      decoration: DashboardField.decoration(
        context: context,
        label: 'Labour / Team',
        hint: 'e.g. 4 workers',
        icon: Icons.groups_outlined,
      ),
    );
    final durationField = TextFormField(
      controller: _durationController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: DashboardField.decoration(
        context: context,
        label: 'Duration (Hours)',
        hint: 'e.g. 4',
        icon: Icons.timer_outlined,
      ),
      validator: (value) {
        if (_selectedType != ScheduleType.work) return null;
        if (value == null || value.trim().isEmpty) return null;
        if ((double.tryParse(value) ?? 0) <= 0) {
          return 'Enter hours';
        }
        return null;
      },
    );

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
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < AppSpacing.xhuge * 5) {
                return Column(
                  children: [
                    labourField,
                    const SizedBox(height: AppSpacing.sm),
                    durationField,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: labourField),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: durationField),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWaterSection() {
    return ScheduleFormSectionCard(
      title: 'Water Details',
      icon: Icons.water_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Water Method',
            style: AppTypography.titleMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _WaterMethodSelector(
            selected: _waterMethod,
            onChanged: (value) => setState(() => _waterMethod = value),
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _waterMethod == WaterMethod.drip
                ? _WaterDurationInput(
                    key: const ValueKey('drip-duration'),
                    controller: _waterDurationController,
                    unit: _waterDurationUnit,
                    requiredFor: () =>
                        _selectedType == ScheduleType.water &&
                        _waterMethod == WaterMethod.drip,
                    onUnitChanged: (value) =>
                        setState(() => _waterDurationUnit = value),
                  )
                : TextFormField(
                    key: const ValueKey('flood-quantity'),
                    controller: _waterQuantityController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: DashboardField.decoration(
                      context: context,
                      label: 'Water Quantity (Liter)',
                      hint: 'e.g. 2000',
                      icon: Icons.opacity_rounded,
                    ),
                    validator: (value) {
                      if (_selectedType != ScheduleType.water ||
                          _waterMethod != WaterMethod.flooding) {
                        return null;
                      }
                      if ((double.tryParse(value?.trim() ?? '') ?? 0) <= 0) {
                        return 'Enter water quantity';
                      }
                      return null;
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionWaterSection() {
    return ScheduleFormSectionCard(
      title: 'Water Given During Nutrition',
      icon: Icons.water_drop_outlined,
      child: _WaterDurationInput(
        controller: _waterDurationController,
        unit: _waterDurationUnit,
        requiredFor: () => _selectedType == ScheduleType.nutrition,
        onUnitChanged: (value) => setState(() => _waterDurationUnit = value),
      ),
    );
  }

  Widget _buildSprayWaterSection() {
    return ScheduleFormSectionCard(
      title: 'Total Water Sprayed',
      icon: Icons.opacity_rounded,
      child: TextFormField(
        controller: _totalSprayWaterController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: DashboardField.decoration(
          context: context,
          label: 'Total Water (Liter)',
          hint: 'e.g. 500',
          icon: Icons.water_drop_outlined,
        ),
        validator: (value) {
          if (_selectedType != ScheduleType.spray) return null;
          if ((double.tryParse(value?.trim() ?? '') ?? 0) <= 0) {
            return 'Enter total water sprayed';
          }
          return null;
        },
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
      _selectedActivityId = null;
    });
    await _loadActivities();
  }

  void _changeActivity(ActivityType type) {
    final activities = ref.read(activityNotifierProvider).activities;
    final detectedActivity = _activityForDate(activities, _scheduleDate);
    final activity = _activityForType(
      activities,
      type,
    );
    setState(() {
      _selectedActivityType = detectedActivity?.type ?? type;
      _selectedActivityId = detectedActivity?.id ?? activity?.id;
    });
  }

  void _setScheduleDate(DateTime value, {bool syncActivity = true}) {
    setState(() {
      _scheduleDate = DateTime(
        value.year,
        value.month,
        value.day,
        _scheduleDate.hour,
        _scheduleDate.minute,
      );
      if (_dueDate != null &&
          DateUtils.dateOnly(_dueDate!).isBefore(
            DateUtils.dateOnly(_scheduleDate),
          )) {
        _dueDate = null;
      }
      if (!syncActivity) return;
      final matchedActivity = _activityForDate(
        ref.read(activityNotifierProvider).activities,
        _scheduleDate,
      );
      if (matchedActivity != null) {
        _selectedActivityType = matchedActivity.type;
        _selectedActivityId = matchedActivity.id;
      }
    });
  }

  Future<void> _loadActivities() async {
    await ref.read(activityNotifierProvider.notifier).loadActivities(
          plotId: _selectedPlotId,
          plotName: _selectedPlotName,
        );
    if (!mounted) return;
    final activityState = ref.read(activityNotifierProvider);
    final detectedActivity = _activityForDate(
      activityState.activities,
      _scheduleDate,
    );
    final activity = detectedActivity ?? activityState.activeActivity;
    if (activity != null) {
      setState(() {
        _selectedActivityType = activity.type;
        _selectedActivityId = activity.id;
      });
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
    final minimumAllowedDate =
        _firstAllowedScheduleDate(selectedPlot.pruningDate);
    final lastDate = DateUtils.dateOnly(DateTime.now()).add(
      const Duration(days: 365),
    );
    final initialDate = _clampDate(
      DateUtils.dateOnly(_scheduleDate),
      minimumAllowedDate,
      lastDate,
    );
    final value = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: lastDate,
    );
    if (value == null) return;
    if (!mounted) return;
    final selectedDate = DateUtils.dateOnly(value);
    if (selectedDate.isBefore(minimumAllowedDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can add schedules only from 15 days before the Cutting Date.',
          ),
        ),
      );
      return;
    }

    final activities = ref.read(activityNotifierProvider).activities;
    final matchedActivity = _activityForDate(
      activities,
      selectedDate,
    );
    final currentActivity = _currentActivity(activities);
    final belongsToEarlierActivity = matchedActivity != null &&
        currentActivity != null &&
        _isEarlierActivity(matchedActivity, currentActivity);

    if (belongsToEarlierActivity) {
      final confirmed = await _confirmEarlierActivityWindow(matchedActivity);
      if (!mounted) return;
      if (confirmed != true) return;
    }

    _setScheduleDate(value);
  }

  Future<bool?> _confirmEarlierActivityWindow(ActivityEntity activity) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: DashboardStyle.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      builder: (context) => DashboardBottomSheetFrame(
        maxHeightFactor: 0.44,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardSheetHeader(
              title: 'Confirm activity stage',
              subtitle: 'This schedule date falls under the '
                  "'${activity.type.displayName}' stage.",
              icon: Icons.event_repeat_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Do you want to add this schedule to the '
              '${activity.type.displayName} stage?',
              style: AppTypography.bodyMedium(context).copyWith(
                color: DashboardStyle.of(context).onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  ActivityEntity? _activityForType(
    List<ActivityEntity> activities,
    ActivityType type,
  ) {
    for (final activity in activities) {
      if (activity.type == type) return activity;
    }
    return null;
  }

  ActivityEntity? _currentActivity(List<ActivityEntity> activities) {
    for (final activity in activities) {
      if (activity.isActive) return activity;
    }
    for (final activity in activities) {
      if (activity.isPending) return activity;
    }
    return null;
  }

  bool _isEarlierActivity(
    ActivityEntity matchedActivity,
    ActivityEntity currentActivity,
  ) {
    final orderedTypes = ActivityType.orderedTypes;
    final matchedIndex = orderedTypes.indexOf(matchedActivity.type);
    final currentIndex = orderedTypes.indexOf(currentActivity.type);
    if (matchedIndex >= 0 && currentIndex >= 0) {
      return matchedIndex < currentIndex;
    }

    final matchedStart = matchedActivity.startedAt;
    final currentStart = currentActivity.startedAt;
    return matchedStart != null &&
        currentStart != null &&
        matchedStart.isBefore(currentStart);
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

    final plots = ref.read(plotNotifierProvider).plots;
    final selectedPlot =
        plots.where((plot) => plot.id == _selectedPlotId).firstOrNull;
    final minimumAllowedDate =
        _firstAllowedScheduleDate(selectedPlot?.pruningDate);
    if (DateUtils.dateOnly(_scheduleDate).isBefore(minimumAllowedDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can add schedules only from 15 days before the Cutting Date.',
          ),
        ),
      );
      return;
    }

    final detectedActivity = _activityForDate(
      ref.read(activityNotifierProvider).activities,
      _scheduleDate,
    );
    if (detectedActivity != null &&
        (_selectedActivityId != detectedActivity.id ||
            _selectedActivityType != detectedActivity.type)) {
      setState(() {
        _selectedActivityType = detectedActivity.type;
        _selectedActivityId = detectedActivity.id;
      });
    }

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

    if (!_isAlreadyApplied) {
      final dueDate = _dueDate;
      if (dueDate == null) {
        final selectedDueDate = await _showDueDatePrompt();
        if (!mounted || selectedDueDate == null) return;
        setState(() => _dueDate = selectedDueDate);
        await _submit();
        return;
      }
      if (DateUtils.dateOnly(dueDate)
          .isBefore(DateUtils.dateOnly(_scheduleDate))) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Due date cannot be before schedule date.'),
          ),
        );
        return;
      }
    }

    final activityId = detectedActivity?.id ??
        _selectedActivityId ??
        _activityForType(
          ref.read(activityNotifierProvider).activities,
          _selectedActivityType,
        )?.id ??
        'activity_${_selectedPlotId}_${_selectedActivityType.value}';
    final request = AddScheduleRequest(
      plotId: _selectedPlotId,
      scheduleType: _selectedType,
      activityId: activityId,
      stageId: (detectedActivity?.type ?? _selectedActivityType).value,
      scheduleDate: _scheduleDate,
      dueDate: _dueDate ?? _scheduleDate,
      totalWaterQuantity: _selectedType == ScheduleType.spray
          ? double.tryParse(_totalSprayWaterController.text.trim())
          : null,
      totalWaterUnit: 'Liter',
      tankCount: null,
      instructions: _selectedType == ScheduleType.water
          ? ''
          : _instructionsController.text.trim(),
      notes: _notesController.text.trim(),
      labourTeam: _labourController.text.trim(),
      estimatedDuration: _formattedWorkDuration(),
      waterMethod: _requestWaterMethod,
      durationValue: _requestDurationValue,
      durationUnit: _requestDurationUnit,
      waterQuantity: _requestWaterQuantity,
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

    var irrigationHistoryCreated = true;
    if (request.scheduleType == ScheduleType.nutrition) {
      irrigationHistoryCreated =
          await ref.read(scheduleNotifierProvider.notifier).createSchedule(
                plotId: request.plotId,
                plotName: _selectedPlotName,
                type: ScheduleType.water,
                title: WaterMethod.fertigation.displayName,
                scheduledDate: request.scheduleDate,
                description: _fertigationWaterDescription(request),
                activityIds: [request.activityId],
                isCompleted: _isAlreadyApplied,
              );
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
        content: Text(
          irrigationHistoryCreated
              ? 'Schedule created successfully'
              : 'Nutrition saved, but irrigation history could not be added.',
        ),
        backgroundColor: irrigationHistoryCreated
            ? Theme.of(context).extension<AppSemanticColors>()!.success
            : Theme.of(context).colorScheme.error,
      ),
    );
  }

  String _scheduleTitle(AddScheduleRequest request) {
    if (request.scheduleType == ScheduleType.work) {
      return _workNameController.text.trim();
    }
    if (request.scheduleType == ScheduleType.water) {
      return request.waterMethod?.displayName ?? 'Irrigation';
    }
    return request.combinationName;
  }

  String _formattedWorkDuration() {
    final value = _durationController.text.trim();
    if (value.isEmpty) return value;
    return '$value Hours';
  }

  WaterMethod? get _requestWaterMethod {
    if (_selectedType == ScheduleType.nutrition) {
      return WaterMethod.fertigation;
    }
    if (_selectedType == ScheduleType.water) return _waterMethod;
    return null;
  }

  double? get _requestDurationValue {
    if (_selectedType == ScheduleType.nutrition ||
        (_selectedType == ScheduleType.water &&
            _waterMethod == WaterMethod.drip)) {
      return double.tryParse(_waterDurationController.text.trim());
    }
    return null;
  }

  WaterDurationUnit? get _requestDurationUnit =>
      _requestDurationValue == null ? null : _waterDurationUnit;

  double? get _requestWaterQuantity => _selectedType == ScheduleType.water &&
          _waterMethod == WaterMethod.flooding
      ? double.tryParse(_waterQuantityController.text.trim())
      : null;

  String _fertigationWaterDescription(AddScheduleRequest request) {
    final duration = request.durationValue;
    final unit = request.durationUnit;
    final productNames =
        request.products.map((product) => product.productName).toList();
    final products = _naturalLanguageList(productNames);
    final durationText = duration != null && unit != null
        ? '${_formatNumber(duration)} ${_durationUnitSentence(unit, duration)}'
        : 'the recorded duration';
    final stage = request.stageId
        .split(RegExp(r'[-_\s]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
    final irrigationNote =
        'Irrigation note: On ${DateFormat('d MMM yyyy').format(request.scheduleDate)}, '
        'water was applied to $_selectedPlotName for $durationText during '
        'fertigation in the $stage stage using $products.';
    final lines = <String>[
      'Water method: ${WaterMethod.fertigation.displayName}',
      if (duration != null && unit != null)
        'Water duration: ${_formatNumber(duration)} ${unit.displayName}',
      irrigationNote,
    ];
    return lines.join('\n');
  }

  String _durationUnitSentence(WaterDurationUnit unit, double value) {
    if (value == 1) {
      return unit == WaterDurationUnit.minutes ? 'minute' : 'hour';
    }
    return unit.displayName.toLowerCase();
  }

  String _naturalLanguageList(List<String> values) {
    if (values.isEmpty) return 'the selected nutrition products';
    if (values.length == 1) return values.first;
    if (values.length == 2) return '${values.first} and ${values.last}';
    return '${values.take(values.length - 1).join(', ')}, and ${values.last}';
  }

  String _formatNumber(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  Future<DateTime?> _showDueDatePrompt() {
    final scheduleDay = DateUtils.dateOnly(_scheduleDate);
    final lastDate = scheduleDay.add(const Duration(days: 365));

    return showModalBottomSheet<DateTime>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        DateTime? selectedDate = _dueDate == null
            ? null
            : _clampDate(
                DateUtils.dateOnly(_dueDate!),
                scheduleDay,
                lastDate,
              );
        String? validationMessage;

        Future<void> selectDate(StateSetter setSheetState) async {
          final value = await showDatePicker(
            context: sheetContext,
            initialDate: selectedDate ?? scheduleDay,
            firstDate: scheduleDay,
            lastDate: lastDate,
          );
          if (value == null || !sheetContext.mounted) return;
          setSheetState(() {
            selectedDate = DateUtils.dateOnly(value);
            validationMessage = null;
          });
        }

        return StatefulBuilder(
          builder: (context, setSheetState) => DashboardBottomSheetFrame(
            maxHeightFactor: 0.52,
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.sm,
              AppSpacing.screenHorizontal,
              AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: DashboardDragHandle()),
                const SizedBox(height: AppSpacing.smMd),
                Text(
                  'Select Due Date',
                  style: AppTypography.titleLarge(context).copyWith(
                    color: DashboardStyle.of(context).onBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Choose a due date to remind you.',
                  style: AppTypography.bodyMedium(context).copyWith(
                    color: DashboardStyle.of(context).onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.smMd),
                _DueDateCard(
                  selectedDate: selectedDate,
                  onTap: () => selectDate(setSheetState),
                ),
                if (validationMessage != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _DueDateInlineError(message: validationMessage!),
                ],
                const SizedBox(height: AppSpacing.smMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton.text(
                      label: 'Cancel',
                      size: AppButtonSize.small,
                      onPressed: () => Navigator.of(sheetContext).pop(),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    AppButton.primary(
                      label: 'Save',
                      size: AppButtonSize.small,
                      onPressed: selectedDate == null
                          ? null
                          : () {
                              if (selectedDate!.isBefore(scheduleDay)) {
                                setSheetState(() {
                                  validationMessage =
                                      'Due date cannot be before schedule date.';
                                });
                                return;
                              }
                              Navigator.of(sheetContext).pop(selectedDate);
                            },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DueDateCard extends StatelessWidget {
  const _DueDateCard({
    required this.selectedDate,
    required this.onTap,
  });

  final DateTime? selectedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.smMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: colors.outline),
          ),
          child: Row(
            children: [
              Container(
                width: AppSpacing.xl,
                height: AppSpacing.xl,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  Icons.calendar_month_outlined,
                  color: colors.primary,
                  size: AppSpacing.mdLg,
                ),
              ),
              const SizedBox(width: AppSpacing.smMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due Date',
                      style: AppTypography.labelLarge(context).copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      selectedDate == null
                          ? 'Select date'
                          : DateFormat('d MMM yyyy').format(selectedDate!),
                      style: AppTypography.titleMedium(context).copyWith(
                        color: colors.onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                selectedDate == null ? 'Select Date' : 'Change Date',
                style: AppTypography.labelLarge(context).copyWith(
                  color: colors.primary,
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

class _DueDateInlineError extends StatelessWidget {
  const _DueDateInlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.error_outline_rounded,
          color: colors.error,
          size: AppSpacing.md,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            message,
            style: AppTypography.labelLarge(context).copyWith(
              color: colors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 340;
        final appliedSegment = _StatusSegment(
          label: 'Completed',
          icon: Icons.verified_rounded,
          color: AppColors.success,
          selected: isAlreadyApplied,
          compact: compact,
          onTap: () => onChanged(true),
        );
        final pendingSegment = _StatusSegment(
          label: 'Pending',
          icon: Icons.pending_actions_rounded,
          color: AppColors.warning,
          selected: !isAlreadyApplied,
          compact: compact,
          onTap: () => onChanged(false),
        );

        return Container(
          padding: EdgeInsets.all(compact ? 3 : AppSpacing.xs),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Expanded(child: appliedSegment),
              SizedBox(width: compact ? 2 : AppSpacing.xs),
              Expanded(child: pendingSegment),
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
    required this.compact,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final bool compact;
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
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? AppSpacing.xs : AppSpacing.smMd,
            vertical: compact ? 6 : AppSpacing.sm,
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
                size: compact ? 14 : AppSpacing.md,
              ),
              SizedBox(width: compact ? 3 : AppSpacing.xs),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelLarge(context).copyWith(
                    color: foregroundColor,
                    fontSize: compact ? 11 : null,
                    fontWeight: FontWeight.w600,
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

class _WaterMethodSelector extends StatelessWidget {
  const _WaterMethodSelector({
    required this.selected,
    required this.onChanged,
  });

  final WaterMethod selected;
  final ValueChanged<WaterMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<WaterMethod>(
        segments: const [
          ButtonSegment(
            value: WaterMethod.drip,
            icon: Icon(Icons.water_drop_outlined),
            label: Text('Drip'),
          ),
          ButtonSegment(
            value: WaterMethod.flooding,
            icon: Icon(Icons.waves_outlined),
            label: Text('Flooding'),
          ),
        ],
        selected: {selected},
        onSelectionChanged: (values) => onChanged(values.first),
        showSelectedIcon: false,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size(0, 52)),
          visualDensity: VisualDensity.standard,
        ),
      ),
    );
  }
}

class _WaterDurationInput extends StatelessWidget {
  const _WaterDurationInput({
    super.key,
    required this.controller,
    required this.unit,
    required this.requiredFor,
    required this.onUnitChanged,
  });

  final TextEditingController controller;
  final WaterDurationUnit unit;
  final bool Function() requiredFor;
  final ValueChanged<WaterDurationUnit> onUnitChanged;

  @override
  Widget build(BuildContext context) {
    final durationField = TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: DashboardField.decoration(
        context: context,
        label: 'Water Duration',
        hint: unit == WaterDurationUnit.minutes ? 'e.g. 30' : 'e.g. 2',
        icon: Icons.timer_outlined,
      ),
      validator: (value) {
        if (!requiredFor()) return null;
        if ((double.tryParse(value?.trim() ?? '') ?? 0) <= 0) {
          return 'Enter water duration';
        }
        return null;
      },
    );
    final unitSelector = SegmentedButton<WaterDurationUnit>(
      segments: const [
        ButtonSegment(
          value: WaterDurationUnit.minutes,
          label: Text('Minutes'),
        ),
        ButtonSegment(
          value: WaterDurationUnit.hours,
          label: Text('Hours'),
        ),
      ],
      selected: {unit},
      onSelectionChanged: (values) => onUnitChanged(values.first),
      showSelectedIcon: false,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(0, 48)),
        visualDensity: VisualDensity.standard,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 380) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              durationField,
              const SizedBox(height: AppSpacing.sm),
              unitSelector,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: durationField),
            const SizedBox(width: AppSpacing.sm),
            Flexible(child: unitSelector),
          ],
        );
      },
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
