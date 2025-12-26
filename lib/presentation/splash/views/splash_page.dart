import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/presentation/booking/provider/ride_providers.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../account_page/provider/country_list_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation for text
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Scale animation for text
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));

    // Slide animation for subtitle
    _slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    Future.microtask(() => ref.read(countryListProvider.notifier).getCountryList());
    _checkSavedToken();
    _startSplashAnimation();
  }

  /// Check and log the saved token from local storage
  Future<void> _checkSavedToken() async {
    try {
      print('🔍 Splash: Checking saved token...');
      final token = await LocalStorageService().getToken();

      if (token != null && token.isNotEmpty) {
        print('✅ Splash: Token found in storage');
        print('📝 Splash: Token length: ${token.length}');
        print('📝 Splash: Token preview: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');

        // Also check if user is logged in
        final isLoggedIn = await LocalStorageService().isLoggedIn();
        print('🔍 Splash: isLoggedIn status: $isLoggedIn');

        // Get user ID if available
        final userId = await LocalStorageService().getUserId();
        if (userId != null) {
          print('👤 Splash: User ID found: $userId');
        } else {
          print('⚠️ Splash: User ID not found in storage');
        }
      } else {
        print('❌ Splash: No token found in storage');
        print('🔍 Splash: User needs to login');
      }
    } catch (e, stackTrace) {
      print('❌ Splash: Error checking token: $e');
      print('❌ Splash: Stack trace: $stackTrace');
    }
  }

  void _startSplashAnimation() {
    // Start animations in sequence
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      _fadeController.forward();
      _scaleController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _slideController.forward();
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Future.microtask(() {
        ref.read(tripActivityNotifierProvider.notifier).checkTripActivity();
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      systemNavigationBarIconBrightness: Brightness.light, // navigation bar icons
    ),
    child: Scaffold(
      extendBody: true, // Allow body to extend behind safe area (though container handles it)
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF397098), Color(0xFF942FAF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main title with animations
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Text(
                      'Gauva',
                      style: GoogleFonts.inter(
                        fontSize: 64.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                    ),
                  ),
                ),
                Gap(16.h),
                // Subtitle with slide animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Partner',
                      style: GoogleFonts.inter(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 4,
                        color: Colors.white.withOpacity(0.9),
                        shadows: [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
