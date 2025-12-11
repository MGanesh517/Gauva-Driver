import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/custom_dropdown.dart';
import 'package:gauva_driver/core/widgets/required_title.dart';
import 'package:gauva_driver/presentation/auth/provider/auth_providers.dart';
import 'package:gauva_driver/presentation/auth/widgets/auth_app_bar.dart';
import 'package:gauva_driver/presentation/auth/widgets/text_field_with_title.dart';
import 'package:gauva_driver/presentation/profile/provider/profile_providers.dart';

import '../../../core/utils/helpers.dart';
import '../../../core/utils/is_dark_mode.dart';
import '../../../data/models/gender_model/gender_model.dart';
import '../../../generated/l10n.dart';
import '../widgets/auth_bottom_buttons.dart';
import '../widgets/image_picker_form_field.dart';

class DriverPersonalInfoPage extends ConsumerStatefulWidget {
  final bool isUpdatingProfile;
  const DriverPersonalInfoPage({super.key, this.isUpdatingProfile = false});

  @override
  ConsumerState<DriverPersonalInfoPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends ConsumerState<DriverPersonalInfoPage> {
  final formKey = GlobalKey<FormBuilderState>();
  File? profileImage;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final genderList = <GenderModel>[
    GenderModel(id: 1, value: 'Male', name: AppLocalizations().gender_male),
    GenderModel(id: 2, value: 'Female', name: AppLocalizations().gender_female),
    GenderModel(id: 3, value: 'Other', name: AppLocalizations().gender_other),
  ];
  GenderModel? selectedGender;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdatingProfile) {
      Future.microtask(() async {
        await ref.read(driverDetailsNotifierProvider.notifier).getDriverDetails();
        ref
            .read(driverDetailsNotifierProvider)
            .maybeWhen(
              success: (data) {
                final user = data.data?.user;
                if (user != null) {
                  nameController.text = user.name ?? '';
                  phoneController.text = user.licence ?? '';
                  emailController.text = user.email ?? '';
                  addressController.text = user.address ?? '';
                  selectedGender = genderList.firstWhereOrNull(
                    (element) => element.value.toLowerCase() == user.gender?.toLowerCase(),
                  );
                  setState(() {});
                }
              },
              orElse: () {},
            );
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.surface,
    body: AuthAppBar(
      title: localize(context).personal_info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localize(context).add_driver_personal_info,
            style: context.bodyMedium?.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
            ),
          ),
          Gap(8.h),
          Text(
            localize(context).enter_details_complete_profile,
            style: context.bodyMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF687387),
            ),
          ),
          Gap(24.h),
          FormBuilder(
            key: formKey,
            child: Column(
              children: [
                _buildFormFields(context),
                imagePickerFormField(
                  context: context,
                  name: 'profile_image',
                  title: localize(context).profile_image,
                  initialFile: profileImage,
                  showImageSquare: false,
                  validator: (file) {
                    if (file == null) {
                      return localize(context).profile_image_required;
                    }
                    return null;
                  },
                  onChanged: (file) {
                    setState(() {
                      profileImage = file;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(updatePersonalInfoProvider);
        final notifier = ref.read(updatePersonalInfoProvider.notifier);

        return AuthBottomButtons(
          isLoading: state.maybeWhen(loading: () => true, orElse: () => false),
          title: localize(context).next,
          onTap: () async {
            if (formKey.currentState!.saveAndValidate()) {
              final data = {
                'name': nameController.text.trim(),
                'emergency_contact': phoneController.text.trim(),
                'email': emailController.text.trim(),
                'address': addressController.text.trim(),
                'gender': selectedGender?.value.toLowerCase(),
              };

              await notifier.updatePersonalInfo(data: data, profilePicture: profileImage!);
            } else {
              showNotification(message: localize(context).all_field_required);
            }
          },
        );
      },
    ),
  );

  Widget _buildFormFields(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextField(context, title: localize(context).name_label, controller: nameController, name: 'name'),
      _buildTextField(
        context,
        title: localize(context).emergency_phone,
        controller: phoneController,
        name: 'phone',
        isNumber: true,
      ),
      _buildTextField(
        context,
        title: localize(context).email_label,
        controller: emailController,
        name: 'email',
        isEmail: true,
      ),
      _buildTextField(context, title: localize(context).address, controller: addressController, name: 'address'),
      _buildGenderDropdown(context),
    ],
  );

  Widget _buildTextField(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required String name,
    bool isEmail = false,
    bool isNumber = false,
    bool isRequired = true,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: FormBuilderField(
      name: name,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        if (isEmail) FormBuilderValidators.email(),
        if (isNumber) FormBuilderValidators.numeric(),
      ]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          requiredTitle(context, title: title, isRequired: isRequired),

          Gap(8.h),
          TextField(
            controller: controller,
            keyboardType: isNumber
                ? TextInputType.number
                : isEmail
                ? TextInputType.emailAddress
                : null,
            onChanged: field.didChange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              hintText: title,
              focusedBorder: border(true),
              enabledBorder: border(),
              border: border(),
              errorText: field.errorText,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildGenderDropdown(BuildContext context, {bool isRequired = true}) {
    final genderItems = genderList
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e.name?.capitalize() ?? '',
              style: context.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: isDarkMode() ? Colors.white : Colors.black,
              ),
            ),
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FormBuilderField<GenderModel>(
        name: 'gender',
        validator: FormBuilderValidators.required(errorText: localize(context).gender_required),
        initialValue: selectedGender,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            requiredTitle(context, title: localize(context).gender_label, isRequired: isRequired),

            Gap(8.h),
            customDropdown<GenderModel>(
              context,
              value: selectedGender,
              hint: localize(context).gender_select,
              items: genderItems,
              onChanged: (value) {
                setState(() => selectedGender = value);
                field.didChange(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum Gender { male, female, unknown }

final selectedGenderProvider = StateProvider<Gender>((ref) => Gender.male);
