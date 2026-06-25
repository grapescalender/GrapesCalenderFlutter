import 'package:flutter/material.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../models/add_schedule_request.dart';
import 'product_dose_editor.dart';

class ProductConfigBottomSheet extends StatelessWidget {
  const ProductConfigBottomSheet({
    super.key,
    required this.draft,
    required this.showErrors,
    required this.onChanged,
    required this.onConfirm,
  });

  final ScheduleProductDraft draft;
  final bool showErrors;
  final ValueChanged<ScheduleProductDraft> onChanged;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return DashboardBottomSheetFrame(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardSheetHeader(
            title: draft.productName,
            subtitle: '${draft.categoryLabel} • ${draft.manufacturer}',
            icon: Icons.tune_rounded,
          ),
          const SizedBox(height: AppSpacing.md),
          ProductDoseEditor(
            product: draft,
            showErrors: showErrors,
            onChanged: onChanged,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.primary(
            label: 'Confirm Product',
            icon: Icons.check_rounded,
            onPressed: onConfirm,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
