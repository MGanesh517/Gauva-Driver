import 'dart:io';

import 'package:dio/dio.dart';

abstract class IAuthService {
  Future<Response> login({required String phone, required String countryCode, String? deviceToken});
  Future<Response> resendSignIn({required num? userId, required String? deviceToken});
  Future<Response> loginWithPassword({
    required String mobile,
    required String password,
    String? deviceToken,
    String? wantLogin,
  });
  Future<Response> verifyOtp({required String mobile, required String otp, String? deviceToken, String? wantLogin});
  Future<Response> updatePassword({required String password});
  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
    required newConfirmPassword,
  });

  Future<Response> resendOTP({required String mobile});
  Future<Response> updateProfilePhoto({required String imagePath});
  Future<Response> requestOTP({required String mobile});
  Future<Response> forgetVerifyOtp({required String mobile, required String otp});
  Future<Response> resetPassword({required Map<String, dynamic> data});
  Future<Response> updatePersonalInfo({required File profilePicture, required Map<String, dynamic> data});
  Future<Response> updateProfile({required Map<String, dynamic> data});
  Future<Response> updateVehicleDetails({required List<File> documents, required Map<String, dynamic> data});
  Future<Response> uploadDocuments({required File profilePicture, required List<File> documents});
  Future<Response> getDriverDetails();
  Future<Response> logout();

  // New API methods
  Future<Response> driverRegister({
    required String name,
    required String email,
    required String password,
    required String mobile,
    required double latitude,
    required double longitude,
    required String vehicleType,
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
  });
  Future<Response> driverLoginEmailPassword({required String identifier, required String password});
  Future<Response> driverLoginOtpSend({required String phoneNumber});
  Future<Response> driverLoginOtpVerify({required String idToken, required String role});
  Future<Response> driverLogout();
}
