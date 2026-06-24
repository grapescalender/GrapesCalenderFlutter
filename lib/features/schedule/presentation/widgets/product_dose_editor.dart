import 'package:flutter/material.dart';

import '../../../../core/design_system/spacing/app_spacing.dart';
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

  static const _doseUnits = ['gm', 'kg', 'ml', 'litre'];
  static const _waterUnits = ['litre'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                key: ValueKey('${product.productId}_dose'),
                initialValue: product.dose,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: DashboardField.decoration(
                  context: context,
                  label: 'Dose',
                  hint: '50',
                ).copyWith(
                  errorText: showErrors ? _numberError(product.dose) : null,
                ),
                onChanged: (value) => onChanged(product.copyWith(dose: value)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                initialValue: product.doseUnit,
                decoration: DashboardField.decoration(
                  context: context,
                  label: 'Unit',
                ),
                items: _doseUnits
                    .map(
                      (unit) =>
                          DropdownMenuItem(value: unit, child: Text(unit)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onChanged(product.copyWith(doseUnit: value));
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                key: ValueKey('${product.productId}_water'),
                initialValue: product.perWaterQuantity,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: DashboardField.decoration(
                  context: context,
                  label: 'Per Water',
                  hint: '15',
                ).copyWith(
                  errorText: showErrors
                      ? _numberError(product.perWaterQuantity)
                      : null,
                ),
                onChanged: (value) =>
                    onChanged(product.copyWith(perWaterQuantity: value)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                initialValue: product.perWaterUnit,
                decoration: DashboardField.decoration(
                  context: context,
                  label: 'Water Unit',
                ),
                items: _waterUnits
                    .map(
                      (unit) =>
                          DropdownMenuItem(value: unit, child: Text(unit)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onChanged(product.copyWith(perWaterUnit: value));
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String? _numberError(String value) {
    if (value.trim().isEmpty) return 'Required';
    if ((double.tryParse(value) ?? 0) <= 0) return 'Enter valid';
    return null;
  }
}
