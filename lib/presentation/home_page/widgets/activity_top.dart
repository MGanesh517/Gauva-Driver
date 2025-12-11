import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';

import '../../dashboard/provider/dashboard_index_provider.dart';

Widget activityTop(BuildContext context) => Consumer(
  builder: (context, ref, _) => Row(
    children: [
      Expanded(
        child: Text(
          localize(context).todays_activity,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.bodyMedium?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isDarkMode() ? Colors.white : const Color(0xFF24262D),
          ),
        ),
      ),
      InkWell(
        onTap: () {
          ref.read(dashboardIndexProvider.notifier).state = 2;
        },
        child: Text(
          localize(context).view_all,
          style: context.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8154DA),
          ),
        ),
      ),
    ],
  ),
);
