import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/widgets/custom_dropdown.dart';
import 'package:gauva_driver/core/widgets/required_title.dart';

import '../../../core/utils/is_dark_mode.dart';

class DynamicYearDropdownFormField extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final TextEditingController controller;
  final String? hintText;
  final String? title;
  final bool isRequired;

  const DynamicYearDropdownFormField({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.controller,
    this.hintText,
    this.title,
    this.isRequired = true,
  });

  @override
  State<DynamicYearDropdownFormField> createState() => _DynamicYearDropdownFormFieldState();
}

class _DynamicYearDropdownFormFieldState extends State<DynamicYearDropdownFormField> {
  late List<int> _yearList;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _yearList = _generateYearList(widget.startDate, widget.endDate);

    if (widget.controller.text.isNotEmpty) {
      final year = int.tryParse(widget.controller.text);
      if (year != null && _yearList.contains(year)) {
        _selectedYear = year;
      } else {
        _selectedYear = null;
      }
    } else {
      _selectedYear = null;
    }
  }

  List<int> _generateYearList(DateTime start, DateTime end) {
    final List<int> years = [];
    for (int y = start.year; y <= end.year; y++) {
      years.add(y);
    }
    return years;
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      requiredTitle(context, title: widget.title ?? '', isRequired: widget.isRequired),
      Gap(8.h),
      customDropdown<int>(
        context,
        value: _selectedYear,
        hint: widget.hintText,
        items: _yearList
            .map(
              (year) => DropdownMenuItem<int>(
                value: year,
                child: Text(
                  year.toString(),
                  style: context.bodyMedium?.copyWith(
                    fontSize: widget.controller.text.contains(year.toString()) ? 17.sp : 15.sp,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode()
                        ? Colors.white
                        : widget.controller.text.contains(year.toString())
                        ? Colors.black
                        : Colors.black87,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (int? newYear) {
          setState(() {
            _selectedYear = newYear;
            widget.controller.text = newYear?.toString() ?? '';
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Year must be selected';
          }
          return null;
        },
        autoValidateMode: AutovalidateMode.onUserInteraction,
      ),
      Gap(16.h),
    ],
  );
}
