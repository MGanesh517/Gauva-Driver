import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/presentation/auth/provider/auth_providers.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/utils/exit_app_dialogue.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/widgets/buttons/app_text_button.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_bottom_buttons.dart';

class LoginWithPasswordPage extends ConsumerStatefulWidget {
  const LoginWithPasswordPage({super.key});

  @override
  ConsumerState<LoginWithPasswordPage> createState() => _LoginWithPasswordPageState();
}

class _LoginWithPasswordPageState extends ConsumerState<LoginWithPasswordPage> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final TextEditingController passwordController = TextEditingController();

  bool showPassword = false;

  bool codeLengthIsSafe = false;

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) => ExitAppWrapper(
    child: Scaffold(
      backgroundColor: context.surface,
      body: AuthAppBar(
        title: localize(context).password_label,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localize(context).login_with_your_password,
              style: context.bodyMedium?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isDarkMode() ? const Color(0xFF687387) : ColorPalette.neutral24,
              ),
            ),
            Gap(8.h),
            Text(
              localize(context).use_your_password_here,
              style: context.bodyMedium?.copyWith(
                fontSize: 16.sp,
                color: const Color(0xFF687387),
                fontWeight: FontWeight.w400,
              ),
            ),
            Gap(24.h),

            Text(
              localize(context).password_label,
              style: context.bodyMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
              ),
            ),
            Gap(12.h),
            TextField(
              controller: passwordController,
              onChanged: (v) {
                setState(() {
                  codeLengthIsSafe = v.length >= 6 && v.length <= 16;
                });
              },
              obscureText: !showPassword,
              decoration: InputDecoration(
                hintText: localize(context).password_label,
                suffixIcon: CupertinoButton(
                  onPressed: () => setState(() => showPassword = !showPassword),
                  child: Icon(
                    showPassword ? Ionicons.eye : Ionicons.eye_off,
                    color: context.theme.inputDecorationTheme.suffixIconColor,
                  ),
                ),
              ),
            ),
            Gap(16.h),

            Consumer(
              builder: (context, ref, _) {
                final resentOTPState = ref.watch(resendOTPNotifierProvider);
                final resentOTPNotifier = ref.read(resendOTPNotifierProvider.notifier);

                final loginResponse = ref
                    .read(loginNotifierProvider)
                    .maybeWhen(success: (data) => data, orElse: () => null);

                return Center(
                  child: AppTextButton(
                    text: localize(context).use_otp_instead,
                    isDisabled: resentOTPState.whenOrNull(loading: () => true) ?? false,
                    onPressed: () async {
                      await resentOTPNotifier.resendOtp(
                        mobile: loginResponse?.data?.mobile ?? '',
                        onSuccess: (v) {
                          NavigationService.pushNamed(AppRoutes.verifyOTP, arguments: (v.data?.otp ?? '').toString());
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: Consumer(
        builder: (context, ref, _) {
          final loginState = ref.watch(driverLoginEmailPasswordNotifierProvider);
          final loginNotifier = ref.read(driverLoginEmailPasswordNotifierProvider.notifier);
          final loginResponse = ref.read(loginNotifierProvider).maybeWhen(success: (data) => data, orElse: () => null);

          // Watch for success to navigate
          loginState.whenOrNull(
            success: (data) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                NavigationService.pushNamedAndRemoveUntil(AppRoutes.dashboard);
              });
            },
          );

          return AuthBottomButtons(
            isLoading: loginState.whenOrNull(loading: () => true) ?? false,
            title: localize(context).login,
            onTap: () {
              final String mobile = loginResponse?.data?.mobile ?? '';
              final String password = passwordController.text.trim();

              if (password.isEmpty) {
                showNotification(message: localize(context).enter_password_error);
                return;
              }

              // Use email/password login - mobile can be used as username
              loginNotifier.login(identifier: mobile, password: password);
            },
          );
        },
      ),
    ),
  );
}
