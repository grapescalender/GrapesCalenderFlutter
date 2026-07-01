import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../providers/plot_notifier.dart';

/// Add Plot Form Widget
/// Modal form for creating a plot in the local mock state.
class AddPlotForm extends ConsumerStatefulWidget {
  const AddPlotForm({super.key});

  @override
  ConsumerState<AddPlotForm> createState() => _AddPlotFormState();
}

class _AddPlotFormState extends ConsumerState<AddPlotForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  final _locationController = TextEditingController();
  final _cropTypeController = TextEditingController(text: 'Grapes');

  DateTime? _pruningDate;
  bool _isRunning = false;

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _locationController.dispose();
    _cropTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.screenHorizontal,
                top: AppSpacing.xs,
                right: AppSpacing.screenHorizontal,
              ),
              child: const DashboardSheetHeader(
                title: 'Add Plot',
                subtitle: 'Enter the details for your grape plot.',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard.flat(
                        child: Row(
                          children: [
                            Icon(
                              Icons.agriculture_rounded,
                              color: cs.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                _isRunning
                                    ? 'This plot will start as active'
                                    : 'Add plot details first',
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
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Plot Name',
                          hintText: 'Enter plot name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Plot name is required';
                          }
                          if (value.trim().length < 2) {
                            return 'Plot name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _cropTypeController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Crop / Variety',
                          hintText: 'Enter crop or variety',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Crop or variety is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _areaController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Area',
                                hintText: 'Hectares',
                              ),
                              validator: (value) {
                                final area =
                                    double.tryParse(value?.trim() ?? '');
                                if (area == null || area <= 0) {
                                  return 'Enter valid area';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: TextFormField(
                              controller: _locationController,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: 'Location',
                                hintText: 'Field name',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Location is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildRunningSwitch(context),
                      if (_isRunning) ...[
                        const SizedBox(height: AppSpacing.md),
                        _buildPruningDatePicker(context),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      AppButton.primary(
                        label: 'Add Plot',
                        icon: Icons.add_rounded,
                        onPressed: _handleSubmit,
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

  Widget _buildRunningSwitch(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppCard.flat(
      border: Border.all(color: cs.outline),
      child: SwitchListTile.adaptive(
        value: _isRunning,
        onChanged: (value) {
          setState(() {
            _isRunning = value;
            _pruningDate ??= value ? DateTime.now() : null;
          });
        },
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Start plot cycle',
          style: AppTypography.titleMedium(context),
        ),
        subtitle: Text(
          'Enable this if pruning has started',
          style: AppTypography.labelLarge(context).copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildPruningDatePicker(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pruningDate = _pruningDate ?? DateTime.now();

    return GestureDetector(
      onTap: () => _selectPruningDate(context),
      child: AppCard.flat(
        border: Border.all(color: cs.outline),
        child: Row(
          children: [
            Icon(
              Icons.event_available_outlined,
              color: cs.primary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pruning Date',
                    style: AppTypography.labelLarge(context).copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    DateFormat('MMM dd, yyyy').format(pruningDate),
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

  Future<void> _selectPruningDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _pruningDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );

    if (picked != null) {
      setState(() => _pruningDate = picked);
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    ref.read(plotNotifierProvider.notifier).addPlot(
          name: _nameController.text.trim(),
          area: double.parse(_areaController.text.trim()),
          location: _locationController.text.trim(),
          cropType: _cropTypeController.text.trim(),
          pruningDate: _isRunning ? _pruningDate ?? DateTime.now() : null,
          isRunning: _isRunning,
        );

    Navigator.of(context).pop();
  }
}
