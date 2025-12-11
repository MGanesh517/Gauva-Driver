import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import '../../../../core/theme/color_palette.dart';

class ChatItemMe extends StatefulWidget {
  final String message;
  final DateTime dateTime;
  final bool showTime;
  final Widget? image;

  const ChatItemMe({super.key, required this.message, required this.dateTime, this.showTime = false, this.image});

  @override
  State<ChatItemMe> createState() => _ChatItemMeState();
}

class _ChatItemMeState extends State<ChatItemMe> {
  late bool _showTime;

  @override
  void initState() {
    super.initState();
    _showTime = widget.showTime;
  }

  void _toggleTimeVisibility() {
    setState(() {
      _showTime = !_showTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: _toggleTimeVisibility,
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          constraints: BoxConstraints(maxWidth: width * 2 / 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: ColorPalette.primary50,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(widget.message, style: context.bodyMedium?.copyWith(color: ColorPalette.neutral99)),
                      ),
                      SizedBox(height: 4.h),
                      if (_showTime)
                        Text(
                          widget.dateTime.formattedSmartTimestamp,
                          style: context.bodySmall?.copyWith(color: ColorPalette.neutralVariant50),
                        ),
                    ],
                  ),
                ),
              ),
              if (widget.image != null) ...[widget.image!, SizedBox(width: 8.w)],
            ],
          ),
        ),
      ),
    );
  }
}
