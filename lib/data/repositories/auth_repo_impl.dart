import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/models/documents_upload_response/documents_upload_response.dart';
import 'package:gauva_driver/data/models/driver_details_response/driver_details_response.dart';
import 'package:gauva_driver/data/models/driver_info_update_response/driver_info_update_response.dart';
import 'package:gauva_driver/data/models/forgot_verify_otp_response/forgot_verify_otp_response.dart';
import 'package:gauva_driver/data/models/otp_verify_response/otp_verify_response.dart';
import 'package:gauva_driver/data/models/resend_otp_model/resend_otp_mode.dart';
import 'package:gauva_driver/data/repositories/base_repository.dart';
import 'package:gauva_driver/domain/interfaces/auth_service_interface.dart';

import '../../core/errors/failure.dart';
import '../models/login_response/login_response.dart';
import '../models/login_with_pass_response/login_with_pass_response.dart';
import 'interfaces/auth_repo_interface.dart';

class AuthRepoImpl extends BaseRepository implements IAuthRepository {
  final IAuthService authService;

  AuthRepoImpl({required this.authService});
  @override
  Future<Either<Failure, LoginResponse>> login({
    required String mobile,
    String? deviceToken,
    required String countryCode,
  }) async => await safeApiCall(() async {
    final response = await authService.login(phone: mobile, deviceToken: deviceToken, countryCode: countryCode);
    return LoginResponse.fromMap(response.data);
  });

  @override
  Future<Either<Failure, LoginWithPassResponse>> resendSignIn({
    required num? userId,
    required String? deviceToken,
  }) async => await safeApiCall(() async {
    final response = await authService.resendSignIn(userId: userId, deviceToken: deviceToken);
    return LoginWithPassResponse.fromMap(response.data);
  });

  @override
  Future<Either<Failure, OtpVerifyResponse>> verifyOtp({
    required String mobile,
    required String otp,
    String? deviceToken,
    String? wantLogin,
  }) async => await safeApiCall(() async {
    final response = await authService.verifyOtp(
      mobile: mobile,
      otp: otp,
      deviceToken: deviceToken,
      wantLogin: wantLogin,
    );
    return OtpVerifyResponse.fromMap(response.data);
  });

  @override
  Future<Either<Failure, CommonResponse>> updatePassword({required String password}) async =>
      await safeApiCall(() async {
        final response = await authService.updatePassword(password: password);
        return CommonResponse.fromJson(response.data);
      });

