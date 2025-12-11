import 'dart:io';
import 'package:flutter/material.dart';
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
import '../widgets/image_picker_form_field.dart';
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
  File? _profilePhoto;

  // Step 2: Vehicle Information
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _vehicleColorController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  File? _rcFront;
  File? _rcBack;

  // Step 3: License & Documents
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _aadhaarNumberController = TextEditingController();
  final TextEditingController _rcNumberController = TextEditingController();
  File? _licenseFront;
  File? _licenseBack;
  File? _aadhaarFront;
  File? _aadhaarBack;

  // Step 4: Bank Information
  final TextEditingController _accountHolderNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  final List<String> _vehicleTypes = ['CAR', 'XL', 'SUV', 'BIG_CAR', 'AUTO'];

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
      showNotification(message: 'Please enter your full name');
      return false;
    }
    if (_emailController.text.trim().isEmpty) {
      showNotification(message: 'Please enter your email');
      return false;
    }
    if (!_emailController.text.trim().contains('@')) {
      showNotification(message: 'Please enter a valid email');
      return false;
    }
    if (_phoneNumber.trim().isEmpty) {
      showNotification(message: 'Please enter phone number');
      return false;
    }
    if (_passwordController.text.trim().isEmpty) {
      showNotification(message: 'Please enter password');
      return false;
    }
    if (_passwordController.text.trim().length < 6) {
      showNotification(message: 'Password must be at least 6 characters');
      return false;
    }
    return true;
  }

  bool _validateStep2() {
    if (_vehicleTypeController.text.trim().isEmpty) {
      showNotification(message: 'Please enter vehicle type');
      return false;
    }
    if (_vehicleNumberController.text.trim().isEmpty) {
      showNotification(message: 'Please enter vehicle number');
      return false;
    }
    if (_vehicleColorController.text.trim().isEmpty) {
      showNotification(message: 'Please enter vehicle color');
      return false;
    }
    if (_vehicleModelController.text.trim().isEmpty) {
      showNotification(message: 'Please enter vehicle model');
      return false;
    }
    return true;
  }

  bool _validateStep3() {
    if (_licenseNumberController.text.trim().isEmpty) {
      showNotification(message: 'Please enter license number');
      return false;
    }
    if (_aadhaarNumberController.text.trim().isEmpty) {
      showNotification(message: 'Please enter Aadhaar number');
      return false;
    }
    if (_rcNumberController.text.trim().isEmpty) {
      showNotification(message: 'Please enter RC number');
      return false;
    }
    if (_licenseFront == null) {
      showNotification(message: 'Please upload license front photo');
      return false;
    }
    if (_licenseBack == null) {
      showNotification(message: 'Please upload license back photo');
      return false;
    }
    if (_rcFront == null) {
      showNotification(message: 'Please upload RC front photo');
      return false;
    }
    if (_rcBack == null) {
      showNotification(message: 'Please upload RC back photo');
      return false;
    }
    if (_aadhaarFront == null) {
      showNotification(message: 'Please upload Aadhaar front photo');
      return false;
    }
    if (_aadhaarBack == null) {
      showNotification(message: 'Please upload Aadhaar back photo');
      return false;
    }
    return true;
  }

  bool _validateStep4() {
    // Bank details are optional, so no validation needed
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
        setState(() {
          _currentStep = 3;
        });
      }
    } else if (_currentStep == 3) {
      if (_validateStep4()) {
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
          vehicleType: _vehicleTypeController.text.trim(),
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
          profilePhoto: _profilePhoto,
          licenseFront: _licenseFront,
          licenseBack: _licenseBack,
          rcFront: _rcFront,
          rcBack: _rcBack,
          aadhaarFront: _aadhaarFront,
          aadhaarBack: _aadhaarBack,
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

  Widget _buildProgressIndicator(bool isDark) {
    return Row(
      children: List.generate(4, (index) {
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
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Personal Information';
      case 1:
        return 'Vehicle Information';
      case 2:
        return 'License & Documents';
      case 3:
        return 'Bank Details';
      default:
        return 'Create Account';
    }
  }

  String _getStepSubtitle() {
    switch (_currentStep) {
      case 0:
        return 'Enter your basic details';
      case 1:
        return 'Tell us about your vehicle';
      case 2:
        return 'Upload required documents';
      case 3:
        return 'Bank account details (Optional)';
      default:
        return 'Fill in your details to get started';
    }
  }

  String _getButtonText() {
    if (_currentStep < 3) {
      return 'Next';
    }
    return 'Sign Up';
  }

  Widget _buildCurrentStep(BuildContext context, bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStep1(context, isDark);
      case 1:
        return _buildStep2(context, isDark);
      case 2:
        return _buildStep3(context, isDark);
      case 3:
        return _buildStep4(context, isDark);
      default:
        return _buildStep1(context, isDark);
    }
  }

  Widget _buildBottomButtons(bool isLoading) {
    return SafeArea(
      child: Container(
        color: isDarkMode() ? context.surface : Colors.white,
        padding: EdgeInsets.all(16.r),
        child: _currentStep > 0
            ? Row(
                children: [
                  Expanded(
                    child: _buildButton(title: 'Back', onTap: _onBack, isLoading: false, isPrimary: true),
                  ),
                  Gap(12.w),
                  Expanded(
                    flex: 2,
                    child: _buildButton(title: _getButtonText(), onTap: _onNext, isLoading: isLoading, isPrimary: true),
                  ),
                ],
              )
            : _buildButton(title: _getButtonText(), onTap: _onNext, isLoading: isLoading, isPrimary: true),
      ),
    );
  }

  Widget _buildButton({
    required String title,
    required VoidCallback onTap,
    required bool isLoading,
    required bool isPrimary,
  }) {
    return Container(
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
                    child: CircularProgressIndicator(
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
  }

  // Step 1: Personal Information
  Widget _buildStep1(BuildContext context, bool isDark) {
    return Column(
      children: [
        imagePickerFormField(
          context: context,
          name: 'profilePhoto',
          title: 'Profile Photo',
          initialFile: _profilePhoto,
          isRequired: true,
          showImageSquare: false,
          onChanged: (file) {
            setState(() {
              _profilePhoto = file;
            });
          },
        ),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'Full Name',
          controller: _nameController,
          hintText: 'Enter your full name',
        ),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'Email',
          controller: _emailController,
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
        ),
        Gap(16.h),
        Text(
          'Phone Number',
          style: context.bodyMedium?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF24262D),
          ),
        ),
        Gap(12.h),
        AppPhoneNumberTextField(initialValue: _phoneNumber, onChanged: _onPhoneChanged, isDark: isDark),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'Password',
          controller: _passwordController,
          hintText: 'Enter password',
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
  }

  // Step 2: Vehicle Information
  Widget _buildStep2(BuildContext context, bool isDark) {
    return Column(
      children: [
        Text(
          'Vehicle Type',
          style: context.bodyMedium?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : const Color(0xFF24262D),
          ),
        ),
        Gap(12.h),
        FormBuilderDropdown<String>(
          name: 'vehicleType',
          decoration: InputDecoration(
            hintText: 'Select vehicle type',
            border: border(),
            enabledBorder: border(),
            focusedBorder: border(true),
          ),
          items: _vehicleTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
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
          title: 'Vehicle Number',
          controller: _vehicleNumberController,
          hintText: 'Enter vehicle number',
        ),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'Vehicle Color',
          controller: _vehicleColorController,
          hintText: 'Enter vehicle color',
        ),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'Vehicle Model',
          controller: _vehicleModelController,
          hintText: 'Enter vehicle model',
        ),
      ],
    );
  }

  // Step 3: License & Documents
  Widget _buildStep3(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          context,
          isDark,
          title: 'License Number',
          controller: _licenseNumberController,
          hintText: 'Enter license number',
        ),
        Gap(16.h),
        imagePickerFormField(
          context: context,
          name: 'licenseFront',
          title: 'License Front',
          initialFile: _licenseFront,
          isRequired: true,
          onChanged: (file) {
            setState(() {
              _licenseFront = file;
            });
          },
        ),
        Gap(16.h),
        imagePickerFormField(
          context: context,
          name: 'licenseBack',
          title: 'License Back',
          initialFile: _licenseBack,
          isRequired: true,
          onChanged: (file) {
            setState(() {
              _licenseBack = file;
            });
          },
        ),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'Aadhaar Number',
          controller: _aadhaarNumberController,
          hintText: 'Enter Aadhaar number',
        ),
        Gap(16.h),
        imagePickerFormField(
          context: context,
          name: 'aadhaarFront',
          title: 'Aadhaar Front',
          initialFile: _aadhaarFront,
          isRequired: true,
          onChanged: (file) {
            setState(() {
              _aadhaarFront = file;
            });
          },
        ),
        Gap(16.h),
        imagePickerFormField(
          context: context,
          name: 'aadhaarBack',
          title: 'Aadhaar Back',
          initialFile: _aadhaarBack,
          isRequired: true,
          onChanged: (file) {
            setState(() {
              _aadhaarBack = file;
            });
          },
        ),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'RC Number',
          controller: _rcNumberController,
          hintText: 'Enter RC number',
        ),
        Gap(16.h),
        imagePickerFormField(
          context: context,
          name: 'rcFront',
          title: 'RC Front',
          initialFile: _rcFront,
          isRequired: true,
          onChanged: (file) {
            setState(() {
              _rcFront = file;
            });
          },
        ),
        Gap(16.h),
        imagePickerFormField(
          context: context,
          name: 'rcBack',
          title: 'RC Back',
          initialFile: _rcBack,
          isRequired: true,
          onChanged: (file) {
            setState(() {
              _rcBack = file;
            });
          },
        ),
      ],
    );
  }

  // Step 4: Bank Information
  Widget _buildStep4(BuildContext context, bool isDark) {
    return Column(
      children: [
        _buildTextField(
          context,
          isDark,
          title: 'Account Holder Name',
          controller: _accountHolderNameController,
          hintText: 'Enter account holder name',
          isRequired: false,
        ),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'Bank Name',
          controller: _bankNameController,
          hintText: 'Enter bank name',
          isRequired: false,
        ),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'Account Number',
          controller: _accountNumberController,
          hintText: 'Enter account number',
          keyboardType: TextInputType.number,
          isRequired: false,
        ),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'IFSC Code',
          controller: _ifscCodeController,
          hintText: 'Enter IFSC code',
          isRequired: false,
        ),
        Gap(16.h),
        _buildTextField(
          context,
          isDark,
          title: 'UPI ID',
          controller: _upiIdController,
          hintText: 'Enter UPI ID',
          isRequired: false,
        ),
      ],
    );
  }

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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        requiredTitle(context, title: title, isRequired: isRequired),
        Gap(8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
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
}
