import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/presentation/auth/provider/auth_providers.dart';

import '../../../core/theme/color_palette.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/is_dark_mode.dart';
import '../../../core/widgets/required_title.dart';
import '../widgets/auth_app_bar.dart';
import '../widgets/auth_bottom_buttons.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;
  bool codeLengthIsSafe = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.surface,
    body: AuthAppBar(
      title: localize(context).password_label,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localize(context).password_hint,
              style: context.bodyMedium?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isDarkMode() ? const Color(0xFF687387) : ColorPalette.neutral24,
              ),
            ),
            Gap(8.h),
            Text(
              localize(context).password_requirements(6.toString()),
              textAlign: TextAlign.start,
              style: context.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF687387),
              ),
            ),

            Gap(24.h),

            _buildPasswordField(
              title: localize(context).password_label,
              controller: _passwordController,
              isVisible: showPassword,
              toggleVisibility: () => setState(() => showPassword = !showPassword),
              onChanged: (value) {
                setState(() {
                  codeLengthIsSafe = value.length >= 6 && value.length <= 16;
                });
              },
            ),

            Gap(20.h),

            // Confirm Password Field
            _buildPasswordField(
              title: localize(context).confirm_password,
              controller: _confirmPasswordController,
              isVisible: showConfirmPassword,
              toggleVisibility: () => setState(() => showConfirmPassword = !showConfirmPassword),
              isConfirm: true,
            ),
          ],
        ),
      ),
    ),

    bottomNavigationBar: Consumer(
      builder: (context, ref, _) {
        final updatePassState = ref.watch(updatePassViewModelProvider);

        final stateNotifier = ref.read(updatePassViewModelProvider.notifier);

        return AuthBottomButtons(
          isLoading:
              _passwordController.text.trim().length < 6 ||
              updatePassState.when(
                initial: () => false,
                loading: () => true,
                success: (data) => false,
                error: (e) => false,
              ),

          title: localize(context).save,
          onTap: () {
            final isValid = _formKey.currentState?.validate() ?? false;
            if (!isValid) return;

            final password = _passwordController.text.trim();
            final confirmPassword = _confirmPasswordController.text.trim();

            if (password != confirmPassword) {
              showNotification(message: localize(context).password_mismatch);
              return;
            }

            stateNotifier.updatePassword(password: password);
          },
        );
      },
    ),
  );
  Widget _buildPasswordField({
    required String title,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    ValueChanged<String>? onChanged,
    bool isConfirm = false,
    bool isRequired = true,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      requiredTitle(context, title: title, isRequired: isRequired),

      Gap(12.h),
      TextFormField(
        controller: controller,
        obscureText: !isVisible,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: title,
          // filled: true,
          // fillColor: context.surface,
          suffixIcon: CupertinoButton(
            onPressed: toggleVisibility,
            child: Icon(
              isVisible ? Ionicons.eye : Ionicons.eye_off,
              color: context.theme.inputDecorationTheme.suffixIconColor,
            ),
          ),
        ),
        validator: (value) {
          final trimmed = value?.trim() ?? '';
          if (trimmed.isEmpty) {
            return localize(context).field_required;
          }

          if (trimmed.length < 6) {
            return localize(context).password_requirements('6');
          }
          if (isConfirm && trimmed != _passwordController.text.trim()) {
            return localize(context).password_mismatch;
          }

          return null;
        },
      ),
    ],
  );
}
