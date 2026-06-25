import 'package:flutter/material.dart';
import '../../../../core/design_system/colors/app_colors.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../../home/domain/entities/plot_entity.dart';

class CompactPlotSelector extends StatelessWidget {
  const CompactPlotSelector({
    super.key,
    required this.plots,
    required this.selectedPlotId,
    required this.onPlotChanged,
  });

  final List<PlotEntity> plots;
  final String selectedPlotId;
  final ValueChanged<String> onPlotChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedPlotId,
      isExpanded: true,
      decoration: DashboardField.decoration(
        context: context,
        label: 'Select Plot',
        icon: Icons.agriculture_rounded,
      ),
      items: plots.map((plot) {
        return DropdownMenuItem<String>(
          value: plot.id,
          child: Text(
            plot.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onPlotChanged(value);
        }
      },
    );
  }
}
