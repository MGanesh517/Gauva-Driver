import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/app_state.dart';

import '../../../data/models/driver_details_response/driver_details_response.dart';
import '../../../data/models/driver_info_update_response/driver_info_update_response.dart';
import '../../auth/provider/auth_providers.dart';
import '../view_model/profile_notifier.dart';

final profilePhotoUploadNotifierProvider =
    StateNotifierProvider.autoDispose<ProfilePhotoUploadNotifier, AppState<DriverInfoUpdateResponse>>(
      (ref) => ProfilePhotoUploadNotifier(ref: ref, authRepo: ref.read(authRepoProvider)),
    );

final driverDetailsNotifierProvider = StateNotifierProvider<DriverDetailsViewModel, AppState<DriverDetailsResponse>>(
  (ref) => DriverDetailsViewModel(ref: ref, authRepo: ref.read(authRepoProvider)),
);

final selectedAvatarProvider = StateNotifierProvider<SelectedAvatarNotifierProvider, Tuple2<int?, String?>>(
  (ref) => SelectedAvatarNotifierProvider(),
);
