import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

// Overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
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
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: GestureDetector(
          onTap: () async {
            await FlutterOverlayWindow.shareData('open_app');
          },
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF942FAF), // Brand color
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(76), blurRadius: 8, spreadRadius: 2)],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(child: Icon(Icons.local_taxi, color: Colors.white, size: 32)),
          ),
        ),
      ),
    );
  }
}
