import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/build_network_image.dart';
import 'package:gauva_driver/core/utils/localize.dart';

import '../../presentation/account_page/provider/select_country_provider.dart';
import 'country_code_bottom_sheet.dart';

class AppPhoneNumberTextField extends StatelessWidget {
  final void Function(String?)? onChanged;
  final String? initialValue;
  final bool isDark;
  final TextEditingController? controller;
  const AppPhoneNumberTextField({
    super.key,
    required this.initialValue,
    this.controller,
    this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(selectedCountry);

          // if (state.selectedPhoneCode == null) {
          //   return const SizedBox.shrink();
          // }
          return InkWell(
            onTap: () async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const CountryCodeBottomSheet(selectCountryCode: true),
              );
            },
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: context.surface,
                border: Border.all(color: context.theme.inputDecorationTheme.enabledBorder!.borderSide.color),
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildNetworkImage(
                    imageUrl: state.selectedPhoneCode?.flag,
                    width: 24.w,
                    height: 24.h,
                    errorIconSize: 24,
                    fit: BoxFit.contain,
                    // filterQuality: FilterQuality.high,
                    // isAntiAlias: true,
                  ),
                  Gap(8.w),
                  Text(
                    state.selectedPhoneCode?.phoneCode ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyMedium?.copyWith(color: isDark ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      Gap(8.w),
      Expanded(
        child: SizedBox(
          height: 48.h,
          child: FormBuilderTextField(
            controller: controller,
            name: 'phoneNumber',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            // initialValue: initialValue,
            validator: FormBuilderValidators.compose([FormBuilderValidators.required(), FormBuilderValidators.min(6)]),
            decoration: InputDecoration(
              hintText: localize(context).enterPhoneNumber,
              fillColor: context.surface,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            ),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}
