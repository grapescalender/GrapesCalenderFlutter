import 'package:flutter/material.dart';

import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../models/add_schedule_request.dart';

class ProductDoseEditor extends StatelessWidget {
  const ProductDoseEditor({
    super.key,
    required this.product,
    required this.onChanged,
    this.showErrors = false,
  });

  final ScheduleProductDraft product;
  final ValueChanged<ScheduleProductDraft> onChanged;
  final bool showErrors;

  static const _doseUnits = ['ml', 'liter', 'gm', 'kg'];
  static const _waterUnits = ['liter', 'ml'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ResponsiveMeasurementRow(
          valueField: TextFormField(
            key: ValueKey('${product.productId}_dose'),
            initialValue: product.dose,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: DashboardField.decoration(
              context: context,
              label: 'Dose',
              hint: '5',
            ).copyWith(
              errorText: showErrors ? _numberError(product.dose) : null,
            ),
            onChanged: (value) => onChanged(product.copyWith(dose: value)),
          ),
          unitField: _UnitField(
            label: 'Unit',
            value: _normalizeUnit(product.doseUnit),
            onTap: () => _openUnitPicker(
              context: context,
              title: 'Dose Unit',
              units: _doseUnits,
              selectedUnit: _normalizeUnit(product.doseUnit),
              onSelected: (unit) => onChanged(product.copyWith(doseUnit: unit)),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _ResponsiveMeasurementRow(
          valueField: TextFormField(
            key: ValueKey('${product.productId}_water'),
            initialValue: product.perWaterQuantity,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: DashboardField.decoration(
              context: context,
              label: 'Water',
              hint: '1',
            ).copyWith(
              errorText:
                  showErrors ? _numberError(product.perWaterQuantity) : null,
            ),
            onChanged: (value) =>
                onChanged(product.copyWith(perWaterQuantity: value)),
          ),
          unitField: _UnitField(
            label: 'Unit',
            value: _normalizeUnit(product.perWaterUnit),
            onTap: () => _openUnitPicker(
              context: context,
              title: 'Water Unit',
              units: _waterUnits,
              selectedUnit: _normalizeUnit(product.perWaterUnit),
              onSelected: (unit) =>
                  onChanged(product.copyWith(perWaterUnit: unit)),
            ),
          ),
        ),
      ],
    );
  }

  String? _numberError(String value) {
    if (value.trim().isEmpty) return 'Required';
    if ((double.tryParse(value) ?? 0) <= 0) return 'Enter valid';
    return null;
  }

  String _normalizeUnit(String unit) => unit == 'litre' ? 'liter' : unit;

  void _openUnitPicker({
    required BuildContext context,
    required String title,
    required List<String> units,
    required String selectedUnit,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: DashboardStyle.of(context).surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusHuge),
        ),
      ),
      builder: (context) => DashboardBottomSheetFrame(
        maxHeightFactor: 0.48,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DashboardSheetHeader(
              title: title,
              subtitle: 'Select unit',
              icon: Icons.straighten_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            for (final unit in units) ...[
              DashboardListItem(
                title: unit,
                subtitle: unit == selectedUnit ? 'Selected' : 'Tap to use',
                icon: Icons.check_circle_outline_rounded,
                selected: unit == selectedUnit,
                accentColor: AppColors.primary,
                trailing: unit == selectedUnit
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  onSelected(unit);
                  Navigator.of(context).pop();
                },
              ),
              if (unit != units.last) const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResponsiveMeasurementRow extends StatelessWidget {
  const _ResponsiveMeasurementRow({
    required this.valueField,
    required this.unitField,
  });

  final Widget valueField;
  final Widget unitField;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppSpacing.xhuge * 5) {
          return Column(
            children: [
              valueField,
              const SizedBox(height: AppSpacing.sm),
              unitField,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: valueField),
            const SizedBox(width: AppSpacing.sm),
            Expanded(flex: 2, child: unitField),
          ],
        );
      },
    );
  }
}

class _UnitField extends StatelessWidget {
  const _UnitField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = DashboardStyle.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InputDecorator(
        decoration: DashboardField.decoration(
          context: context,
          label: label,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: AppTypography.bodyMedium(context).copyWith(
                  color: colors.onBackground,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
