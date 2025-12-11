import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

class OtpTextField extends StatelessWidget {
  final int length;
  final TextEditingController? otpController;
  final Function(String)? onChanged;
  final Function(String)? onCompleted;

  const OtpTextField({required this.length, this.otpController, this.onChanged, super.key, this.onCompleted});

  @override
  Widget build(BuildContext context) => Pinput(
    controller: otpController,
    length: 6,
    autofocus: true,
    defaultPinTheme: PinTheme(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 16),
      decoration: BoxDecoration(
        // color: context.theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.inputDecorationTheme.border!.borderSide.color),
      ),
    ),
    focusedPinTheme: PinTheme(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 16),
      decoration: BoxDecoration(
        // color: context.theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.theme.inputDecorationTheme.focusedBorder!.borderSide.color),
      ),
    ),
    onCompleted: onCompleted,
    onChanged: onChanged,
  );
}
