import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gauva_driver/common/shimmer_loader.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/is_arabic.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';

import '../../../core/enums/driver_status.dart';
import '../../../core/state/driver_status_state.dart';
import '../../../core/utils/localize.dart';
import '../../booking/provider/driver_providers.dart';

// Data model for switch states
class SwitchState {
  final bool isLoading;
  final bool isOnline;

  const SwitchState({required this.isLoading, required this.isOnline});
}

class SwitchConstants {
  static const double height = 40;
  static const double width = 170;
  static const double borderRadius = 28;
  static const double padding = 3;
  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Color borderColor = Color(0xFFEDEBFC);
  static const double borderWidth = 1;
}

// Text item
class SwitchTextItem extends StatelessWidget {
  final String text;
  final bool isActive;
  final bool isDarkMode;

  const SwitchTextItem({super.key, required this.text, required this.isActive, required this.isDarkMode});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.bodyMedium?.copyWith(color: _getTextColor(), fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ),
  );

  Color _getTextColor() {
    if (isActive) {
      return isDarkMode
          ? Colors.white
          : isArabic()
          ? ColorPalette.primary50
          : Colors.white;
    }
    return isDarkMode ? Colors.white : Colors.black;
  }
}

// Background
class AnimatedSwitchBackground extends StatelessWidget {
  final bool isOnline;

  const AnimatedSwitchBackground({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) => AnimatedAlign(
    alignment: !isOnline ? Alignment.centerLeft : Alignment.centerRight,
    duration: SwitchConstants.animationDuration,
    curve: Curves.easeInOutCubic,
    child: FractionallySizedBox(
      // ✅ takes half of parent width instead of fixed width
      widthFactor: 0.5,
      child: Container(
        height: SwitchConstants.height - (SwitchConstants.padding * 2),
        decoration: BoxDecoration(
          color: isOnline ? Colors.green : Colors.red, // Green for online, Red for offline
          borderRadius: BorderRadius.circular(SwitchConstants.borderRadius - SwitchConstants.padding),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
      ),
    ),
  );
}

// Main widget
class OnlineOfflineSwitch extends ConsumerWidget {
  const OnlineOfflineSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch both the state and the notifier to ensure UI updates
    final status = ref.watch(driverStatusNotifierProvider);
    final isOnlineFromNotifier = isOnlineNotifier.value;

    final switchState = _getSwitchState(ref, status);

    return GestureDetector(
      onTap: () => _handleTap(ref, isOnlineFromNotifier),
      child: _buildSwitchContainer(context, switchState),
    );
  }

  SwitchState _getSwitchState(WidgetRef ref, DriverStatusState status) {
    final bool isLoading = status.whenOrNull(loading: () => true) ?? false;
    final bool isOnlineFromState = status.whenOrNull(online: () => true, orderRequest: (d) => true) ?? false;

    // Debug logging
    print('🎨 UI Switch State - isLoading: $isLoading, isOnlineFromState: $isOnlineFromState, status: $status');

    return SwitchState(isLoading: isLoading, isOnline: isOnlineFromState);
  }

  void _handleTap(WidgetRef ref, bool isOnline) {
    final newStatus = isOnline ? DriverStatus.offline.name : DriverStatus.online.name;

    ref.read(driverStatusNotifierProvider.notifier).updateOnlineStatus(newStatus);
  }

  Widget _buildSwitchContainer(BuildContext context, SwitchState switchState) => Container(
    height: SwitchConstants.height.h,
    width: SwitchConstants.width.w,
    padding: EdgeInsets.all(SwitchConstants.padding.r),
    decoration: BoxDecoration(
      color: context.surface,
      borderRadius: BorderRadius.circular(SwitchConstants.borderRadius.r),
      border: Border.all(color: SwitchConstants.borderColor, width: SwitchConstants.borderWidth.w),
    ),
    child: switchState.isLoading ? _buildLoadingState() : _buildActiveState(context, switchState),
  );

  Widget _buildLoadingState() => buildShimmer(
    height: SwitchConstants.height,
    width: double.infinity,
    borderRadius: BorderRadius.circular(SwitchConstants.borderRadius),
  );

  Widget _buildActiveState(BuildContext context, SwitchState switchState) {
    final isDark = isDarkMode();

    return Stack(
      children: [
        AnimatedSwitchBackground(isOnline: switchState.isOnline),
        Row(
          children: [
            SwitchTextItem(text: localize(context).offline, isActive: !switchState.isOnline, isDarkMode: isDark),
            SwitchTextItem(text: localize(context).lets_ride, isActive: switchState.isOnline, isDarkMode: isDark),
          ],
        ),
      ],
    );
  }
}

// Factory function for backward compatibility
Widget onlineOfflineSwitch(BuildContext context) => const OnlineOfflineSwitch();

final ValueNotifier<bool> isOnlineNotifier = ValueNotifier<bool>(false);
