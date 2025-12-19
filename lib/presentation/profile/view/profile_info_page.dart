import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/common/loading_view.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_back_button.dart';
import 'package:gauva_driver/core/widgets/error_view.dart';
import 'package:gauva_driver/presentation/profile/provider/profile_providers.dart';

import '../../../core/widgets/buttons/app_primary_button.dart';

import '../../../data/models/gender_model/gender_model.dart';
import '../../../data/models/user_model/user_model.dart';
import '../../../generated/l10n.dart';
import '../../auth/provider/auth_providers.dart';
import '../widgets/avatar_select_button.dart';

class ProfileInfoPage extends ConsumerStatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  ConsumerState<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends ConsumerState<ProfileInfoPage> {
  final _formKey = GlobalKey<FormState>();

  List<GenderModel> genderItems = <GenderModel>[
    GenderModel(id: 1, value: 'Male', name: AppLocalizations().gender_male),
    GenderModel(id: 2, value: 'Female', name: AppLocalizations().gender_female),
    GenderModel(id: 3, value: 'Other', name: AppLocalizations().gender_other),
  ];

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  GenderModel? selectedGender;

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final state = ref.read(driverDetailsNotifierProvider);
      final User? user = state.maybeWhen(success: (data) => data.data?.user, orElse: () => null);

      ref
          .read(updatePersonalInfoProvider.notifier)
          .updateProfile(
            data: {
              'name': nameController.text.trim(),
              'mobile': mobileController.text.trim(),
              'email': emailController.text.trim(),
              'profileImage': user?.profilePicture ?? '', // Include current profile image URL
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(driverDetailsNotifierProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: isDarkMode() ? Colors.black : Colors.white,
        leading: const AppBackButton(),
        title: Text(
          localize(context).my_profile,
          style: context.bodyMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
          ),
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 8.h,
              width: double.infinity,
              color: isDarkMode() ? Colors.black12 : const Color(0xFFF6F7F9),
            ),

            state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const LoadingView(),
              success: (data) {
                final User? user = data.data?.user;

                nameController.text = user?.name ?? '';
                mobileController.text = user?.mobile ?? '';
                emailController.text = user?.email ?? '';
                selectedGender = user?.gender == 'male'
                    ? genderItems[0]
                    : user?.gender == 'female'
                    ? genderItems[1]
                    : genderItems[2];
                return Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      color: isDarkMode() ? Colors.black : Colors.white,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AvatarSelectButton(avatarPath: user?.profilePicture, userName: user?.name ?? ''),
                            Gap(16.h),
                            _buildTextField(context, title: localize(context).full_name, controller: nameController),
                            Gap(16.h),
                            _buildTextField(
                              context,
                              title: localize(context).mobile_number,
                              controller: mobileController,
                              readOnly: true,
                            ),
                            Gap(16.h),
                            _buildTextField(
                              context,
                              title: localize(context).email,
                              controller: emailController,
                              readOnly: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              error: (e) => ErrorView(message: e.message),
            ),

            Container(
              padding: EdgeInsets.all(12.r),
              width: double.infinity,
              color: isDarkMode() ? Colors.black : Colors.white,
              child: AppPrimaryButton(
                isLoading: ref.watch(updatePersonalInfoProvider).whenOrNull(loading: () => true) ?? false,
                isDisabled: ref.watch(updatePersonalInfoProvider).whenOrNull(loading: () => true) ?? false,
                onPressed: _saveProfile,
                child: Text(
                  localize(context).save,
                  style: context.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    bool readOnly = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: context.bodyMedium?.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
        ),
      ),
      Gap(12.h),
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        style: context.bodyMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF687387),
        ),
        decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16.w)),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => (value == null || value.trim().isEmpty) ? localize(context).field_required : null,
      ),
    ],
  );
}