  @override
  Future<Either<Failure, CommonResponse>> changePassword({
    required String currentPassword,
    required String newPassword,
    required newConfirmPassword,
  }) async => await safeApiCall(() async {
    final response = await authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newConfirmPassword: newConfirmPassword,
    );
    return CommonResponse.fromJson(response.data);
  });

  @override
  Future<Either<Failure, ResendOtpModel>> resendOTP({required String mobile}) async => await safeApiCall(() async {
    final response = await authService.resendOTP(mobile: mobile);
    return ResendOtpModel.fromJson(response.data);
  });

  @override
  Future<Either<Failure, LoginWithPassResponse>> loginWithPassword({
    required String mobile,
    required String password,
    String? deviceToken,
    String? wantLogin,
  }) async => await safeApiCall(() async {
    final response = await authService.loginWithPassword(
      mobile: mobile,
      password: password,
      deviceToken: deviceToken,
      wantLogin: wantLogin,
    );
    try {
      return LoginWithPassResponse.fromMap(response.data);
    } catch (e) {
      return LoginWithPassResponse.fromMap(response.data);
    }
  });

  @override
  Future<Either<Failure, CommonResponse>> requestOTP({required String mobile}) async => await safeApiCall(() async {
    final response = await authService.requestOTP(mobile: mobile);
    return CommonResponse.fromJson(response.data);
  });

  @override
  Future<Either<Failure, ForgotVerifyOtpResponse>> forgetVerifyOtp({
    required String mobile,
    required String otp,
  }) async => await safeApiCall(() async {
    final response = await authService.forgetVerifyOtp(mobile: mobile, otp: otp);
    return ForgotVerifyOtpResponse.fromMap(response.data);
  });

  @override
  Future<Either<Failure, CommonResponse>> resetPassword({required Map<String, dynamic> data}) async =>
      await safeApiCall(() async {
        final response = await authService.resetPassword(data: data);
        return CommonResponse.fromJson(response.data);
      });

  @override
  Future<Either<Failure, DriverInfoUpdateResponse>> updatePersonalInfo({
    required File profilePicture,
    required Map<String, dynamic> data,
  }) async => await safeApiCall(() async {
    final response = await authService.updatePersonalInfo(data: data, profilePicture: profilePicture);
    return DriverInfoUpdateResponse.fromJson(response.data);
  });

  @override
  Future<Either<Failure, DriverInfoUpdateResponse>> updateProfile({required Map<String, dynamic> data}) async =>
      await safeApiCall(() async {
        final response = await authService.updateProfile(data: data);
        return DriverInfoUpdateResponse.fromJson(response.data);
      });

  @override
  Future<Either<Failure, CommonResponse>> updateVehicleDetails({
    required List<File> documents,
    required Map<String, dynamic> data,
  }) async => await safeApiCall(() async {
    final response = await authService.updateVehicleDetails(data: data, documents: documents);
    return CommonResponse.fromJson(response.data);
  });

  @override
  Future<Either<Failure, CommonResponse>> logout() async => await safeApiCall(() async {
    final response = await authService.logout();
    return CommonResponse.fromJson(response.data);
  });

  @override
  Future<Either<Failure, DocumentsUploadResponse>> uploadDocuments({
    required File profilePicture,
    required List<File> documents,
  }) async => await safeApiCall(() async {
    final response = await authService.uploadDocuments(profilePicture: profilePicture, documents: documents);
    return DocumentsUploadResponse.fromMap(response.data);
  });

  @override
  Future<Either<Failure, DriverDetailsResponse>> getDriverDetails() async => await safeApiCall(() async {
    final response = await authService.getDriverDetails();
    try {
      return DriverDetailsResponse.fromJson(response.data);
    } catch (e) {
      return DriverDetailsResponse.fromJson(response.data);
    }
  });

  @override
  Future<Either<Failure, CommonResponse>> updateProfilePhoto({required String imagePath}) async =>
      await safeApiCall(() async {
        final response = await authService.updateProfilePhoto(imagePath: imagePath);
        return CommonResponse.fromJson(response.data);
      });

  // New API implementations
  @override
  Future<Either<Failure, LoginWithPassResponse>> driverRegister({
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
    return await safeApiCall(() async {
      final response = await authService.driverRegister(
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
      return LoginWithPassResponse.fromMap(response.data);
    });
  }

  @override
  Future<Either<Failure, LoginWithPassResponse>> driverLoginEmailPassword({
    required String identifier,
    required String password,
  }) async {
    return await safeApiCall(() async {
      final response = await authService.driverLoginEmailPassword(identifier: identifier, password: password);
      return LoginWithPassResponse.fromMap(response.data);
    });
  }

  @override
  Future<Either<Failure, CommonResponse>> driverLoginOtpSend({required String phoneNumber}) async {
    return await safeApiCall(() async {
      final response = await authService.driverLoginOtpSend(phoneNumber: phoneNumber);
      return CommonResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, LoginWithPassResponse>> driverLoginOtpVerify({
    required String idToken,
    required String role,
  }) async {
    return await safeApiCall(() async {
      final response = await authService.driverLoginOtpVerify(idToken: idToken, role: role);
      return LoginWithPassResponse.fromMap(response.data);
    });
  }

  @override
  Future<Either<Failure, CommonResponse>> driverLogout() async {
    return await safeApiCall(() async {
      final response = await authService.driverLogout();
      return CommonResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, CommonResponse>> saveFcmToken({required String token}) async {
    return await safeApiCall(() async {
      final response = await authService.saveFcmToken(token: token);
      // Backend returns { "status": "ok" } which doesn't match CommonResponse structure directly
      // So we manually construct a success response
      if (response.statusCode == 200 || response.data['status'] == 'ok') {
        return const CommonResponse(success: true, message: 'FCM Token registered successfully');
      }
      return CommonResponse.fromJson(response.data);
    });
  }

  // Forgot Password implementations
  @override
  Future<Either<Failure, CommonResponse>> forgotPassword({required String email}) async {
    return await safeApiCall(() async {
      final response = await authService.forgotPassword(email: email);
      return CommonResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, CommonResponse>> verifyPasswordResetOtp({required String email, required String otp}) async {
    return await safeApiCall(() async {
      final response = await authService.verifyPasswordResetOtp(email: email, otp: otp);
      return CommonResponse.fromJson(response.data);
    });
  }

  @override
  Future<Either<Failure, CommonResponse>> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    return await safeApiCall(() async {
      final response = await authService.resetPasswordWithOtp(email: email, otp: otp, newPassword: newPassword);
      return CommonResponse.fromJson(response.data);
    });
  }
}
