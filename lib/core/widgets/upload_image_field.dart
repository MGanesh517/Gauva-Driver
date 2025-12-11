import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';

import '../theme/color_palette.dart';

class UploadImageField extends StatefulWidget {
  final bool isCircular;
  final void Function(File) onImageSelected;
  final String title;

  const UploadImageField({super.key, this.isCircular = true, required this.onImageSelected, required this.title});

  @override
  State<UploadImageField> createState() => _UploadImageFieldState();
}

class _UploadImageFieldState extends State<UploadImageField> {
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: widget.isCircular ? null : BorderRadius.circular(12),
          border: Border.all(color: const Color(0xffe2e8f0), width: 8),
        ),
        child: result == null
            ? Container(
                width: 60.w,
                height: 60.w,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: widget.isCircular ? null : BorderRadius.circular(12),
                  color: const Color(0xfff4f5fe),
                ),
                child: const Icon(Ionicons.cloud_upload, color: ColorPalette.primary30),
              )
            : ClipRRect(
                borderRadius: widget.isCircular ? BorderRadius.circular(100) : BorderRadius.circular(12),
                child: Image.file(width: 60.w, height: 60.w, fit: BoxFit.cover, File(result!.files.first.path!)),
              ),
      ),
      Gap(16.h),
      CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          final result = await FilePicker.platform.pickFiles(type: FileType.image);
          if (result != null) {
            widget.onImageSelected(File(result.files.first.path!));
            setState(() {
              this.result = result;
            });
          }
        },
        minimumSize: Size.zero,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: ColorPalette.primary99,
            border: Border.all(color: ColorPalette.primary95),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.title,
            style: context.labelMedium?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ),
    ],
  );
}
