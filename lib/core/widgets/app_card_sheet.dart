import 'package:flutter/material.dart';
import '../utils/is_dark_mode.dart';

class AppCardSheet extends StatelessWidget {
  final Widget child;
  final bool showHandle;
  final bool isFullScreen;
  final EdgeInsets? padding;

  const AppCardSheet({
    super.key,
    required this.child,
    this.showHandle = true,
    this.isFullScreen = false,
    this.padding
  });

  @override
  Widget build(BuildContext context) => Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: isFullScreen
            ? null
            : const BorderRadius.vertical(top: Radius.circular(30)),
        color: isDarkMode() ? Colors.black : Colors.white,
        boxShadow: isFullScreen
            ? null
            : const [
          BoxShadow(
            color: Color(0x3F0E275D),
            blurRadius: 20,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Container(height: 4, width: 40, color: const Color(0xFFD7DAE0), margin: const EdgeInsets.only(bottom: 8),),
          child,
        ],
      ),
    );
}
