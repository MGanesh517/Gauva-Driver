import 'package:flutter/material.dart';

export 'app_marker_drop_off.dart';
export 'app_marker_pickup.dart';

class AppMarker extends StatelessWidget {
  final Widget title;
  final bool showPickUp;

  const AppMarker({
    super.key,
    required this.title,
    this.showPickUp = true

  });

  @override
  Widget build(BuildContext context) => Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: showPickUp ? const EdgeInsets.only(bottom: 20, right: 40) : const EdgeInsets.only(bottom: 40, right: 80),
          constraints: const BoxConstraints(
            maxWidth: 250,
            maxHeight: 60,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1464748B),
                offset: Offset(2, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: title,
        ),

      ],
    );
}

