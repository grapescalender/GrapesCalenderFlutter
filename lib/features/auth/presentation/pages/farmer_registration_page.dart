import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../core/error/failures.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/responsive_wrapper.dart';
import '../../data/models/farmer_profile_model.dart';
import '../../data/models/plot_registration_model.dart';
import '../../data/models/season_setup_model.dart';
import '../../domain/entities/farmer_onboarding_state.dart';
import '../providers/auth_providers.dart';

class FarmerRegistrationPage extends ConsumerStatefulWidget {
  const FarmerRegistrationPage({super.key});

  @override
  ConsumerState<FarmerRegistrationPage> createState() =>
      _FarmerRegistrationPageState();
}

class _FarmerRegistrationPageState
    extends ConsumerState<FarmerRegistrationPage> {
  final _mobileFormKey = GlobalKey<FormState>();
  final _profileFormKey = GlobalKey<FormState>();
  final _plotFormKey = GlobalKey<FormState>();
  final _seasonFormKey = GlobalKey<FormState>();

  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  final _farmerNameController = TextEditingController();
  final _villageController = TextEditingController();
  final _talukaController = TextEditingController();
  final _districtController = TextEditingController();
  final _plotNameController = TextEditingController();
  final _areaController = TextEditingController();
  final _varietyController = TextEditingController();
  final _soilTypeController = TextEditingController();
  final _rootTypeController = TextEditingController();
  final _plantationYearController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _seasonYearController = TextEditingController(
    text: DateTime.now().year.toString(),
  );

  int _stepIndex = 0;
  bool _otpSent = false;
  bool _otpVerified = false;
  bool _skippedPlot = false;
  bool _isLoading = false;
  String _preferredLanguage = 'Marathi';
  String _currentCycle = 'April Cycle';
  DateTime? _pruningDate;
  int? _userId;
  int? _farmerId;
  int? _selectedSeasonPlotId;
  int? _editingPlotIndex;
  bool _plotAddedSuccess = false;
  bool _isPlotFormVisible = true;
  int _plotSuccessGeneration = 0;
  List<int> _startedSeasonPlotIds = [];
  List<PlotRegistrationModel> _addedPlots = [];

  @override
  void initState() {
    super.initState();
    _resolveSavedOnboardingState();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    _farmerNameController.dispose();
    _villageController.dispose();
    _talukaController.dispose();
    _districtController.dispose();
    _plotNameController.dispose();
    _areaController.dispose();
    _varietyController.dispose();
    _soilTypeController.dispose();
    _rootTypeController.dispose();
    _plantationYearController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _seasonYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Farmer Registration'),
          centerTitle: false,
        ),
        body: SafeArea(
          child: ResponsiveWrapper(
            mobile: _buildContent(context),
            tablet: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: _buildContent(context),
              ),
            ),
            desktop: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: _buildContent(context),
              ),
            ),
          ),
        ),
      );

  Widget _buildContent(BuildContext context) {
    final step = _steps[_stepIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepProgress(
            currentStep: _stepIndex + 1,
            totalSteps: _steps.length,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            step.title,
            style: AppTypography.headlineMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            step.subtitle,
            style: AppTypography.bodyMedium(context).copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard.defaultStyle(child: _buildStepBody(context)),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildStepBody(BuildContext context) {
    switch (_stepIndex) {
      case 0:
        return _buildMobileStep(context);
      case 1:
        return _buildProfileStep();
      case 2:
        return _buildPlotStep(context);
      case 3:
        return _buildSeasonStep(context);
      default:
        return _buildSuccessStep(context);
    }
  }

  Widget _buildMobileStep(BuildContext context) => Form(
        key: _mobileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                hintText: 'Enter 10 digit mobile number',
                prefixIcon: Icon(Icons.phone_android_rounded),
              ),
              validator: (value) => value == null || value.length != 10
                  ? 'Enter 10 digits'
                  : null,
              enabled: !_otpVerified,
            ),
            if (_otpSent) ...[
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter OTP',
                  prefixIcon: Icon(Icons.sms_outlined),
                ),
                validator: (value) =>
                    value == null || value.length < 4 ? 'Enter the OTP' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resendOtp,
                  child: const Text('Resend OTP'),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: _otpSent ? 'Verify OTP' : 'Send OTP',
              icon: _otpSent ? Icons.verified_outlined : Icons.send_rounded,
              isFullWidth: true,
              size: AppButtonSize.large,
              isLoading: _isLoading,
              onPressed: _otpSent ? _verifyOtp : _sendOtp,
            ),
          ],
        ),
      );

  Widget _buildProfileStep() => Form(
        key: _profileFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _textField(_farmerNameController, 'Farmer Name', Icons.person),
            _gap(),
            _textField(_villageController, 'Village', Icons.home_work_outlined),
            _gap(),
            _textField(_talukaController, 'Taluka', Icons.map_outlined),
            _gap(),
            _textField(_districtController, 'District', Icons.location_city),
            _gap(),
            DropdownButtonFormField<String>(
              initialValue: _preferredLanguage,
              isExpanded: true,
              menuMaxHeight: 320,
              decoration: const InputDecoration(
                labelText: 'Preferred Language',
                prefixIcon: Icon(Icons.language_rounded),
              ),
              items: const ['Marathi', 'Hindi', 'English']
                  .map((language) => DropdownMenuItem(
                        value: language,
                        child: Text(language),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _preferredLanguage = value);
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            _nextButton(_saveProfile),
          ],
        ),
      );

  Widget _buildPlotStep(BuildContext context) => Form(
        key: _plotFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_addedPlots.isNotEmpty) ...[
              _buildAddedPlots(context),
              const SizedBox(height: AppSpacing.md),
            ],
            if (_plotAddedSuccess) ...[
              _buildPlotSuccessMessage(context),
              const SizedBox(height: AppSpacing.md),
            ],
            if (_isPlotFormVisible) ...[
              _buildPlotFormFields(context),
              const SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                label: _editingPlotIndex == null ? 'Save Plot' : 'Update Plot',
                icon: Icons.save_outlined,
                isFullWidth: true,
                size: AppButtonSize.large,
                isLoading: _isLoading,
                onPressed: _savePlot,
              ),
              if (_addedPlots.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: _cancelPlotForm,
                  child: const Text('Cancel'),
                ),
              ],
            ] else if (_addedPlots.isNotEmpty) ...[
              AppButton.primary(
                label: 'Continue to Season',
                icon: Icons.arrow_forward_rounded,
                isFullWidth: true,
                size: AppButtonSize.large,
                onPressed: _continueToSeasonSetup,
              ),
            ],
          ],
        ),
      );

  Widget _buildPlotFormFields(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _textField(_plotNameController, 'Plot Name', Icons.agriculture),
          _gap(),
          _textField(
            _areaController,
            'Area',
            Icons.square_foot_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          _gap(),
          _textField(_varietyController, 'Variety', Icons.grass_rounded),
          _gap(),
          _textField(_soilTypeController, 'Soil Type', Icons.terrain_rounded),
          _gap(),
          _textField(_rootTypeController, 'Root Type', Icons.account_tree),
          _gap(),
          _textField(
            _plantationYearController,
            'Plantation Year',
            Icons.calendar_today_outlined,
            keyboardType: TextInputType.number,
          ),
          _gap(),
          LayoutBuilder(
            builder: (context, constraints) {
              final latitudeField = _textField(
                _latitudeController,
                'Latitude',
                Icons.my_location,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                isRequired: false,
              );
              final longitudeField = _textField(
                _longitudeController,
                'Longitude',
                Icons.explore_outlined,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                isRequired: false,
              );

              if (constraints.maxWidth < 360) {
                return Column(
                  children: [
                    latitudeField,
                    const SizedBox(height: AppSpacing.md),
                    longitudeField,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: latitudeField),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: longitudeField),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.secondary(
            label: 'Use Current Location',
            icon: Icons.near_me_outlined,
            isFullWidth: true,
            onPressed: _useCurrentLocation,
          ),
          if (_latitudeController.text.isEmpty ||
              _longitudeController.text.isEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Location helps with market and distance-based analysis.',
              style: AppTypography.labelLarge(context).copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      );

  Widget _buildSeasonStep(BuildContext context) => Form(
        key: _seasonFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_startedSeasonPlotIds.isNotEmpty) ...[
              _buildStartedSeasonPlots(context),
              const SizedBox(height: AppSpacing.md),
            ],
            DropdownButtonFormField<int>(
              initialValue: _selectedSeasonPlotId ??
                  (_addedPlots.isNotEmpty ? _addedPlots.first.plotId : null),
              isExpanded: true,
              menuMaxHeight: 320,
              decoration: const InputDecoration(
                labelText: 'Select Plot for Season',
                prefixIcon: Icon(Icons.agriculture_rounded),
              ),
              items: _addedPlots
                  .where((plot) => plot.plotId != null)
                  .map((plot) => DropdownMenuItem(
                        value: plot.plotId,
                        child: Text(plot.plotName ?? 'Grape Plot'),
                      ))
                  .toList(),
              validator: (value) =>
                  value == null ? 'Select a plot for season' : null,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedSeasonPlotId = value);
                }
              },
            ),
            _gap(),
            _textField(
              _seasonYearController,
              'Season Year',
              Icons.event_note_rounded,
              keyboardType: TextInputType.number,
            ),
            _gap(),
            DropdownButtonFormField<String>(
              initialValue: _currentCycle,
              isExpanded: true,
              menuMaxHeight: 320,
              decoration: const InputDecoration(
                labelText: 'Current Cycle',
                prefixIcon: Icon(Icons.repeat_rounded),
              ),
              items: const ['April Cycle', 'October Cycle']
                  .map((cycle) => DropdownMenuItem(
                        value: cycle,
                        child: Text(cycle),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _currentCycle = value);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              onTap: () => _pickPruningDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Pruning Date',
                  prefixIcon: Icon(Icons.event_available_rounded),
                ),
                child: Text(
                  _pruningDate == null
                      ? 'Select pruning date'
                      : _formatDate(_pruningDate!),
                ),
              ),
            ),
            if (!_allPlotsHaveSeason) ...[
              const SizedBox(height: AppSpacing.lg),
              _nextButton(
                _saveSeason,
                label: _startedSeasonPlotIds.isEmpty
                    ? 'Start Season'
                    : 'Start Season for Next Plot',
              ),
            ],
            if (_startedSeasonPlotIds.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              AppButton.primary(
                label: 'Go to Dashboard',
                icon: Icons.dashboard_rounded,
                isFullWidth: true,
                size: AppButtonSize.large,
                onPressed: _finishRegistration,
              ),
            ],
          ],
        ),
      );

  bool get _allPlotsHaveSeason =>
      _addedPlots.isNotEmpty &&
      _addedPlots.every(
        (plot) => _startedSeasonPlotIds.contains(plot.plotId),
      );

  Widget _buildSuccessStep(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(Icons.check_circle_rounded, size: 72, color: cs.primary),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Ready to manage your farm',
          style: AppTypography.titleLarge(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        const _SuccessRow(label: 'Farmer profile created'),
        _SuccessRow(
          label: _skippedPlot ? 'First plot skipped' : 'First plot added',
        ),
        _SuccessRow(
          label:
              _skippedPlot ? 'Season can start after plot' : 'Season started',
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          label: 'Go to Dashboard',
          icon: Icons.dashboard_rounded,
          isFullWidth: true,
          size: AppButtonSize.large,
          onPressed: _finishRegistration,
        ),
      ],
    );
  }

  Widget _buildAddedPlots(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Added Plots: ${_addedPlots.length}',
                style: AppTypography.labelLarge(context).copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (!_isPlotFormVisible)
              FilledButton.tonalIcon(
                onPressed: _openNewPlotForm,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Plot'),
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ..._addedPlots.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.smMd),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: cs.outline),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.value.plotName ?? 'Grape Plot',
                              style: AppTypography.labelLarge(context)
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '${entry.value.variety ?? 'Variety'} • ${entry.value.area ?? 0} acres',
                              style: AppTypography.labelLarge(context).copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Edit plot',
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _editPlot(entry.key),
                      ),
                      IconButton(
                        tooltip: 'Delete plot',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deletePlot(entry.key),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildPlotSuccessMessage(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: cs.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Plot added successfully',
              style: AppTypography.bodyMedium(context).copyWith(
                color: cs.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartedSeasonPlots(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final startedPlots = _addedPlots
        .where((plot) => _startedSeasonPlotIds.contains(plot.plotId))
        .toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.smMd),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: cs.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Season Started: ${startedPlots.length}',
            style: AppTypography.labelLarge(context).copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...startedPlots.map(
            (plot) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: cs.primary, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      plot.plotName ?? 'Grape Plot',
                      style: AppTypography.bodyMedium(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
    bool isRequired = true,
  }) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        validator: isRequired
            ? (value) => value == null || value.trim().isEmpty
                ? '$label is required'
                : null
            : null,
      );

  Widget _gap() => const SizedBox(height: AppSpacing.md);

  Widget _nextButton(
    Future<void> Function() onPressed, {
    String label = 'Continue',
  }) =>
      AppButton.primary(
        label: label,
        icon: Icons.arrow_forward_rounded,
        isFullWidth: true,
        size: AppButtonSize.large,
        isLoading: _isLoading,
        onPressed: () => onPressed(),
      );

  Future<void> _resolveSavedOnboardingState() async {
    final repository =
        await ref.read(farmerRegistrationRepositoryProvider.future);
    final localDataSource = await ref.read(authLocalDataSourceProvider.future);
    final result = await repository.getOnboardingState();

    result.fold(
      (failure) => _showMessage(_failureMessage(failure)),
      (state) async {
        _userId = int.tryParse(await localDataSource.getUserId() ?? '');
        _farmerId = int.tryParse(await localDataSource.getFarmerId() ?? '');
        if (_farmerId != null) {
          final plotsResult = await repository.getPlots(farmerId: _farmerId!);
          plotsResult.fold(
            (_) {},
            (plots) {
              _addedPlots = plots;
              _selectedSeasonPlotId =
                  plots.isNotEmpty ? plots.first.plotId : null;
            },
          );
        }

        if (!mounted) {
          return;
        }
        if (state == FarmerOnboardingState.completed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.go(AppRoutes.home);
            }
          });
          return;
        }

        setState(() {
          _otpVerified = state != FarmerOnboardingState.mobileNotVerified;
          _otpSent = _otpVerified;
          _stepIndex = _stepIndexForState(state);
          _isPlotFormVisible = _addedPlots.isEmpty;
        });
      },
    );
  }

  Future<void> _sendOtp() async {
    if (_mobileFormKey.currentState?.validate() != true) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    final repository =
        await ref.read(farmerRegistrationRepositoryProvider.future);
    final result = await repository.sendOtp(
      mobileNumber: _mobileController.text,
    );

    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
    result.fold(
      (failure) => _showMessage(_failureMessage(failure)),
      (response) {
        setState(() => _otpSent = true);
        _showMessage(response.message ?? 'OTP sent successfully');
      },
    );
  }

  Future<void> _verifyOtp() async {
    if (_mobileFormKey.currentState?.validate() != true) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    final repository =
        await ref.read(farmerRegistrationRepositoryProvider.future);
    final result = await repository.verifyOtp(
      mobileNumber: _mobileController.text,
      otp: _otpController.text,
    );

    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
    result.fold(
      (failure) => _showMessage(_failureMessage(failure)),
      (response) {
        _userId = response.userId;
        final state = response.isProfileCompleted == true
            ? FarmerOnboardingState.plotPending
            : FarmerOnboardingState.profilePending;
        setState(() {
          _otpVerified = true;
          _stepIndex = _stepIndexForState(state);
        });
      },
    );
  }

  void _resendOtp() {
    _otpController.clear();
    _showMessage('OTP resent');
  }

  Future<void> _saveProfile() async {
    if (_profileFormKey.currentState?.validate() != true) {
      return;
    }
    setState(() => _isLoading = true);

    final repository =
        await ref.read(farmerRegistrationRepositoryProvider.future);
    final result = await repository.createFarmerProfile(
      FarmerProfileModel.request(
        userId: _userId ?? 101,
        farmerName: _farmerNameController.text.trim(),
        village: _villageController.text.trim(),
        taluka: _talukaController.text.trim(),
        district: _districtController.text.trim(),
        preferredLanguage: _preferredLanguage,
      ),
    );

    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
    result.fold(
      (failure) => _showMessage(_failureMessage(failure)),
      (response) {
        _farmerId = response.farmerId;
        setState(() => _stepIndex = _stepIndexForState(
              FarmerOnboardingState.plotPending,
            ));
      },
    );
  }

  Future<void> _savePlot() async {
    if (_plotFormKey.currentState?.validate() != true) {
      return;
    }
    final area = double.tryParse(_areaController.text);
    if (area == null || area <= 0) {
      _showMessage('Area must be greater than 0');
      return;
    }
    setState(() => _isLoading = true);

    final repository =
        await ref.read(farmerRegistrationRepositoryProvider.future);
    final request = PlotRegistrationModel.request(
      plotName: _plotNameController.text.trim(),
      area: area,
      variety: _varietyController.text.trim(),
      soilType: _soilTypeController.text.trim(),
      rootType: _rootTypeController.text.trim(),
      plantationYear: int.tryParse(_plantationYearController.text),
      latitude: double.tryParse(_latitudeController.text),
      longitude: double.tryParse(_longitudeController.text),
    );

    if (_editingPlotIndex != null) {
      final existing = _addedPlots[_editingPlotIndex!];
      final updatedPlot = PlotRegistrationModel(
        plotId: existing.plotId,
        plotName: request.plotName,
        area: request.area,
        variety: request.variety,
        soilType: request.soilType,
        rootType: request.rootType,
        plantationYear: request.plantationYear,
        latitude: request.latitude,
        longitude: request.longitude,
        success: true,
      );
      setState(() {
        _addedPlots = [
          ..._addedPlots.take(_editingPlotIndex!),
          updatedPlot,
          ..._addedPlots.skip(_editingPlotIndex! + 1),
        ];
        _editingPlotIndex = null;
        _isPlotFormVisible = false;
        _isLoading = false;
      });
      _resetPlotFormControllers();
      _showPlotSuccess();
      return;
    }

    final result = await repository.addPlot(
      farmerId: _farmerId ?? 501,
      request: request,
    );

    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
    result.fold(
      (failure) => _showMessage(_failureMessage(failure)),
      (response) {
        setState(() {
          _skippedPlot = false;
          _isPlotFormVisible = false;
          final savedPlot = PlotRegistrationModel(
            plotId: response.plotId,
            plotName: request.plotName,
            area: request.area,
            variety: request.variety,
            soilType: request.soilType,
            rootType: request.rootType,
            plantationYear: request.plantationYear,
            latitude: request.latitude,
            longitude: request.longitude,
            success: true,
          );
          _addedPlots = [..._addedPlots, savedPlot];
          _selectedSeasonPlotId ??= response.plotId;
        });
        _resetPlotFormControllers();
        _showPlotSuccess();
      },
    );
  }

  Future<void> _continueToSeasonSetup() async {
    if (_addedPlots.isEmpty) {
      _showMessage('Add at least one plot before continuing');
      return;
    }
    final repository =
        await ref.read(farmerRegistrationRepositoryProvider.future);
    final result = await repository.continueToSeasonSetup();
    result.fold(
      (failure) => _showMessage(_failureMessage(failure)),
      (_) => setState(() {
        _selectedSeasonPlotId ??= _addedPlots.first.plotId;
        _stepIndex = _stepIndexForState(FarmerOnboardingState.seasonPending);
      }),
    );
  }

  void _resetPlotFormControllers() {
    _plotNameController.clear();
    _areaController.clear();
    _varietyController.clear();
    _soilTypeController.clear();
    _rootTypeController.clear();
    _plantationYearController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
  }

  void _openNewPlotForm() {
    _resetPlotFormControllers();
    setState(() {
      _editingPlotIndex = null;
      _plotAddedSuccess = false;
      _isPlotFormVisible = true;
    });
  }

  void _cancelPlotForm() {
    _resetPlotFormControllers();
    setState(() {
      _editingPlotIndex = null;
      _plotAddedSuccess = false;
      _isPlotFormVisible = _addedPlots.isEmpty;
    });
  }

  void _showPlotSuccess() {
    final generation = ++_plotSuccessGeneration;
    setState(() => _plotAddedSuccess = true);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted || generation != _plotSuccessGeneration) return;
      setState(() => _plotAddedSuccess = false);
    });
  }

  void _editPlot(int index) {
    final plot = _addedPlots[index];
    _plotNameController.text = plot.plotName ?? '';
    _areaController.text = plot.area?.toString() ?? '';
    _varietyController.text = plot.variety ?? '';
    _soilTypeController.text = plot.soilType ?? '';
    _rootTypeController.text = plot.rootType ?? '';
    _plantationYearController.text = plot.plantationYear?.toString() ?? '';
    _latitudeController.text = plot.latitude?.toString() ?? '';
    _longitudeController.text = plot.longitude?.toString() ?? '';
    setState(() {
      _editingPlotIndex = index;
      _plotAddedSuccess = false;
      _isPlotFormVisible = true;
    });
  }

  void _deletePlot(int index) {
    final removedPlot = _addedPlots[index];
    setState(() {
      _addedPlots = [
        ..._addedPlots.take(index),
        ..._addedPlots.skip(index + 1),
      ];
      if (_selectedSeasonPlotId == removedPlot.plotId) {
        _selectedSeasonPlotId =
            _addedPlots.isNotEmpty ? _addedPlots.first.plotId : null;
      }
      _plotAddedSuccess = false;
      _isPlotFormVisible = _addedPlots.isEmpty;
    });
  }

  Future<void> _saveSeason() async {
    if (_seasonFormKey.currentState?.validate() != true) {
      return;
    }
    if (_pruningDate == null) {
      _showMessage('Select pruning date');
      return;
    }
    if (_selectedSeasonPlotId == null) {
      _showMessage('Select a plot for season');
      return;
    }
    setState(() => _isLoading = true);

    final repository =
        await ref.read(farmerRegistrationRepositoryProvider.future);
    final result = await repository.startSeason(
      plotId: _selectedSeasonPlotId!,
      request: SeasonSetupModel.request(
        seasonYear: _seasonYearController.text.trim(),
        currentCycle: _cycleApiValue(_currentCycle),
        pruningDate: _formatApiDate(_pruningDate!),
      ),
    );

    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
    result.fold(
      (failure) => _showMessage(_failureMessage(failure)),
      (_) {
        setState(() {
          if (!_startedSeasonPlotIds.contains(_selectedSeasonPlotId)) {
            _startedSeasonPlotIds = [
              ..._startedSeasonPlotIds,
              _selectedSeasonPlotId!,
            ];
          }
          final remainingPlots = _addedPlots
              .where((plot) => !_startedSeasonPlotIds.contains(plot.plotId))
              .toList();
          if (remainingPlots.isNotEmpty) {
            _selectedSeasonPlotId = remainingPlots.first.plotId;
          }
        });
        _showMessage('Season started for selected plot');
      },
    );
  }

  Future<void> _pickPruningDate(BuildContext context) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _pruningDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (pickedDate != null) {
      setState(() => _pruningDate = pickedDate);
    }
  }

  void _useCurrentLocation() {
    _latitudeController.text = '19.9975';
    _longitudeController.text = '73.7898';
    _showMessage('Current location added');
  }

  void _finishRegistration() {
    ref.read(farmerOnboardingDataProvider.notifier).state =
        FarmerOnboardingData(
      mobileNumber: _mobileController.text,
      farmerName: _farmerNameController.text.trim(),
      village: _villageController.text.trim(),
      taluka: _talukaController.text.trim(),
      district: _districtController.text.trim(),
      preferredLanguage: _preferredLanguage,
      plotName: _addedPlots.isNotEmpty ? _addedPlots.first.plotName : null,
      area: _addedPlots.isNotEmpty ? _addedPlots.first.area : null,
      variety: _addedPlots.isNotEmpty ? _addedPlots.first.variety : null,
      soilType: _addedPlots.isNotEmpty ? _addedPlots.first.soilType : null,
      rootType: _addedPlots.isNotEmpty ? _addedPlots.first.rootType : null,
      plantationYear: _addedPlots.isNotEmpty
          ? _addedPlots.first.plantationYear?.toString()
          : null,
      latitude: _addedPlots.isNotEmpty
          ? _addedPlots.first.latitude?.toString()
          : null,
      longitude: _addedPlots.isNotEmpty
          ? _addedPlots.first.longitude?.toString()
          : null,
      seasonYear: _skippedPlot ? null : _seasonYearController.text.trim(),
      currentCycle: _skippedPlot ? null : _currentCycle,
      pruningDate: _skippedPlot ? null : _pruningDate,
      plots: _addedPlots,
      selectedSeasonPlotId: _selectedSeasonPlotId,
      startedSeasonPlotIds: _startedSeasonPlotIds,
    );

    ref.read(authNotifierProvider.notifier).completeFarmerRegistration(
          mobileNumber: _mobileController.text,
          farmerName: _farmerNameController.text.trim(),
          hasPlot: !_skippedPlot,
        );
    context.go(AppRoutes.home);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  String _formatApiDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _cycleApiValue(String cycle) =>
      cycle == 'October Cycle' ? 'OCTOBER' : 'APRIL';

  int _stepIndexForState(FarmerOnboardingState state) {
    switch (state) {
      case FarmerOnboardingState.mobileNotVerified:
        return 0;
      case FarmerOnboardingState.profilePending:
        return 1;
      case FarmerOnboardingState.plotPending:
        return 2;
      case FarmerOnboardingState.seasonPending:
        return 3;
      case FarmerOnboardingState.completed:
        return 4;
    }
  }

  String _failureMessage(Failure failure) => failure.when(
        network: (message, _) => message,
        server: (message, _) => message,
        cache: (message) => message,
        authentication: (message) => message,
        authorization: (message) => message,
        validation: (message, _) => message,
        unknown: (message, _) => message,
      );

  List<_RegistrationStep> get _steps => const [
        _RegistrationStep(
          title: 'Mobile Number Login',
          subtitle: 'Verify the farmer mobile number with OTP.',
        ),
        _RegistrationStep(
          title: 'Farmer Basic Profile',
          subtitle: 'Add only the details needed to start.',
        ),
        _RegistrationStep(
          title: 'Add your grape plots',
          subtitle:
              'You can add one or more plots now. More plots can be added later.',
        ),
        _RegistrationStep(
          title: 'Start Season',
          subtitle: 'Select cycle and pruning date for this season.',
        ),
        _RegistrationStep(
          title: 'Success',
          subtitle: 'The farmer account is ready.',
        ),
      ];
}

class _RegistrationStep {
  const _RegistrationStep({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final labels = currentStep == 1
        ? const ['Mobile']
        : const ['Profile', 'Plots', 'Season', 'Done'];
    final activeIndex = currentStep == 1 ? 0 : (currentStep - 2).clamp(0, 3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          currentStep == 1 ? 'Mobile verification' : labels.join(' → '),
          style: AppTypography.labelLarge(context).copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        LinearProgressIndicator(
          value: currentStep == 1 ? 0.15 : (activeIndex + 1) / labels.length,
          minHeight: 8,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ],
    );
  }
}

class _SuccessRow extends StatelessWidget {
  const _SuccessRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(Icons.check_rounded, color: cs.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
