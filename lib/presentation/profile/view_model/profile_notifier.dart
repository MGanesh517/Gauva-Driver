import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/data/models/driver_details_response/driver_details_response.dart';
import 'package:gauva_driver/data/models/driver_info_update_response/driver_info_update_response.dart';
import 'package:gauva_driver/data/models/user_model/user_model.dart';
import 'package:gauva_driver/data/repositories/interfaces/auth_repo_interface.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';

import '../../../core/state/app_state.dart';

import '../provider/profile_providers.dart';

class SelectedAvatarNotifierProvider extends StateNotifier<Tuple2<int?, String?>> {
  SelectedAvatarNotifierProvider() : super(const Tuple2(null, null));

  void selectLocalAvater({required int index, required String path}) => state = Tuple2(index, path);

  void selectRemoteAvatar({required String path}) => state = Tuple2(null, path);

  void reset() => state = const Tuple2(null, null);
}

class ProfilePhotoUploadNotifier extends StateNotifier<AppState<DriverInfoUpdateResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;
  ProfilePhotoUploadNotifier({required this.ref, required this.authRepo}) : super(const AppState.initial());

  Future<void> updateProfilePhoto({required String imagePath}) async {
    state = const AppState.loading();

    // Get current profile data to include name, email, mobile
    final currentState = ref.read(driverDetailsNotifierProvider);
    final User? currentUser = currentState.maybeWhen(success: (data) => data.data?.user, orElse: () => null);

    // Use updateProfile endpoint with the image file path
    // The service will handle it as multipart form data
    final result = await authRepo.updateProfile(
      data: {
        'name': currentUser?.name ?? '',
        'email': currentUser?.email ?? '',
        'mobile': currentUser?.mobile ?? '',
        'profileImage': imagePath, // Pass file path, service will detect it's a file
      },
    );
    result.fold(
      (failure) {
        state = AppState.error(failure);
        showNotification(message: failure.message);
      },
      (data) {
        state = AppState.success(data);
        showNotification(message: data.message ?? 'Profile photo updated successfully', isSuccess: true);
        ref.read(driverDetailsNotifierProvider.notifier).getDriverDetails();
        NavigationService.pop();
      },
    );
  }

  Future<String> getImagePathFromLocalAsset({required String imagePath}) async {
    final ByteData byteData = await rootBundle.load(imagePath);
    final List<int> bytes = byteData.buffer.asUint8List();

    final temDir = await getTemporaryDirectory();
    final file = await File('${temDir.path}/avatar.jpg').create(recursive: true);
    await file.writeAsBytes(bytes);
    return file.path;
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
      ref.invalidate(selectedAvatarProvider);
    });
  }
}

class DriverDetailsViewModel extends StateNotifier<AppState<DriverDetailsResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;
  DriverDetailsViewModel({required this.ref, required this.authRepo}) : super(const AppState.initial()) {
    getDriverDetails();
  }

  Future<void> getDriverDetails() async {
    state = const AppState.loading();
    final result = await authRepo.getDriverDetails();
    result.fold(
      (failure) {
        state = AppState.error(failure);
        showNotification(message: failure.message);
      },
      (data) async {
        if (data.data?.user != null) {
          print('💾 Profile Notifier: Saving fetched driver profile to storage...');
          await LocalStorageService().saveUser(data: data.data!.user!.toJson());
        }
        state = AppState.success(data);
      },
    );
  }
}
