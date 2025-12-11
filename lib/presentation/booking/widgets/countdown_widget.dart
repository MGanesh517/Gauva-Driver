// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../view_model/reverse_timer_notifier.dart';
//
// class ReverseTimerWidget extends ConsumerStatefulWidget {
//
//
//   const ReverseTimerWidget({super.key,});
//
//   @override
//   ConsumerState<ReverseTimerWidget> createState() => _ReverseTimerWidgetState();
// }
//
// class _ReverseTimerWidgetState extends ConsumerState<ReverseTimerWidget> {
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // Start timer
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     ref.read(reverseTimerProvider.notifier).startTimer();
//   //   });
//   // }
//
//   String formatTime(int totalSeconds) {
//     final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
//     final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Watch the same _params instance
//     final remaining = ref.watch(reverseTimerProvider);
//
//     return Text(
//       formatTime(remaining),
//       style: const TextStyle(
//         fontSize: 48,
//         fontWeight: FontWeight.bold,
//         color: Colors.red,
//       ),
//     );
//   }
// }
