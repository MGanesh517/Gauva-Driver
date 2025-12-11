import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/gen/assets.gen.dart';

Widget summeryCard(
  BuildContext context, {
  required String title,
  required String value,
  required AssetGenImage icon,
  Color backgroundColor = Colors.black,
}) => Expanded(
  child: Container(
    padding: EdgeInsets.all(8.r),
    decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8.r)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          textAlign: TextAlign.start,
          style: context.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: context.bodyMedium?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),
              ),
            ),
            Gap(8.w),
            icon.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
          ],
        ),
      ],
    ),
  ),
);
