import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:shimmer/shimmer.dart';

DropdownButtonHideUnderline customDropdown<T>(
  BuildContext context, {
  required T? value,
  required List<DropdownMenuItem<T>>? items,
  required Function(T?)? onChanged,
  // String? label,
  String? hint,
  FormFieldValidator<T>? validator,
  AutovalidateMode? autoValidateMode,
  EdgeInsets? menuPadding,
  final bool isLoading = false,
  // double? left = 16,
}) {
  if (isLoading) {
    // Shimmer loader
    return DropdownButtonHideUnderline(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8.r)),
        ),
      ),
    );
  }
  return DropdownButtonHideUnderline(
    child: DropdownButtonFormField2<T>(
      isExpanded: true,
      value: value,
      items: items,
      onChanged: onChanged,
      hint: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          hint ?? '',
          style: context.bodyMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: isDarkMode() ? Colors.white : const Color(0xFF687387),
          ),
        ),
      ),
      validator: validator,
      autovalidateMode: autoValidateMode,
      decoration: InputDecoration(contentPadding: EdgeInsets.only(right: 8.w)),
      menuItemStyleData: MenuItemStyleData(
        overlayColor: WidgetStatePropertyAll(context.surface),
        padding: menuPadding ?? EdgeInsets.only(left: 16.w),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200.h,
        scrollPadding: EdgeInsets.zero,
        decoration: BoxDecoration(color: context.surface, borderRadius: BorderRadius.circular(8.r)),
      ),
    ),
  );
}
