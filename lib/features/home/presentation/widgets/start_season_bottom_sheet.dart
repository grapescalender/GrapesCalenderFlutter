import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/dashboard_design.dart';
import '../../domain/entities/plot_entity.dart';

class StartSeasonBottomSheet extends StatefulWidget {
  const StartSeasonBottomSheet({
    required this.plot,
    required this.onStart,
    super.key,
  });

  final PlotEntity plot;
  final void Function({
    required String seasonYear,
    required String cycle,
    required DateTime pruningDate,
  }) onStart;

  @override
  State<StartSeasonBottomSheet> createState() => _StartSeasonBottomSheetState();
}

class _StartSeasonBottomSheetState extends State<StartSeasonBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _seasonYearController;
  String _cycle = 'April Cycle';
  DateTime? _pruningDate;

  @override
  void initState() {
    super.initState();
    _seasonYearController = TextEditingController(
      text: DateTime.now().year.toString(),
    );
  }

  @override
  void dispose() {
    _seasonYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardBottomSheetFrame(
      maxHeightFactor: 0.76,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardSheetHeader(
              title: 'Start Season',
              subtitle: 'Set up the season for ${widget.plot.name}',
              icon: Icons.play_circle_outline_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            DashboardListItem(
              title: widget.plot.name,
              subtitle:
                  '${widget.plot.cropType} • ${widget.plot.area} hectares',
              icon: Icons.agriculture_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _seasonYearController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                labelText: 'Season Year',
                prefixIcon: Icon(Icons.event_note_rounded),
              ),
              validator: (value) => value == null || value.length != 4
                  ? 'Enter a valid season year'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _cycle,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Current Cycle',
                prefixIcon: Icon(Icons.repeat_rounded),
              ),
              items: const ['April Cycle', 'October Cycle']
                  .map(
                    (cycle) => DropdownMenuItem(
                      value: cycle,
                      child: Text(cycle),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _cycle = value);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              onTap: _pickPruningDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Pruning Date',
                  prefixIcon: Icon(Icons.event_available_rounded),
                ),
                child: Text(
                  _pruningDate == null
                      ? 'Select pruning date'
                      : MaterialLocalizations.of(context)
                          .formatMediumDate(_pruningDate!),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: 'Start Season',
              icon: Icons.play_arrow_rounded,
              isFullWidth: true,
              size: AppButtonSize.large,
              onPressed: _pruningDate == null ? null : _startSeason,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPruningDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _pruningDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (selected != null && mounted) {
      setState(() => _pruningDate = selected);
    }
  }

  void _startSeason() {
    if (_formKey.currentState?.validate() != true || _pruningDate == null) {
      return;
    }
    Navigator.of(context).pop();
    widget.onStart(
      seasonYear: _seasonYearController.text.trim(),
      cycle: _cycle,
      pruningDate: _pruningDate!,
    );
  }
}
