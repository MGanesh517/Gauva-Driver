import 'package:gauva_driver/core/utils/localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/utils/exit_app_dialogue.dart';
import '../../../core/utils/is_dark_mode.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/custom_phone_field.dart';
import '../../account_page/provider/select_country_provider.dart';
import '../../../core/config/country_codes.dart';
import '../provider/auth_providers.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/text_field_with_title.dart';

import '../../../core/widgets/required_title.dart';
import '../../booking/provider/geo_location_providers.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Step 1: Personal Information
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _phoneNumber = '';
  bool _obscurePassword = true;
  bool _isTermsAccepted = false;

  // Step 2: Vehicle Information
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _vehicleColorController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();

  // Step 3: License & Documents
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _aadhaarNumberController = TextEditingController();
  final TextEditingController _rcNumberController = TextEditingController();

  // Step 4: Bank Information
  final TextEditingController _accountHolderNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  final List<String> _vehicleTypes = ['BIKE', 'MEGA', 'AUTO', 'SMALL_SEDAN', 'CAR'];

  String _getBackendVehicleType(String serviceType) {
    switch (serviceType) {
      case 'BIKE':
        return 'two_wheeler';
      case 'AUTO':
        return 'three_wheeler';
      case 'CAR':
      case 'SMALL_SEDAN':
      case 'MEGA':
        return 'four_wheeler';
      default:
        return 'four_wheeler';
    }
  }

  int _currentStep = 0;
  double _latitude = 0.0;
  double _longitude = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDefaultCountry();
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final geoManager = ref.read(geoLocationManagerProvider);
      final location = await geoManager.getUserLocation();
      if (location != null) {
        setState(() {
          _latitude = location.latitude;
          _longitude = location.longitude;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _setDefaultCountry() {
    final indiaCountry = countryCodeList.firstWhere(
      (c) => c.code == 'IN',
      orElse: () => countryCodeList.firstWhere((c) => c.phoneCode == '+91', orElse: () => countryCodeList.last),
    );
    ref.read(selectedCountry.notifier).setPhoneCode(indiaCountry);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _vehicleTypeController.dispose();
    _vehicleNumberController.dispose();
    _vehicleColorController.dispose();
    _vehicleModelController.dispose();
    _licenseNumberController.dispose();
    _aadhaarNumberController.dispose();
    _rcNumberController.dispose();
    _accountHolderNameController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String? value) {
    if (value != null) {
      setState(() {
        _phoneNumber = value;
      });
    }
  }

  bool _validateStep1() {
    if (_nameController.text.trim().isEmpty) {
      showNotification(message: localize(context).enter_full_name_error);
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      showNotification(message: localize(context).enter_email_error);
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text.trim())) {
      showNotification(message: localize(context).enter_valid_email_error);
      return false;
    }
    if (_phoneNumber.trim().isEmpty) {
      showNotification(message: localize(context).enter_phone_error);
      return false;
    }
    if (_phoneNumber.trim().length < 10) {
      showNotification(message: localize(context).enter_valid_phone_error);
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(_phoneNumber.trim())) {
      showNotification(message: localize(context).phone_numeric_error);
      return false;
    }
    if (_passwordController.text.trim().isEmpty) {
      showNotification(message: localize(context).enter_password_error);
      return false;
    }
    if (_passwordController.text.trim().length < 6) {
      showNotification(message: localize(context).password_length_error);
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    if (_vehicleTypeController.text.trim().isEmpty) {
      showNotification(message: localize(context).enter_vehicle_type_error);
      return false;
    }
    if (_vehicleNumberController.text.trim().isEmpty) {
      showNotification(message: localize(context).enter_vehicle_number_error);
      return false;
    }
    if (_vehicleColorController.text.trim().isEmpty) {
      showNotification(message: localize(context).enter_vehicle_color_error);
      return false;
    }
    if (_vehicleModelController.text.trim().isEmpty) {
      showNotification(message: localize(context).enter_vehicle_model_error);
      return false;
    }
    return true;
  }

  bool _validateStep3() {
    if (_licenseNumberController.text.trim().isEmpty) {
      showNotification(message: localize(context).enter_license_number_error);
      return false;
    }
    if (_aadhaarNumberController.text.trim().isEmpty) {
      showNotification(message: localize(context).enter_aadhaar_number_error);
      return false;
    }
    if (!RegExp(r'^[0-9]{12}$').hasMatch(_aadhaarNumberController.text.trim())) {
      showNotification(message: localize(context).aadhaar_length_error);
      return false;
    }
    if (_rcNumberController.text.trim().isEmpty) {
      showNotification(message: localize(context).enter_rc_number_error);
      return false;
    }

    return true;
  }

  void _onNext() {
    if (_currentStep == 0) {
      if (_validateStep1()) {
        setState(() {
          _currentStep = 1;
        });
      }
    } else if (_currentStep == 1) {
      if (_validateStep2()) {
        setState(() {
          _currentStep = 2;
        });
      }
    } else if (_currentStep == 2) {
      if (_validateStep3()) {
        _onSubmit();
      }
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _onSubmit() {
    if (!_isTermsAccepted) {
      showNotification(message: 'Please accept Terms & Conditions and Privacy Policy to continue');
      return;
    }
    final String phoneCode = ref.read(selectedCountry).selectedPhoneCode?.phoneCode ?? '+91';
    final String phoneNumber = phoneCode + _phoneNumber.trim();

    ref
        .read(driverRegisterNotifierProvider.notifier)
        .register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          mobile: phoneNumber,
          latitude: _latitude,
          longitude: _longitude,
          vehicleType: _getBackendVehicleType(_vehicleTypeController.text.trim()),
          serviceType: _vehicleTypeController.text.trim(),
          vehicleNumber: _vehicleNumberController.text.trim(),
          vehicleColor: _vehicleColorController.text.trim(),
          vehicleModel: _vehicleModelController.text.trim(),
          licenseNumber: _licenseNumberController.text.trim(),
          aadhaarNumber: _aadhaarNumberController.text.trim(),
          rcNumber: _rcNumberController.text.trim(),
          accountHolderName: _accountHolderNameController.text.trim(),
          bankName: _bankNameController.text.trim(),
          accountNumber: _accountNumberController.text.trim(),
          ifscCode: _ifscCodeController.text.trim(),
          upiId: _upiIdController.text.trim(),
          profilePhoto: null,
          licenseFront: null,
          licenseBack: null,
          rcFront: null,
          rcBack: null,
          aadhaarFront: null,
          aadhaarBack: null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode();
    final registerState = ref.watch(driverRegisterNotifierProvider);
    final isLoading = registerState.whenOrNull(loading: () => true) ?? false;

    return ExitAppWrapper(
      child: Scaffold(
        backgroundColor: context.surface,
        resizeToAvoidBottomInset: true,
        body: AuthAppBar(
          title: 'Sign Up',

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressIndicator(isDark),
              Gap(24.h),
              Text(
                _getStepTitle(),
                style: context.bodyMedium?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF687387) : ColorPalette.neutral24,
                ),
              ),
              Gap(8.h),
              Text(
                _getStepSubtitle(),
                style: context.bodyMedium?.copyWith(
                  fontSize: 16.sp,
                  color: const Color(0xFF687387),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Gap(24.h),
              FormBuilder(key: _formKey, child: _buildCurrentStep(context, isDark)),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomButtons(isLoading),
      ),
    );
  }

  Widget _buildProgressIndicator(bool isDark) => Row(
    children: List.generate(3, (index) {
      final isActive = index <= _currentStep;
      return Expanded(
        child: Container(
          height: 4.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: isActive ? ColorPalette.primary50 : (isDark ? const Color(0xFF2A2D36) : const Color(0xFFE8EAED)),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      );
    }),
  );

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return localize(context).step_personal_info;
      case 1:
        return localize(context).step_vehicle_info;
      case 2:
        return localize(context).step_license_docs;
      default:
        return localize(context).step_create_account;
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return localize(context).step_subtitle_personal;
      case 1:
        return localize(context).step_subtitle_vehicle;
      case 2:
        return localize(context).step_subtitle_docs;
      default:
        return localize(context).step_subtitle_default;
    }
  }

  String _getButtonText() {
    if (_currentStep < 2) {
      return localize(context).next;
    }
    return localize(context).signup_action;
  }

  Widget _buildCurrentStep(BuildContext context, bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStep1(context, isDark);
      case 1:
        return _buildStep2(context, isDark);
      case 2:
        return _buildStep3(context, isDark);
      // case 3:
      //   return _buildStep4(context, isDark);
      default:
        return _buildStep1(context, isDark);
    }
  }

  Widget _buildBottomButtons(bool isLoading) => SafeArea(
    child: Container(
      color: isDarkMode() ? context.surface : Colors.white,
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_currentStep == 2) ...[
            Row(
              children: [
                Checkbox(
                  value: _isTermsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _isTermsAccepted = value ?? false;
                    });
                  },
                  activeColor: ColorPalette.primary50,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDarkMode() ? Colors.white70 : Colors.black87,
                        fontFamily: 'Inter',
                      ),
                      children: [
                        const TextSpan(text: 'I accept the '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchURL('https://www.gauvaservices.in/terms'),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchURL('https://www.gauvaservices.in/privacy-policy'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Gap(12.h),
          ],
          _currentStep > 0
              ? Row(
                  children: [
                    Expanded(
                      child: _buildButton(
                        title: localize(context).back,
                        onTap: _onBack,
                        isLoading: false,
                        isPrimary: true,
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      flex: 2,
                      child: _buildButton(
                        title: _getButtonText(),
                        onTap: _onNext,
                        isLoading: isLoading,
                        isPrimary: true,
                      ),
                    ),
                  ],
                )
              : _buildButton(title: _getButtonText(), onTap: _onNext, isLoading: isLoading, isPrimary: true),
        ],
      ),
    ),
  );

  Future<void> _launchURL(String url) async {
    print('Launching URL: $url');
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        showNotification(message: 'Could not launch $url');
      }
    }
  }

  Widget _buildButton({
    required String title,
    required VoidCallback onTap,
    required bool isLoading,
    required bool isPrimary,
  }) => Container(
    height: 48.h,
    decoration: BoxDecoration(
      gradient: (isLoading)
          ? null
          : const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF397098), Color(0xFF942FAF)],
            ),
      color: isLoading ? context.theme.colorScheme.onSurface.withValues(alpha: 0.12) : null,
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    ),
  );

  // Step 1: Personal Information
  Widget _buildStep1(BuildContext context, bool isDark) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Gap(16.h),
      _buildTextField(
        context,
        isDark,
        title: localize(context).full_name,
        controller: _nameController,
        hintText: localize(context).full_name_hint,
      ),
      Gap(16.h),
      _buildTextField(
        context,
        isDark,
        title: localize(context).email_label,
        controller: _emailController,
        hintText: localize(context).email_hint_example,
        keyboardType: TextInputType.emailAddress,
      ),
      Gap(16.h),
      Text(
        localize(context).phoneNo,
        style: context.bodyMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : const Color(0xFF24262D),
        ),
      ),
      Gap(12.h),
      AppPhoneNumberTextField(initialValue: _phoneNumber, onChanged: _onPhoneChanged, isDark: isDark),
      Gap(16.h),
      _buildTextField(
        context,
        isDark,
        title: localize(context).password_label,
        controller: _passwordController,
        hintText: localize(context).password_hint_min,
        obscureText: _obscurePassword,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: isDark ? Colors.white70 : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    ],
  );

  // Step 2: Vehicle Information
  Widget _buildStep2(BuildContext context, bool isDark) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      requiredTitle(context, title: localize(context).vehicle_type, isRequired: true),
      Gap(8.h),
      FormBuilderDropdown<String>(
        name: 'vehicleType',
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          hintText: localize(context).vehicle_type_hint,
          hintStyle: context.bodyMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF687387),
            overflow: TextOverflow.ellipsis,
          ),
          border: border(),
          enabledBorder: border(),
          focusedBorder: border(true),
        ),
        items: _vehicleTypes
            .map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : const Color(0xFF24262D),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _vehicleTypeController.text = value;
            });
          }
        },
      ),
      Gap(16.h),
      _buildTextField(
        context,
        isDark,
        title: localize(context).vehicle_plate_number,
        controller: _vehicleNumberController,
        hintText: localize(context).vehicle_number_hint,
      ),
      Gap(16.h),
      _buildTextField(
        context,
        isDark,
        title: localize(context).vehicle_color,
        controller: _vehicleColorController,
        hintText: localize(context).vehicle_color_hint,
      ),
      Gap(16.h),
      _buildTextField(
        context,
        isDark,
        title: localize(context).vehicle_model,
        controller: _vehicleModelController,
        hintText: localize(context).vehicle_model_hint,
      ),
    ],
  );

  // Step 3: License & Documents
  Widget _buildStep3(BuildContext context, bool isDark) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField(
        context,
        isDark,
        title: localize(context).license_number,
        controller: _licenseNumberController,
        hintText: localize(context).license_number_hint,
      ),
      Gap(16.h),

      Gap(16.h),
      _buildTextField(
        context,
        isDark,
        title: localize(context).aadhaar_number,
        controller: _aadhaarNumberController,
        hintText: localize(context).aadhaar_number_hint,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12)],
      ),
      Gap(16.h),

      Gap(16.h),
      _buildTextField(
        context,
        isDark,
        title: localize(context).rc_number,
        controller: _rcNumberController,
        hintText: localize(context).rc_number_hint,
      ),
      Gap(16.h),
    ],
  );

  // // Step 4: Bank Information
  // Widget _buildStep4(BuildContext context, bool isDark) => Column(
  //   children: [
  //     _buildTextField(
  //       context,
  //       isDark,
  //       title: localize(context).account_holder_name,
  //       controller: _accountHolderNameController,
  //       hintText: localize(context).account_holder_name_hint,
  //       isRequired: true,
  //     ),
  //     Gap(16.h),
  //     _buildTextField(
  //       context,
  //       isDark,
  //       title: localize(context).bank_name,
  //       controller: _bankNameController,
  //       hintText: localize(context).bank_name_hint,
  //       isRequired: true,
  //     ),
  //     Gap(16.h),
  //     _buildTextField(
  //       context,
  //       isDark,
  //       title: localize(context).account_number,
  //       controller: _accountNumberController,
  //       hintText: localize(context).account_number_hint,
  //       keyboardType: TextInputType.number,
  //       isRequired: true,
  //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //     ),
  //     Gap(16.h),
  //     _buildTextField(
  //       context,
  //       isDark,
  //       title: localize(context).ifsc_code,
  //       controller: _ifscCodeController,
  //       hintText: localize(context).ifsc_code_hint,
  //       isRequired: true,
  //       inputFormatters: [
  //         FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
  //         TextInputFormatter.withFunction(
  //           (oldValue, newValue) => TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection),
  //         ),
  //       ],
  //     ),
  //     Gap(16.h),
  //     _buildTextField(
  //       context,
  //       isDark,
  //       title: localize(context).upi_id,
  //       controller: _upiIdController,
  //       hintText: localize(context).upi_id_hint,
  //       keyboardType: TextInputType.emailAddress,
  //       isRequired: true,
  //     ),
  //   ],
  // );

  Widget _buildTextField(
    BuildContext context,
    bool isDark, {
    required String title,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    bool isRequired = true,
    List<TextInputFormatter>? inputFormatters,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      requiredTitle(context, title: title, isRequired: isRequired),
      Gap(8.h),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          hintText: hintText ?? title,
          hintStyle: context.bodyMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF687387),
          ),
          suffixIcon: suffixIcon,
          border: border(),
          enabledBorder: border(),
          focusedBorder: border(true),
        ),
      ),
    ],
  );
}
