// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';
// import 'package:gauva_driver/data/services/local_storage_service.dart';
// import 'package:gauva_driver/presentation/booking/provider/home_providers.dart';
//
// import '../provider/ride_providers.dart';
// import '../provider/slider_provider.dart';
//
// class CashPaymentConfirmation extends StatelessWidget {
//   const CashPaymentConfirmation({super.key,});
//
//   @override
//   Widget build(BuildContext context) => SafeArea(
//       child: Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.only(topRight: Radius.circular(30,), topLeft: Radius.circular(30)),
//           color: Colors.white,
//
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Consumer(
//               builder: (context, ref, _){
//                 final order = ref.read(rideOrderNotifierProvider);
//                 final data = order.maybeWhen(orElse: ()=> null, success: (d)=> d);
//                 final rider = data?.rider;
//
//                 final bool isLoading = ref.watch(sliderButtonNotifierProvider).when(initial: ()=> false, loading: ()=> true, success: (d)=> false, error: (e)=> false);
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 12,),
//                     ClipOval(
//                       child: CachedNetworkImage(
//                         imageUrl: rider?.profilePicture ?? '',
//                         height: 80,
//                         width: 80,
//                         fit: BoxFit.fill,
//                         placeholder: (context, url) => const CircularProgressIndicator(),
//                         errorWidget: (context, url, error) => const Icon(Icons.money_off, size: 80, color: Colors.red),
//                       ),
//                     ),
//                     const SizedBox(height: 8,),
//                     Text((data?.payableAmount ?? 'N/A').toString() + '₹', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.black),),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Have you collected the cash from ${rider?.name}?',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     const Text(
//                       'You cannot proceed without confirming the payment.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 36),
//                     AppPrimaryButton(
//                       isDisabled: isLoading,
//                       onPressed: ()async{
//                       final local = LocalStorageService();
//                       await ref.read(sliderButtonNotifierProvider.notifier).saveOrderStatus(status: 'completed');
//                       ref.read(sliderButtonNotifierProvider).maybeWhen(orElse: ()=> null, success: (d)async{
//                         ref.read(bookingNotifierProvider.notifier).resetToInitial();
//                         await local.clearOrderId();
//                         await local.saveChatState(isOpen: false);
//                       });
//
//                     }, child: const Text(
//                       'Yes, I have',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),),
//                     const SizedBox(height: 12),
//
//                   ],
//                 );
//               },
//
//             ),
//           ),
//         ),
//       ),
//     );
// }
