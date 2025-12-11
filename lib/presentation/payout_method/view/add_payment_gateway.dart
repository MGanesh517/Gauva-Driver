import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/custom_dropdown.dart';

import '../../../core/utils/helpers.dart';
import '../../auth/widgets/auth_bottom_buttons.dart';
import '../../payment_method/provider/provider.dart';
import '../../payment_method/widgets/payment_method_dropwodn.dart';
import '../../wallet/provider/provider.dart';
import '../widget/text_field_with_title.dart';

class AddPaymentGateway extends ConsumerStatefulWidget {
  const AddPaymentGateway({super.key});

  @override
  ConsumerState<AddPaymentGateway> createState() => _AddPaymentGatewayState();
}

class _AddPaymentGatewayState extends ConsumerState<AddPaymentGateway> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expDateController = TextEditingController();
  final cvvController = TextEditingController();
  final countryController = TextEditingController(text: 'Bangladesh');

  final List<String> countries = ['Bangladesh', 'India', 'USA', 'UK'];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      expDateController.text = DateFormat('MM/yyyy', 'en').format(picked);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedPayMethodProvider.notifier).reset();
      ref.read(paymentMethodsNotifierProvider.notifier).getPaymentMethods();
    });
  }

  TextStyle? textStyle(BuildContext context) =>
      context.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color(0xFF979899));

  void _onSavePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final exp = expDateController.text.trim();
      final parts = exp.split('/');

      final expMonth = parts.length == 2 ? parts[0] : '';
      final expYear = parts.length == 2 ? parts[1] : '';

      ref
          .read(addCardProvider.notifier)
          .addCard(
            body: {
              'number': cardNumberController.text.trim(),
              'exp_month': expMonth,
              'exp_year': expYear,
              'cvc': cvvController.text.trim(),
              'address_country': countryController.text.trim(),
              'name': nameController.text.trim(),
            },
          );
    } else {
      showNotification(message: localize(context).form_is_not_valid);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        localize(context).add_payment_gateway,
        style: context.bodyMedium?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: isDarkMode() ? Colors.white : Colors.black,
        ),
      ),
    ),
    // backgroundColor: Colors.white,
    // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    bottomNavigationBar: AuthBottomButtons(
      isLoading: ref.watch(addCardProvider).whenOrNull(loading: () => true) ?? false,
      title: localize(context).save,
      onTap: _onSavePressed,
    ),
    body: Container(
      color: isDarkMode() ? Colors.black : Colors.white,
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.only(top: 8.h),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              paymentMethodDropdown(context, isRequired: true),
              Gap(16.h),
              textFieldWithTitle(
                context,
                label: localize(context).cardholder_name,
                controller: nameController,
                validator: (v) => v == null || v.isEmpty ? localize(context).enter_cardholder_name : null,
              ),
              textFieldWithTitle(
                context,
                label: localize(context).card_number,
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.length < 12 ? localize(context).enter_valid_card_number : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: textFieldWithTitle(
                      context,
                      label: localize(context).exp_date,
                      controller: expDateController,
                      readOnly: true,
                      onTap: _pickDate,
                      suffix: const Icon(Icons.calendar_today, size: 20),
                      validator: (v) => v == null || v.isEmpty ? localize(context).pick_a_date : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: textFieldWithTitle(
                      context,
                      label: localize(context).cvv,
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.length != 3 ? localize(context).enter_3_digit_cvv : null,
                    ),
                  ),
                ],
              ),
              customDropdown<String>(
                context,
                hint: localize(context).country,
                value: countryController.text,
                items: countries
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c, style: textStyle(context)),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => countryController.text = val);
                },
                validator: (v) => v == null || v.isEmpty ? localize(context).select_a_country : null,
                autoValidateMode: AutovalidateMode.onUserInteraction,
              ),
              // DropdownButtonFormField<String>(
              //   initialValue: countryController.text,
              //   decoration: InputDecoration(
              //     labelText: localize(context).country,
              //     contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8)),
              //   ),
              //   dropdownColor: context.surface,
              //
              //   items: countries
              //       .map((c) => DropdownMenuItem(
              //     value: c,
              //     child: Text(c, style: textStyle(context)),
              //   ))
              //       .toList(),
              //   onChanged: (val) {
              //     if (val != null) setState(() => countryController.text = val);
              //   },
              //   validator: (v) =>
              //   v == null || v.isEmpty ? localize(context).select_a_country : null,
              // ),
            ],
          ),
        ),
      ),
    ),
  );
}
