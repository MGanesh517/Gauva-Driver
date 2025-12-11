import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/presentation/booking/provider/ride_providers.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';

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
  late AnimationController _particleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _particleAnimation;

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

    // Particle animation
    _particleController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _particleController, curve: Curves.linear));

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

    Future.delayed(const Duration(seconds: 2), () {
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
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF397098), Color(0xFF942FAF)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated particles in background
              _buildParticles(),
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Main title with animations
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              const LinearGradient(colors: [Colors.white, Colors.white70]).createShader(bounds),
                          child: Text(
                            'Gauva',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 64.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
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
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 4,
                            color: Colors.white.withOpacity(0.9),
                            shadows: [
                              Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(40.h),
                    // Loading indicator
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(painter: ParticlePainter(_particleAnimation.value), size: Size.infinite);
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;

  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Create floating particles
    for (int i = 0; i < 20; i++) {
      final x = (size.width * 0.2) + (i * size.width * 0.05);
      final y = size.height * 0.3 + (size.height * 0.4 * ((animationValue + i * 0.1) % 1.0));

      canvas.drawCircle(Offset(x, y), 3 + (i % 3) * 2, paint..color = Colors.white.withOpacity(0.2 + (i % 3) * 0.1));
    }

    // Create gradient circles
    for (int i = 0; i < 10; i++) {
      final radius = size.width * 0.3;
      final centerX = size.width / 2;
      final centerY = size.height / 2;

      final x = centerX + radius * 0.5 * (i % 2 == 0 ? 1 : -1) * (0.5 + 0.5 * (animationValue % 1.0));
      final y = centerY + radius * 0.3 * (i % 2 == 0 ? 1 : -1) * (0.5 + 0.5 * ((animationValue + 0.5) % 1.0));

      canvas.drawCircle(Offset(x, y), 8 + (i % 3) * 4, paint..color = Colors.white.withOpacity(0.15));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
