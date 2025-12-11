import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/get_version.dart';
import 'package:gauva_driver/core/utils/localize.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/exit_app_dialogue.dart';
import '../../../core/utils/is_dark_mode.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/services/navigation_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../account_page/provider/theme_provider.dart';
import '../provider/auth_providers.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_bottom_buttons.dart';
import '../widgets/text_field_with_title.dart';
import '../../../core/widgets/required_title.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String version = '';
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVersion();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loadVersion() async {
    version = await getVersion();
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode();

    return ExitAppWrapper(
      child: Scaffold(
        backgroundColor: context.surface,
        resizeToAvoidBottomInset: true,
        body: AuthAppBar(
          showLeading: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      localize(context).helloText,
                      style: context.bodyMedium?.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.primary50,
                      ),
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: Text(
                      version,
                      textAlign: TextAlign.end,
                      style: context.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.primary50,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(4.h),
              Text(
                localize(context).welcomeBack,
                style: context.bodyMedium?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF687387) : ColorPalette.neutral24,
                ),
              ),
              Gap(8.h),
              Text(
                'Enter your email and password to continue',
                style: context.bodyMedium?.copyWith(
                  fontSize: 16.sp,
                  color: const Color(0xFF687387),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Gap(24.h),
              FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      context,
                      isDark,
                      title: 'Email',
                      controller: _emailController,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Gap(16.h),
                    _buildTextField(
                      context,
                      isDark,
                      title: 'Password',
                      controller: _passwordController,
                      hintText: 'Enter your password',
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
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(driverLoginEmailPasswordNotifierProvider);
              final stateNotifier = ref.read(driverLoginEmailPasswordNotifierProvider.notifier);
              final themeMode = ref.watch(themeModeProvider);
              final isDarkMode = themeMode == ThemeMode.dark;

              // Handle navigation
              state.whenOrNull(
                success: (data) {
                  if (mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        // Navigation is handled in the notifier
                      }
                    });
                  }
                },
              );

              return Container(
                color: isDarkMode ? context.surface : Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AuthBottomButtons(
                      isLoading: state.when(
                        initial: () => false,
                        loading: () => true,
                        success: (data) => false,
                        error: (e) => false,
                      ),
                      onSkip: () {
                        NavigationService.pushNamedAndRemoveUntil(AppRoutes.dashboard);
                      },
                      title: localize(context).loginSignup,
                      onTap: () {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (email.isEmpty) {
                          showNotification(message: 'Please enter your email');
                          return;
                        }

                        if (password.isEmpty) {
                          showNotification(message: 'Please enter your password');
                          return;
                        }

                        // Basic email validation
                        if (!email.contains('@') || !email.contains('.')) {
                          showNotification(message: 'Please enter a valid email address');
                          return;
                        }

                        stateNotifier.login(identifier: email, password: password);
                      },
                    ),
                    Gap(8.h),
                    // Sign Up Link
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: context.bodyMedium?.copyWith(fontSize: 14.sp, color: const Color(0xFF687387)),
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigationService.pushNamed(AppRoutes.signup);
                            },
                            child: Text(
                              'Sign Up',
                              style: context.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorPalette.primary50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        requiredTitle(context, title: title, isRequired: true),
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
