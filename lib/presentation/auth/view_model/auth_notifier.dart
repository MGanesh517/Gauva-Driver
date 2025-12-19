import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/core/state/app_state.dart';
import 'package:gauva_driver/core/utils/device_token_firebase.dart';
import 'package:gauva_driver/data/models/documents_upload_response/documents_upload_response.dart';
import 'package:gauva_driver/data/models/driver_info_update_response/driver_info_update_response.dart';
import 'package:gauva_driver/data/models/login_response/login_response.dart';
import 'package:gauva_driver/data/repositories/interfaces/auth_repo_interface.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:gauva_driver/presentation/auth/provider/auth_providers.dart';
import 'package:gauva_driver/presentation/auth/widgets/warning.dart';
import 'package:gauva_driver/presentation/booking/provider/ride_providers.dart';
import 'package:gauva_driver/presentation/profile/provider/profile_providers.dart';
import 'package:gauva_driver/presentation/splash/provider/app_flow_providers.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/common_response.dart';
import '../../../data/models/login_with_pass_response/login_with_pass_response.dart';
import '../../../data/models/otp_verify_response/otp_verify_response.dart';
import '../../../data/models/resend_otp_model/resend_otp_mode.dart';

class LoginNotifier extends StateNotifier<AppState<LoginResponse>> {
  final IAuthRepository authRepoProvider;
  final Ref ref;
  LoginNotifier({required this.authRepoProvider, required this.ref}) : super(const AppState.initial());

  Future<void> login({required String phone, required String countryCode}) async {
    state = const AppState.loading();
    final String? deviceToken = await deviceTokenFirebase();
    await LocalStorageService().clearToken();
    final response = await authRepoProvider.login(mobile: phone, deviceToken: deviceToken, countryCode: countryCode);
    response.fold(
      (failure) {
        showNotification(message: failure.message);
        return state = AppState.error(failure);
      },
      (loginResponse) {
        _handleLoginSuccess(loginResponse, countryCode);
        return state = AppState.success(loginResponse);
      },
    );
  }

  void _handleLoginSuccess(LoginResponse loginResponse, String countryCode) {
    final localStorage = LocalStorageService();
    final isNewUser = loginResponse.data?.isNewDriver == true;
    final isUnderReview = loginResponse.data?.isUnderReview == true;
    if (isNewUser) {
      showNotification(message: 'otp: ${loginResponse.data?.otp}', isSuccess: true);
      localStorage
        ..savePhoneCode(countryCode)
        ..setRegistrationProgress(AppRoutes.verifyOTP);
      NavigationService.pushNamed(AppRoutes.verifyOTP, arguments: (loginResponse.data?.otp ?? '').toString());
    } else {
      if (isUnderReview) {
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.profileUnderReview);
      } else {
        NavigationService.pushNamed(AppRoutes.loginWithPassword);
      }
    }
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class LoginWithPassNotifier extends StateNotifier<AppState<LoginWithPassResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;

  LoginWithPassNotifier({required this.ref, required this.authRepo}) : super(const AppState.initial());

