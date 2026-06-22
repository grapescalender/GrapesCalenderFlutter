import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/router/app_router.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_typography.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/responsive_wrapper.dart';
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
  String _preferredLanguage = 'Marathi';
  String _currentCycle = 'April Cycle';
  DateTime? _pruningDate;

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
              fontWeight: FontWeight.w800,
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
              onPressed: _otpSent ? _verifyOtp : _sendOtp,
            ),
          ],
        ),
      );

  Widget _buildProfileStep() => Form(
        key: _profileFormKey,
        child: Column(
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
            _textField(_plotNameController, 'Plot Name', Icons.agriculture),
            _gap(),
            _textField(
              _areaController,
              'Area',
              Icons.square_foot_rounded,
              keyboardType: TextInputType.number,
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
            Row(
              children: [
                Expanded(
                  child: _textField(
                    _latitudeController,
                    'Latitude',
                    Icons.my_location,
                    keyboardType: TextInputType.number,
                    isRequired: false,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _textField(
                    _longitudeController,
                    'Longitude',
                    Icons.explore_outlined,
                    keyboardType: TextInputType.number,
                    isRequired: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton.secondary(
              label: 'Use Current Location',
              icon: Icons.near_me_outlined,
              isFullWidth: true,
              onPressed: _useCurrentLocation,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.primary(
              label: 'Continue',
              icon: Icons.arrow_forward_rounded,
              isFullWidth: true,
              size: AppButtonSize.large,
              onPressed: _savePlot,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.text(
              label: 'Skip Add Plot',
              isFullWidth: true,
              onPressed: _skipPlot,
            ),
          ],
        ),
      );

  Widget _buildSeasonStep(BuildContext context) => Form(
        key: _seasonFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _textField(
              _seasonYearController,
              'Season Year',
              Icons.event_note_rounded,
              keyboardType: TextInputType.number,
            ),
            _gap(),
            DropdownButtonFormField<String>(
              initialValue: _currentCycle,
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
            const SizedBox(height: AppSpacing.lg),
            _nextButton(_saveSeason, label: 'Start Season'),
          ],
        ),
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
          style: AppTypography.headlineSmall(context).copyWith(
            fontWeight: FontWeight.w800,
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

  Widget _nextButton(VoidCallback onPressed, {String label = 'Continue'}) =>
      AppButton.primary(
        label: label,
        icon: Icons.arrow_forward_rounded,
        isFullWidth: true,
        size: AppButtonSize.large,
        onPressed: onPressed,
      );

  void _sendOtp() {
    if (_mobileFormKey.currentState?.validate() != true) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _otpSent = true);
    _showMessage('OTP sent to ${_mobileController.text}');
  }

  void _verifyOtp() {
    if (_mobileFormKey.currentState?.validate() != true) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _otpVerified = true;
      _stepIndex = 1;
    });
  }

  void _resendOtp() {
    _otpController.clear();
    _showMessage('OTP resent');
  }

  void _saveProfile() {
    if (_profileFormKey.currentState?.validate() != true) {
      return;
    }
    setState(() => _stepIndex = 2);
  }

  void _savePlot() {
    if (_plotFormKey.currentState?.validate() != true) {
      return;
    }
    setState(() {
      _skippedPlot = false;
      _stepIndex = 3;
    });
  }

  void _skipPlot() {
    setState(() {
      _skippedPlot = true;
      _stepIndex = 4;
    });
  }

  void _saveSeason() {
    if (_seasonFormKey.currentState?.validate() != true) {
      return;
    }
    if (_pruningDate == null) {
      _showMessage('Select pruning date');
      return;
    }
    setState(() => _stepIndex = 4);
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
      plotName: _skippedPlot ? null : _plotNameController.text.trim(),
      area: _skippedPlot ? null : double.tryParse(_areaController.text),
      variety: _skippedPlot ? null : _varietyController.text.trim(),
      soilType: _skippedPlot ? null : _soilTypeController.text.trim(),
      rootType: _skippedPlot ? null : _rootTypeController.text.trim(),
      plantationYear:
          _skippedPlot ? null : _plantationYearController.text.trim(),
      latitude: _skippedPlot ? null : _latitudeController.text.trim(),
      longitude: _skippedPlot ? null : _longitudeController.text.trim(),
      seasonYear: _skippedPlot ? null : _seasonYearController.text.trim(),
      currentCycle: _skippedPlot ? null : _currentCycle,
      pruningDate: _skippedPlot ? null : _pruningDate,
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
          title: 'Add First Plot',
          subtitle: 'Create the first table grapes plot or skip for now.',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $currentStep of $totalSteps',
          style: AppTypography.labelLarge(context).copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        LinearProgressIndicator(
          value: currentStep / totalSteps,
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
