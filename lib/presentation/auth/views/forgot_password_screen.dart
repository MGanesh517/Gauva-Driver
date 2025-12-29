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

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode();
    final state = ref.watch(forgotPasswordNotifierProvider);
    final notifier = ref.read(forgotPasswordNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: context.surface,
      resizeToAvoidBottomInset: true,
      body: AuthAppBar(
        showLeading: true,
        title: "Forgot Password",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reset Password",
              style: context.bodyMedium?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFF687387) : ColorPalette.neutral24,
              ),
            ),
            Gap(8.h),
            Text(
              "Enter your email address and we'll send you an OTP to reset your password",
              style: context.bodyMedium?.copyWith(
                fontSize: 16.sp,
                color: const Color(0xFF687387),
                fontWeight: FontWeight.w400,
              ),
            ),
            Gap(24.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                requiredTitle(context, title: "Email Address", isRequired: true),
                Gap(8.h),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    hintText: "Enter your email",
                    hintStyle: context.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF687387),
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
      bottomNavigationBar: SafeArea(
        child: Container(
          color: isDark ? context.surface : Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AuthBottomButtons(
                isLoading: state is ForgotPasswordLoading,
                title: "Send OTP",
                onTap: () {
                  final email = _emailController.text.trim();

                  if (email.isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Please enter your email address')));
                    return;
                  }

                  if (!_isValidEmail(email)) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Please enter a valid email address')));
                    return;
                  }

                  notifier.sendOtp(email);
                },
                onSkip: null, // No skip button for forgot password
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
