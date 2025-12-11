import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/presentation/auth/provider/auth_providers.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/exit_app_dialogue.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/buttons/app_text_button.dart';
import '../../../core/widgets/otp_textfield.dart';
import '../../../data/services/navigation_service.dart';
import '../../../core/routes/app_routes.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_bottom_buttons.dart';

class VerifyOtpPage extends ConsumerStatefulWidget {
  final String? code;
  const VerifyOtpPage({super.key, this.code});

  @override
  ConsumerState<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends ConsumerState<VerifyOtpPage> {
  final formKey = GlobalKey<FormBuilderState>();
  Timer? _timer;
  int secondsRemaining = 60;
  bool canResend = false;
  TextEditingController otpController = TextEditingController();

  void setCodeToController(String? codes) {
    otpController.text = codes ?? '';
  }

  @override
  void initState() {
    super.initState();
    if (widget.code != null) {
      setCodeToController(widget.code);
    }
    _startResendCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendCountdown() {
    canResend = false;
    secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        setState(() => canResend = true);
        _timer?.cancel();
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  Widget _buildTitle(BuildContext context) => Text(
    localize(context).otp_enter_title,
    style: context.bodyMedium?.copyWith(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      color: isDarkMode() ? const Color(0xFF687387) : ColorPalette.neutral24,
    ),
  );

  Widget _buildSubTitle(BuildContext context, String? phoneNumber) => RichText(
    text: TextSpan(
      style: context.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color(0xFF687387)),
      text: localize(context).otp_sent_message,
      children: [
        TextSpan(
          style: context.bodyMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: ColorPalette.primary50,
          ),
          text: phoneNumber,
        ),
      ],
    ),
  );

  Widget _buildOtpInput() => Center(child: OtpTextField(otpController: otpController, length: 6));

  Widget _buildResendSection(BuildContext context, WidgetRef ref) {
    final resentOTPState = ref.watch(resendOTPNotifierProvider);
    final resentOTPNotifier = ref.read(resendOTPNotifierProvider.notifier);
    final loginResponse = ref.read(loginNotifierProvider).maybeWhen(success: (data) => data, orElse: () => null);

    if (canResend) {
      return resentOTPState.when(
        initial: () => AppTextButton(
          text: localize(context).otp_resend,
          onPressed: () {
            resentOTPNotifier.resendOtp(
              mobile: loginResponse?.data?.mobile ?? '',
              onSuccess: (otp) {
                otpController.text = (otp.data?.otp ?? '').toString();
              },
            );
            _startResendCountdown();
          },
        ),
        loading: () => const CupertinoActivityIndicator(),
        success: (data) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showNotification(message: data.message ?? '', isSuccess: true);
            resentOTPNotifier.resetStateAfterDelay();
            _startResendCountdown();
          });
          return const SizedBox.shrink();
        },
        error: (error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showNotification(message: error.message);
            resentOTPNotifier.resetStateAfterDelay();
          });
          return const SizedBox.shrink();
        },
      );
    } else {
      return Text(
        localize(context).otp_resend_timer(secondsRemaining.toString().padLeft(2, '0')),
        style: context.bodyMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF687387),
        ),
      );
    }
  }

  Widget _buildVerifyButton(BuildContext context, WidgetRef ref) {
    // Variables commented out for design testing
    // final verifyState = ref.watch(otpVerifyNotifierProvider);
    // final verifyNotifier = ref.read(otpVerifyNotifierProvider.notifier);
    // final loginResponse = ref.read(loginNotifierProvider).maybeWhen(
    //   success: (data) => data,
    //   orElse: () => null,
    // );

    return AuthBottomButtons(
      isLoading: false, // Always false for design testing
      title: '${localize(context).confirm} OTP',
      onTap: () {
        // API call commented out for design testing - direct navigation
        // final String mobile = loginResponse?.data?.mobile ?? '1234567890';
        // final String otp = otpController.text.trim().isEmpty ? '123456' : otpController.text.trim();
        // verifyNotifier.verifyOTP(
        //   mobile: mobile,
        //   otp: otp,
        // );

        // Direct navigation to dashboard for design testing
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.dashboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginResponse = ref.read(loginNotifierProvider).maybeWhen(success: (data) => data, orElse: () => null);

    return ExitAppWrapper(
      child: Scaffold(
        backgroundColor: context.surface,
        body: AuthAppBar(
          title: localize(context).otp_title_short,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context),
              _buildSubTitle(context, loginResponse?.data?.mobile),
              Gap(24.h),
              Text(
                localize(context).otp_enter_title,
                style: context.bodyMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
                ),
              ),
              Gap(12.h),
              _buildOtpInput(),
              Gap(24.h),
              Center(child: _buildResendSection(context, ref)),
            ],
          ),
        ),
        bottomNavigationBar: _buildVerifyButton(context, ref),
      ),
    );
  }
}
