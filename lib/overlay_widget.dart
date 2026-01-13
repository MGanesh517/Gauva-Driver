import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

// Overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  debugPrint("🟢 OV: Starting Overlay Entry Point...");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: OverlayWidget()));
}

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  @override
  void initState() {
    super.initState();
    debugPrint("🟢 OV: OverlayWidget Initialized");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🟢 OV: OverlayWidget Building...");
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () async {
          await FlutterOverlayWindow.closeOverlay();
          await FlutterOverlayWindow.shareData('open_app');
        },
        child: Container(
          height: 110,
          width: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 4,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon - Similar to Rapido style (bigger)
              Container(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/app-logo.png',
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.local_taxi, color: Colors.amber, size: 32),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              // Text similar to "rapido Captain" style (bigger)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  "Gauva",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.0,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Partner",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black87, height: 1.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