  Future<void> loginWithPassword({required String mobile, required String password, String? wantLogin}) async {
    state = const AppState.loading();
    final String? deviceToken = await deviceTokenFirebase();
    await LocalStorageService().clearToken();
    final result = await authRepo.loginWithPassword(
      mobile: mobile,
      password: password,
      deviceToken: deviceToken,
      wantLogin: wantLogin,
    );
    result.fold(
      (failure) {
        showNotification(message: failure.message);
        return state = AppState.error(failure);
      },
      (data) async {
        showNotification(message: data.message, isSuccess: !(data.data?.otherDevice ?? false));
        if (data.data?.otherDevice != null && data.data?.otherDevice == true) {
          final bool? wantLogin = await showWarning();
          if (wantLogin == true) {
            FocusScope.of(NavigationService.navigatorKey.currentContext!).unfocus();
            await loginWithPassword(mobile: mobile, password: password, wantLogin: 'yes');
          } else {
            NavigationService.pop();
            resetStateAfterDelay();
          }
          state = AppState.success(data);
          return;
        }
        await LocalStorageService().saveToken(data.data?.token);

        // Save user data and verify it was saved
        final userData = data.data?.user?.toJson();
        print(
          '💾 Auth (LoginWithPass): Saving user data - User ID: ${userData?['id']}, User data exists: ${userData != null}',
        );
        if (userData != null) {
          await LocalStorageService().saveUser(data: userData);
          // Verify user was saved
          final savedUserId = await LocalStorageService().getUserId();
          print('✅ Auth (LoginWithPass): User data saved - Verified driver ID: $savedUserId');
        } else {
          print('⚠️ Auth (LoginWithPass): User data is null, cannot save');
        }

        LocalStorageService().setRegistrationProgress(AppRoutes.dashboard);

        await ref.read(tripActivityNotifierProvider.notifier).checkTripActivity();
        state = AppState.success(data);
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class ResendSignInNotifier extends StateNotifier<AppState<LoginWithPassResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;

  ResendSignInNotifier({required this.ref, required this.authRepo}) : super(const AppState.initial());

  Future<void> resendSignIn({required num? userId, required String? deviceToken}) async {
    state = const AppState.loading();
    final String? deviceToken = await deviceTokenFirebase();
    await LocalStorageService().clearToken();
    final result = await authRepo.resendSignIn(userId: userId, deviceToken: deviceToken);
    result.fold(
      (failure) {
        showNotification(message: failure.message);
        return state = AppState.error(failure);
      },
      (data) async {
        showNotification(message: data.message, isSuccess: true);

        await LocalStorageService().saveToken(data.data?.token);
        await LocalStorageService().saveUser(data: data.data?.user?.toJson());
        LocalStorageService().setRegistrationProgress(AppRoutes.dashboard);
        state = AppState.success(data);
        // NavigationService.pushNamedAndRemoveUntil(AppRoutes.splash);
        ref
            .read(tripActivityNotifierProvider.notifier)
            .checkTripActivity(
              onSuccess: () {
                ref.read(appFlowViewModelProvider.notifier).setAppFlowState();
              },
            );
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class OtpVerifyNotifier extends StateNotifier<AppState<OtpVerifyResponse>> {
  final IAuthRepository authRepoProvider;
  final Ref ref;

  OtpVerifyNotifier({required this.authRepoProvider, required this.ref}) : super(const AppState.initial());

  /// Main method to verify OTP
  Future<void> verifyOTP({required String mobile, required String otp, String? wantLogin}) async {
    state = const AppState.loading();

    final deviceToken = await deviceTokenFirebase();
    final loginData = _getLoginData();

    final result = await authRepoProvider.verifyOtp(
      mobile: mobile,
      otp: otp,
      deviceToken: deviceToken,
      wantLogin: wantLogin,
    );

    result.fold(
      (failure) => _handleFailure(failure),
      (response) =>
          _handleSuccess(response, loginData, deviceToken: deviceToken, mobile: mobile, otp: otp, wantLogin: wantLogin),
    );
  }

  /// Handle success response
  void _handleSuccess(
    OtpVerifyResponse response,
    LoginResponse? loginData, {
    required String mobile,
    required String otp,
    String? wantLogin,
    String? deviceToken,
  }) async {
    final token = response.data?.token;
    final user = response.data?.user?.toJson();

    print(
      '🔐 Auth: OTP verification successful, token received: ${token != null ? "YES (length: ${token.length})" : "NO"}',
    );
    if (token != null && token.isNotEmpty) {
      await LocalStorageService().saveToken(token);
    } else {
      print('❌ Auth: Token is null or empty after OTP verification, cannot save!');
    }
    if (user != null) await LocalStorageService().saveUser(data: user);

    // Sync FCM Token
    if (token != null && token.isNotEmpty && deviceToken != null) {
      authRepoProvider.saveFcmToken(token: deviceToken);
    }

    // Navigate based on new driver flag
    final isNewDriver = loginData?.data?.isNewDriver ?? false;

    if (response.data?.otherDevice == true) {
      final bool? wantLogin = await showWarning();
      if (wantLogin == true) {
        FocusScope.of(NavigationService.navigatorKey.currentContext!).unfocus();
        await verifyOTP(mobile: mobile, otp: otp, wantLogin: 'yes');
      } else {
        NavigationService.pop();
        resetStateAfterDelay();
      }
    } else {
      if (isNewDriver) {
        _completeRegistration(AppRoutes.setPassword);
      } else {
        _completeRegistration(AppRoutes.dashboard);
      }
    }

    state = AppState.success(response);
    resetStateAfterDelay();
  }

  /// Handle API failure
  void _handleFailure(Failure failure) {
    showNotification(message: failure.message);
    state = AppState.error(failure);
  }

  /// Get login response data if exists
  LoginResponse? _getLoginData() =>
      ref.read(loginNotifierProvider).maybeWhen(success: (data) => data, orElse: () => null);

  /// Complete registration by saving progress and navigating
  void _completeRegistration(String route) {
    LocalStorageService().setRegistrationProgress(route);

    if (route == AppRoutes.dashboard) {
      ref
          .read(tripActivityNotifierProvider.notifier)
          .checkTripActivity(
            onSuccess: () {
              ref.read(appFlowViewModelProvider.notifier).setAppFlowState();
            },
          );
    } else {
      NavigationService.pushNamed(route);
    }
  }

  /// Reset state after small delay (for UI)
  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class UpdatePassViewModel extends StateNotifier<AppState<CommonResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;
  UpdatePassViewModel({required this.ref, required this.authRepo}) : super(const AppState.initial());

  Future<void> updatePassword({required String password}) async {
    state = const AppState.loading();
    final result = await authRepo.updatePassword(password: password);
    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) {
        showNotification(message: data.message, isSuccess: true);
        state = AppState.success(data);
        LocalStorageService().setRegistrationProgress(AppRoutes.driverPersonalInfoPage);
        NavigationService.pushNamed(AppRoutes.driverPersonalInfoPage);
        resetStateAfterDelay();
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class ResendOtpNotifier extends StateNotifier<AppState<ResendOtpModel>> {
  final IAuthRepository authRepo;
  final Ref ref;

  ResendOtpNotifier({required this.ref, required this.authRepo}) : super(const AppState.initial());

  Future<void> resendOtp({required String mobile, Function(ResendOtpModel data)? onSuccess}) async {
    state = const AppState.loading();
    final result = await authRepo.resendOTP(mobile: mobile);
    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) {
        showNotification(message: data.message, isSuccess: true);
        state = AppState.success(data);
        onSuccess != null ? onSuccess(data) : null;
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class ResetPasswordNotifier extends StateNotifier<AppState<CommonResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;
  ResetPasswordNotifier({required this.ref, required this.authRepo}) : super(const AppState.initial());

  Future<void> resetPassword({required Map<String, dynamic> data}) async {
    state = const AppState.loading();
    final result = await authRepo.resetPassword(data: data);
    result.fold((failure) => state = AppState.error(failure), (data) {
      showNotification(message: data.message, isSuccess: true);
      NavigationService.pushNamed(AppRoutes.login);
      state = AppState.success(data);
      resetStateAfterDelay();
    });
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class ChangePasswordNotifier extends StateNotifier<AppState<CommonResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;
  ChangePasswordNotifier({required this.ref, required this.authRepo}) : super(const AppState.initial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required newConfirmPassword,
  }) async {
    state = const AppState.loading();
    final result = await authRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newConfirmPassword: newConfirmPassword,
    );
    result.fold(
      (failure) {
        state = AppState.error(failure);
        showNotification(message: failure.message);
      },
      (data) {
        LocalStorageService().clearToken();
        LocalStorageService().clearUser();
        showNotification(message: data.message, isSuccess: true);
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.login);
        state = AppState.success(data);
        resetStateAfterDelay();
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class UpdatePersonalInfoNotifier extends StateNotifier<AppState<DriverInfoUpdateResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;
  UpdatePersonalInfoNotifier({required this.ref, required this.authRepo}) : super(const AppState.initial());

  Future<void> updatePersonalInfo({required File profilePicture, required Map<String, dynamic> data}) async {
    state = const AppState.loading();
    final result = await authRepo.updatePersonalInfo(data: data, profilePicture: profilePicture);
    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) {
        state = AppState.success(data);
        showNotification(message: data.message, isSuccess: true);
        LocalStorageService().setRegistrationProgress(AppRoutes.vehicleInfoPage);
        NavigationService.pushNamed(AppRoutes.vehicleInfoPage);
      },
    );
  }

  Future<void> updateProfile({required Map<String, dynamic> data}) async {
    state = const AppState.loading();
    final result = await authRepo.updateProfile(data: data);
    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) {
        state = AppState.success(data);
        showNotification(message: data.message, isSuccess: true);
        ref.read(driverDetailsNotifierProvider.notifier).getDriverDetails();
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class UpdateVehicleDetailsNotifier extends StateNotifier<AppState<CommonResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;
  UpdateVehicleDetailsNotifier({required this.ref, required this.authRepo}) : super(const AppState.initial());

  Future<void> updateVehicleDetails({required List<File> documents, required Map<String, dynamic> data}) async {
    state = const AppState.loading();
    final result = await authRepo.updateVehicleDetails(data: data, documents: documents);
    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) {
        showNotification(message: data.message, isSuccess: true);
        state = AppState.success(data);
        LocalStorageService().setRegistrationProgress(AppRoutes.profileUnderReview);
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.profileUnderReview);
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class LogoutNotifier extends StateNotifier<AppState<CommonResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;
  LogoutNotifier({required this.authRepo, required this.ref}) : super(const AppState.initial());

  Future<void> logout() async {
    state = const AppState.loading();
    final result = await authRepo.driverLogout();
    result.fold(
      (failure) {
        state = AppState.error(failure);
        showNotification(message: failure.message);
      },
      (data) {
        LocalStorageService().clearStorage();

        showNotification(message: data.message, isSuccess: true);
        state = AppState.success(data);
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.login);
        resetStateAfterDelay();
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class DocumentUploadNotifier extends StateNotifier<AppState<DocumentsUploadResponse>> {
  final IAuthRepository authRepo;
  DocumentUploadNotifier({required this.authRepo}) : super(const AppState.initial());

  Future<void> uploadDocuments({required File profilePicture, required List<File> documents}) async {
    state = const AppState.loading();
    final result = await authRepo.uploadDocuments(profilePicture: profilePicture, documents: documents);
    ();
    result.fold(
      (failure) {
        state = AppState.error(failure);
      },
      (data) {
        state = AppState.success(data);
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class RequiredDocsNotifier extends StateNotifier<List<File>> {
  RequiredDocsNotifier() : super([]);

  void addFile(File file) {
    state = [...state, file];
  }

  void removeFile(File file) {
    state = state.where((element) => element.path != file.path).toList();
  }

  void updateFile(int index, File file) {
    state[index] = file;
  }

  List<File> getFiles() => state;
}

// New notifiers for new API endpoints
class DriverRegisterNotifier extends StateNotifier<AppState<LoginWithPassResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;

  DriverRegisterNotifier({required this.authRepo, required this.ref}) : super(const AppState.initial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String mobile,
    required double latitude,
    required double longitude,
    required String vehicleType,
    required String serviceType,
    required String vehicleNumber,
    required String vehicleColor,
    required String vehicleModel,
    required String licenseNumber,
    required String aadhaarNumber,
    required String rcNumber,
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String ifscCode,
    required String upiId,
    File? profilePhoto,
    File? licenseFront,
    File? licenseBack,
    File? rcFront,
    File? rcBack,
    File? aadhaarFront,
    File? aadhaarBack,
  }) async {
    state = const AppState.loading();
    final result = await authRepo.driverRegister(
      name: name,
      email: email,
      password: password,
      mobile: mobile,
      latitude: latitude,
      longitude: longitude,
      vehicleType: vehicleType,
      serviceType: serviceType,
      vehicleNumber: vehicleNumber,
      vehicleColor: vehicleColor,
      vehicleModel: vehicleModel,
      licenseNumber: licenseNumber,
      aadhaarNumber: aadhaarNumber,
      rcNumber: rcNumber,
      accountHolderName: accountHolderName,
      bankName: bankName,
      accountNumber: accountNumber,
      ifscCode: ifscCode,
      upiId: upiId,
      profilePhoto: profilePhoto,
      licenseFront: licenseFront,
      licenseBack: licenseBack,
      rcFront: rcFront,
      rcBack: rcBack,
      aadhaarFront: aadhaarFront,
      aadhaarBack: aadhaarBack,
    );
    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) async {
        if (data.data?.token != null) {
          await LocalStorageService().saveToken(data.data!.token!);
        }
        if (data.data?.user != null) {
          await LocalStorageService().saveUser(data: data.data!.user!.toJson());
        }
        // Sync FCM Token
        final deviceToken = await deviceTokenFirebase();
        if (deviceToken != null) {
          authRepo.saveFcmToken(token: deviceToken);
        }

        LocalStorageService().setRegistrationProgress(AppRoutes.dashboard);
        showNotification(message: data.message ?? 'Registration successful', isSuccess: true);
        state = AppState.success(data);
        // Only check trip activity if we have a token (user is authenticated)
        if (data.data?.token != null) {
          await ref.read(tripActivityNotifierProvider.notifier).checkTripActivity();
        } else {
          // Navigate directly to dashboard if no token (registration might require email verification, etc.)
          NavigationService.pushNamedAndRemoveUntil(AppRoutes.dashboard);
        }
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class DriverLoginEmailPasswordNotifier extends StateNotifier<AppState<LoginWithPassResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;

  DriverLoginEmailPasswordNotifier({required this.authRepo, required this.ref}) : super(const AppState.initial());

  Future<void> login({required String identifier, required String password}) async {
    state = const AppState.loading();
    await LocalStorageService().clearToken();

    final result = await authRepo.driverLoginEmailPassword(identifier: identifier, password: password);
    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) async {
        // Save accessToken (prefer root level accessToken, fallback to data.token for backward compatibility)
        final token = data.accessToken ?? data.data?.token;
        if (token != null) {
          await LocalStorageService().saveToken(token);
        }
        // Save refreshToken if available (you may want to add a method to save refreshToken)
        // if (data.refreshToken != null) {
        //   await LocalStorageService().saveRefreshToken(data.refreshToken!);
        // }
        if (data.data?.user != null) {
          await LocalStorageService().saveUser(data: data.data!.user!.toJson());
        }
        // Sync FCM Token
        final deviceToken = await deviceTokenFirebase();
        if (deviceToken != null) {
          authRepo.saveFcmToken(token: deviceToken);
        }

        LocalStorageService().setRegistrationProgress(AppRoutes.dashboard);
        showNotification(message: data.message ?? 'Login successful', isSuccess: true);
        state = AppState.success(data);
        await ref.read(tripActivityNotifierProvider.notifier).checkTripActivity();
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}

class DriverLoginOtpNotifier extends StateNotifier<AppState<CommonResponse>> {
  final IAuthRepository authRepo;
  final Ref ref;

  DriverLoginOtpNotifier({required this.authRepo, required this.ref}) : super(const AppState.initial());

  Future<void> sendOtp({required String phoneNumber}) async {
    state = const AppState.loading();
    final result = await authRepo.driverLoginOtpSend(phoneNumber: phoneNumber);
    result.fold(
      (failure) {
        showNotification(message: failure.message);
        state = AppState.error(failure);
      },
      (data) {
        showNotification(message: data.message ?? 'OTP sent successfully', isSuccess: true);
        state = AppState.success(data);
      },
    );
  }

  Future<void> verifyOtp({required String idToken, required String role}) async {
    await LocalStorageService().clearToken();

    final result = await authRepo.driverLoginOtpVerify(idToken: idToken, role: role);
    result.fold(
      (failure) {
        showNotification(message: failure.message);
      },
      (data) async {
        if (data.data?.token != null) {
          await LocalStorageService().saveToken(data.data!.token!);
        }
        if (data.data?.user != null) {
          await LocalStorageService().saveUser(data: data.data!.user!.toJson());
        }
        // Sync FCM Token
        final deviceToken = await deviceTokenFirebase();
        if (deviceToken != null) {
          authRepo.saveFcmToken(token: deviceToken);
        }

        LocalStorageService().setRegistrationProgress(AppRoutes.dashboard);
        showNotification(message: data.message ?? 'Login successful', isSuccess: true);
        await ref.read(tripActivityNotifierProvider.notifier).checkTripActivity();
      },
    );
  }

  void resetStateAfterDelay() {
    Future.delayed(Duration.zero, () {
      state = const AppState.initial();
    });
  }
}
