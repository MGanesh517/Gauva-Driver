import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/is_dark_mode.dart';
import '../provider/auth_providers.dart';
import '../provider/forgot_password_notifier.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_bottom_buttons.dart';
import '../../../core/widgets/required_title.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode();
    final state = ref.watch(forgotPasswordResetNotifierProvider);
    final notifier = ref.read(forgotPasswordResetNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: context.surface,
      resizeToAvoidBottomInset: true,
      body: AuthAppBar(
        showLeading: true,
        title: "Reset Password",
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create New Password",
                style: context.bodyMedium?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF687387) : ColorPalette.neutral24,
                ),
              ),
              Gap(8.h),
              Text(
                "Enter the OTP sent to ${widget.email} and create a new password",
                style: context.bodyMedium?.copyWith(
                  fontSize: 16.sp,
                  color: const Color(0xFF687387),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Gap(24.h),

              // OTP Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  requiredTitle(context, title: "OTP Code", isRequired: true),
                  Gap(8.h),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      hintText: "Enter 6-digit OTP",
                      hintStyle: context.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF687387),
                      ),
                      counterText: "",
                      border: _border(),
                      enabledBorder: _border(),
                      focusedBorder: _border(true),
                    ),
                  ),
                ],
              ),
              Gap(16.h),

              // New Password Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  requiredTitle(context, title: "New Password", isRequired: true),
                  Gap(8.h),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      hintText: "Enter new password",
                      hintStyle: context.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF687387),
                      ),
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
                      border: _border(),
                      enabledBorder: _border(),
                      focusedBorder: _border(true),
                    ),
                  ),
                ],
              ),
              Gap(16.h),

              // Confirm Password Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  requiredTitle(context, title: "Confirm Password", isRequired: true),
                  Gap(8.h),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      hintText: "Re-enter new password",
                      hintStyle: context.bodyMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF687387),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: isDark ? Colors.white70 : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: _border(),
                      enabledBorder: _border(),
                      focusedBorder: _border(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: isDark ? context.surface : Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AuthBottomButtons(
                isLoading: state is ForgotPasswordResetLoading,
                title: "Reset Password",
                onTap: () {
                  final otp = _otpController.text.trim();
                  final password = _passwordController.text.trim();
                  final confirmPassword = _confirmPasswordController.text.trim();

                  if (otp.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter the OTP')));
                    return;
                  }

                  if (otp.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP must be 6 digits')));
                    return;
                  }

                  if (password.isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Please enter a new password')));
                    return;
                  }

                  if (password.length < 6) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Password must be at least 6 characters')));
                    return;
                  }

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
                    return;
                  }

                  notifier.resetPassword(email: widget.email, otp: otp, newPassword: password);
                },
                onSkip: null, // No skip button for reset password
              ),
              Gap(16.h),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border([bool isFocused = false]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: isFocused ? ColorPalette.primary50 : const Color(0xFFE0E0E0), width: 1.5),
    );
  }
}
