import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/widgets/required_title.dart';
import 'package:gauva_driver/presentation/auth/widgets/text_field_with_title.dart';

Widget textFieldFromBuilderWithTitle(
  BuildContext context, {
  required String title,
  required String name,
  String? hintText,
  String? initialValue,
  TextInputType? keyboardType,
  bool isObscure = false,
  bool isRequired = true,
  bool readOnly = false,
  Function()? onTap,
  List<String? Function(String?)>? validators,
  TextEditingController? controller,
}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    requiredTitle(context, title: title, isRequired: isRequired),

    Gap(8.h),
    FormBuilderTextField(
      controller: controller,
      name: name,
      readOnly: readOnly,
      onTap: onTap,
      initialValue: controller == null ? initialValue ?? '' : null,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: isObscure,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        hintText: hintText,
        hintStyle: context.bodyMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF687387),
        ),
        border: border(),
        enabledBorder: border(),
        focusedBorder: border(true),
      ),
      validator: FormBuilderValidators.compose(validators ?? [FormBuilderValidators.required()]),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    ),
    Gap(16.h),
  ],
);
