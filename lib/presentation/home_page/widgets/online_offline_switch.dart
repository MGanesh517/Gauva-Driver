import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/is_arabic.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';

import '../../../core/enums/driver_status.dart';

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
class OnlineOfflineSwitch extends ConsumerStatefulWidget {
  const OnlineOfflineSwitch({super.key});

  @override
  ConsumerState<OnlineOfflineSwitch> createState() => _OnlineOfflineSwitchState();
}

class _OnlineOfflineSwitchState extends ConsumerState<OnlineOfflineSwitch> {
  // Local state for optimistic updates
  late bool _isOnline;
  bool _isCheckingSubscription = false;

  @override
  void initState() {
    super.initState();
    // Initialize with the current value from the global notifier as a safe bet,
    // or default to false. We will sync with provider in build/didChangeDependencies.
    _isOnline = isOnlineNotifier.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncStateWithProvider();
  }

  void _syncStateWithProvider() {
    final status = ref.read(driverStatusNotifierProvider);
    status.maybeWhen(
      online: () => _isOnline = true,
      offline: () => _isOnline = false,
      onTrip: () => _isOnline = true,
      orderRequest: (_) => _isOnline = true,
      loading: () {
        // Did not update local state on loading to preserve optimistic value
      },
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to state changes to sync local state when operation completes
    ref.listen(driverStatusNotifierProvider, (previous, next) {
      next.maybeWhen(
        online: () => setState(() => _isOnline = true),
        offline: () => setState(() => _isOnline = false),
        onTrip: () => setState(() => _isOnline = true),
        orderRequest: (_) => setState(() => _isOnline = true),
        orElse: () {},
      );
    });

    final status = ref.watch(driverStatusNotifierProvider);
    final isDriverLoading = status.maybeWhen(loading: () => true, orElse: () => false);
    final isLoading = isDriverLoading || _isCheckingSubscription;

    // If strictly loading, we rely on _isOnline (optimistic or previous).
    // If not loading, _isOnline should match the state (enforced by listener above).

    return GestureDetector(
      onTap: () => _handleTap(isLoading),
      child: Container(
        height: SwitchConstants.height.h,
        width: SwitchConstants.width.w,
        padding: EdgeInsets.all(SwitchConstants.padding.r),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(SwitchConstants.borderRadius.r),
          border: Border.all(color: SwitchConstants.borderColor, width: SwitchConstants.borderWidth.w),
        ),
        child: _buildActiveState(context, _isOnline, isLoading),
      ),
    );
  }

  Future<void> _handleTap(bool isLoading) async {
    if (isLoading) return;

    // If trying to go online, check subscription first
    // Subscription check removed as per new requirement.

    // Optimistic Update
    setState(() {
      _isOnline = !_isOnline;
    });

    final newStatus = _isOnline ? DriverStatus.online.name : DriverStatus.offline.name;
    ref.read(driverStatusNotifierProvider.notifier).updateOnlineStatus(newStatus);
  }

  Widget _buildActiveState(BuildContext context, bool isOnline, bool isLoading) {
    final isDark = isDarkMode();

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitchBackground(isOnline: isOnline),
        Row(
          children: [
            SwitchTextItem(text: localize(context).offline, isActive: !isOnline, isDarkMode: isDark),
            SwitchTextItem(text: localize(context).lets_ride, isActive: isOnline, isDarkMode: isDark),
          ],
        ),
        if (isLoading)
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ),
      ],
    );
  }
}

// Factory function for backward compatibility
Widget onlineOfflineSwitch(BuildContext context) => const OnlineOfflineSwitch();

final ValueNotifier<bool> isOnlineNotifier = ValueNotifier<bool>(false);
