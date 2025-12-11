import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:path/path.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';

import '../../../core/utils/image_picker_with_dialogue.dart';

Widget imagePickerFormField({
  required BuildContext context,
  required String name,
  required String title,
  File? initialFile,
  FormFieldValidator<File>? validator,
  required ValueChanged<File?> onChanged,
  bool showImageSquare = true,
  bool isRequired = true,
}) => FormBuilderField<File>(
  name: name,
  initialValue: initialFile,
  validator: validator,
  builder: (field) {
    final File? file = field.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: title,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
                  ),
                  children: isRequired
                      ? [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red, fontSize: 18.sp, fontWeight: FontWeight.w700),
                          ),
                        ]
                      : [],
                ),
              ),
            ),
            SizedBox(width: 16.w),
            InkWell(
              onTap: () async {
                final pickedFile = await pickImageWithSourceSelector(context);
                if (pickedFile != null) {
                  field.didChange(pickedFile);
                  onChanged(pickedFile);
                  field.validate();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: isDarkMode() ? Colors.black54 : const Color(0xFFEDEBFC),
                  border: Border.all(color: ColorPalette.primary50, width: 1.w),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  file != null ? localize(context).update : localize(context).upload,
                  style: context.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorPalette.primary50,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            showImageSquare
                ? Container(
                    height: 64.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      image: file == null ? null : DecorationImage(image: FileImage(file), fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: isDarkMode() ? Colors.white10 : const Color(0xFFD7DAE0), width: 1.w),
                    ),
                  )
                : CircleAvatar(
                    radius: 30.r,
                    backgroundColor: isDarkMode() ? Colors.white10 : Colors.grey.shade300,
                    backgroundImage: file != null ? FileImage(file) : null,
                    child: file == null
                        ? Icon(Icons.person, size: 30.h, color: isDarkMode() ? Colors.white : Colors.black54)
                        : null,
                  ),
            SizedBox(width: 16.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isDarkMode() ? Colors.black12 : const Color(0xFFF6F7F9),
                  border: Border.all(color: const Color(0xFFD7DAE0)),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        file != null ? basename(file.path) : localize(context).your_best_photo_here,
                        style: TextStyle(color: const Color(0xFF687387), fontSize: 14.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    if (file != null)
                      InkWell(
                        child: Icon(Icons.clear, size: 24.h, color: ColorPalette.primary50),
                        onTap: () {
                          field.didChange(null);
                          onChanged(null);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (field.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              field.errorText!,
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
            ),
          ),
      ],
    );
  },
);
