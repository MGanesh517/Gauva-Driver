import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import '../../../../core/theme/color_palette.dart';
import '../../../../core/utils/is_dark_mode.dart';

class ChatItemOtherPerson extends StatefulWidget {
  final String message;
  final DateTime dateTime;
  final bool showTime;
  final Widget? image;

  const ChatItemOtherPerson({
    super.key,
    required this.message,
    required this.dateTime,
    this.showTime = false,
    this.image,
  });

  @override
  State<ChatItemOtherPerson> createState() => _ChatItemOtherPersonState();
}

class _ChatItemOtherPersonState extends State<ChatItemOtherPerson> {
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
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          constraints: BoxConstraints(maxWidth: width * 2 / 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.image != null) ...[
                ClipRRect(borderRadius: BorderRadius.circular(20.r), child: widget.image),
                SizedBox(width: 4.w),
              ],
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: isDarkMode() ? Colors.black : const Color(0xFFF6F7F9),
                          borderRadius: BorderRadius.circular(12.r),
                          border: isDarkMode() ? Border.all(color: Colors.white) : null,
                        ),
                        child: Text(
                          widget.message,
                          style: context.bodyMedium?.copyWith(color: context.theme.colorScheme.onSurfaceVariant),
                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
