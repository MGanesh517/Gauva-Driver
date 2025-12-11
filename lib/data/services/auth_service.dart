import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gauva_driver/core/config/api_endpoints.dart';
import 'package:gauva_driver/data/services/api/dio_client.dart';
import 'package:gauva_driver/domain/interfaces/auth_service_interface.dart';

import 'local_storage_service.dart';

class AuthServiceImpl extends IAuthService {
  final DioClient dioClient;

  AuthServiceImpl({required this.dioClient});
  @override
  Future<Response> forgetVerifyOtp({required String mobile, required String otp}) async =>
      await dioClient.dio.post(ApiEndpoints.forgetVerifyOtp, data: {'mobile': mobile, 'otp': otp});

  @override
  Future<Response> login({required String phone, required String countryCode, String? deviceToken}) async =>
      await dioClient.dio.post(
        ApiEndpoints.loginUrl,
        data: {'mobile': phone, 'device_token': deviceToken, 'country_code': countryCode},
      );

  @override
  Future<Response> resendSignIn({required num? userId, required String? deviceToken}) async =>
      await dioClient.dio.post('${ApiEndpoints.resendSignIn}/$userId', data: {'device_token': deviceToken});

  @override
  Future<Response> loginWithPassword({
    required String mobile,
    required String password,
    String? deviceToken,
    String? wantLogin,
  }) async {
    final url = wantLogin == null ? ApiEndpoints.loginUrl : '${ApiEndpoints.loginUrl}?is_login=yes';
    return await dioClient.dio.post(
      url,
      data: {
        'mobile': mobile,
        'country_code': await LocalStorageService().getCountryCode(),
        'password': password,
        'device_token': deviceToken,
      },
    );
  }

  @override
  Future<Response> verifyOtp({
    required String mobile,
    required String otp,
    String? deviceToken,
    String? wantLogin,
  }) async {
    final url = wantLogin == null ? ApiEndpoints.loginUrl : '${ApiEndpoints.loginUrl}?is_login=yes';
    return await dioClient.dio.post(
      url,
      data: {
        'mobile': mobile,
        'country_code': await LocalStorageService().getCountryCode(),
        'otp': otp,
        'device_token': deviceToken,
      },
    );
  }

  @override
  Future<Response> changePassword({
    required String currentPassword,
    required String newPassword,
    required newConfirmPassword,
  }) async {
    return await dioClient.dio.post(
      ApiEndpoints.changePassword,
      data: {'currentPassword': currentPassword, 'newPassword': newPassword, 'confirmPassword': newConfirmPassword},
    );
  }

  @override
  Future<Response> logout() async => await dioClient.dio.get(ApiEndpoints.logout);

  @override
  Future<Response> requestOTP({required String mobile}) async =>
      await dioClient.dio.post(ApiEndpoints.requestOTP, data: {'mobile': mobile});

  @override
  Future<Response> resendOTP({required String mobile}) async =>
      await dioClient.dio.post(ApiEndpoints.resendOTP, data: {'mobile': mobile});

  @override
  Future<Response> resetPassword({required Map<String, dynamic> data}) async =>
      await dioClient.dio.post(ApiEndpoints.resetPassword, data: data);

  @override
  Future<Response> updatePassword({required String password}) async =>
      dioClient.dio.post(ApiEndpoints.updatePassword, data: {'password': password, 'password_confirmation': password});

  @override
  Future<Response> updateProfilePhoto({required String imagePath}) async {
    final FormData formData = FormData.fromMap({'profile_picture': await MultipartFile.fromFile(imagePath)});
    return await dioClient.dio.post(ApiEndpoints.updateProfilePhoto, data: formData);
  }

  @override
  Future<Response> updatePersonalInfo({required File profilePicture, required Map<String, dynamic> data}) async {
    final FormData formData = FormData();

    formData.files.add(
      MapEntry(
        'profile_picture',
        await MultipartFile.fromFile(profilePicture.path, filename: profilePicture.path.split('/').last),
      ),
    );

    data.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });
    return await dioClient.dio.post(
      ApiEndpoints.updatePersonalInfo,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data', 'Accept': 'application/json'}),
    );
  }

  @override
  Future<Response> updateProfile({required Map<String, dynamic> data}) async {
    final url = ApiEndpoints.updateProfile;
    final fullUrl = '${dioClient.dio.options.baseUrl}$url';
    print('🚀 Update Profile URL: $fullUrl');

    // The new API expects: name, email, mobile, profileImage (as URL string or file)
    // Check if profileImage is a local file path
    final profileImage = data['profileImage'];
    final isLocalFile =
        profileImage is String &&
        profileImage.isNotEmpty &&
        !profileImage.startsWith('http') &&
        !profileImage.startsWith('https');

    if (isLocalFile) {
      try {
        final file = File(profileImage);
        if (await file.exists()) {
          print('📁 Uploading profile image file: $profileImage');
          // Upload as multipart form data with file
          final formData = FormData();

          // Add the image file
          formData.files.add(
            MapEntry('profileImage', await MultipartFile.fromFile(profileImage, filename: profileImage.split('/').last)),
          );

          // Add other fields (name, email, mobile)
          data.forEach((key, value) {
            if (key != 'profileImage' && value != null) {
              formData.fields.add(MapEntry(key, value.toString()));
            }
          });

          print(
            '📦 Request Data (Multipart): name=${data['name']}, email=${data['email']}, mobile=${data['mobile']}, profileImage=FILE',
          );

          return await dioClient.dio.put(
            ApiEndpoints.updateProfile,
            data: formData,
            options: Options(headers: {'Content-Type': 'multipart/form-data', 'Accept': 'application/json'}),
          );
        } else {
          print('⚠️ File does not exist: $profileImage');
        }
      } catch (e) {
        print('❌ Error checking file: $e');
      }
    }

    // If it's a URL string or file doesn't exist, send as JSON
    print('📦 Request Data (JSON): ${data.toString().replaceAll(RegExp(r'profileImage: [^,}]+'), 'profileImage: ***')}');
    return await dioClient.dio.put(ApiEndpoints.updateProfile, data: data);
  }

  @override
  Future<Response> updateVehicleDetails({required List<File> documents, required Map<String, dynamic> data}) async {
    if (documents.length < 3) {
      throw Exception('Documents list must contain at least 3 files: nid, license, vehicle_paper');
    }

    final formData = FormData.fromMap({
      'documents[nid]': await MultipartFile.fromFile(documents[0].path, filename: documents[0].path.split('/').last),
      'documents[license]': await MultipartFile.fromFile(documents[1].path, filename: documents[1].path.split('/').last),
      'documents[vehicle_paper]': await MultipartFile.fromFile(
        documents[2].path,
        filename: documents[2].path.split('/').last,
      ),
      ...data, // vehicle_type, vehicle_color etc.
    });

    return await dioClient.dio.post(
      ApiEndpoints.updateVehicleDetails,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data', 'Accept': 'application/json'}),
    );
  }

  @override
  Future<Response> uploadDocuments({required File profilePicture, required List<File> documents}) async {
    // Convert files to MultipartFile
    final FormData formData = FormData();

    formData.files.addAll([
      MapEntry(
        'profile_picture',
        await MultipartFile.fromFile(profilePicture.path, filename: profilePicture.path.split('/').last),
      ),
    ]);

    for (var doc in documents) {
      formData.files.add(
        MapEntry(
          'documents[]', // Ensure correct key for multiple files
          await MultipartFile.fromFile(doc.path, filename: doc.path.split('/').last),
        ),
      );
    }

    return await dioClient.dio.post(
      ApiEndpoints.uploadDocuments,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data', 'Accept': 'application/json'}),
    );
  }

  @override
  Future<Response> getDriverDetails() async => await dioClient.dio.get(ApiEndpoints.getDriverDetails);

  // New API implementations
  @override
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
  }) async {
    final url = ApiEndpoints.driverRegister;
    final fullUrl = '${dioClient.dio.options.baseUrl}$url';

    // Build query parameters
    final queryParams = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'mobile': mobile,
      'latitude': latitude,
      'longitude': longitude,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'vehicleColor': vehicleColor,
      'vehicleModel': vehicleModel,
      'licenseNumber': licenseNumber,
      'aadhaarNumber': aadhaarNumber,
      'rcNumber': rcNumber,
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'upiId': upiId,
    };

    // Build multipart form data for file uploads
    final formData = FormData();

    // Add query parameters as fields
    queryParams.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    });

    // Add files to form data
    if (profilePhoto != null) {
      formData.files.add(
        MapEntry(
          'profilePhoto',
          await MultipartFile.fromFile(profilePhoto.path, filename: profilePhoto.path.split('/').last),
        ),
      );
    }
    if (licenseFront != null) {
      formData.files.add(
        MapEntry(
          'licenseFront',
          await MultipartFile.fromFile(licenseFront.path, filename: licenseFront.path.split('/').last),
        ),
      );
    }
    if (licenseBack != null) {
      formData.files.add(
        MapEntry(
          'licenseBack',
          await MultipartFile.fromFile(licenseBack.path, filename: licenseBack.path.split('/').last),
        ),
      );
    }
    if (rcFront != null) {
      formData.files.add(
        MapEntry('rcFront', await MultipartFile.fromFile(rcFront.path, filename: rcFront.path.split('/').last)),
      );
    }
    if (rcBack != null) {
      formData.files.add(
        MapEntry('rcBack', await MultipartFile.fromFile(rcBack.path, filename: rcBack.path.split('/').last)),
      );
    }
    if (aadhaarFront != null) {
      formData.files.add(
        MapEntry(
          'aadhaarFront',
          await MultipartFile.fromFile(aadhaarFront.path, filename: aadhaarFront.path.split('/').last),
        ),
      );
    }
    if (aadhaarBack != null) {
      formData.files.add(
        MapEntry(
          'aadhaarBack',
          await MultipartFile.fromFile(aadhaarBack.path, filename: aadhaarBack.path.split('/').last),
        ),
      );
    }

    print('🚀 Registration URL: $fullUrl');
    print('📦 Query Params: ${queryParams.toString()}');
    print(
      '📁 Files: profilePhoto=${profilePhoto != null}, licenseFront=${licenseFront != null}, licenseBack=${licenseBack != null}, rcFront=${rcFront != null}, rcBack=${rcBack != null}, aadhaarFront=${aadhaarFront != null}, aadhaarBack=${aadhaarBack != null}',
    );

    return await dioClient.dio.post(
      url,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data', 'Accept': 'application/json'}),
    );
  }

  @override
  Future<Response> driverLoginEmailPassword({required String identifier, required String password}) async {
    final url = ApiEndpoints.driverLogin;
    final fullUrl = '${dioClient.dio.options.baseUrl}$url';
    print('🚀 Login URL: $fullUrl');
    print('📦 Request Data: {identifier: $identifier, password: ***, role: DRIVER}');

    return await dioClient.dio.post(url, data: {'identifier': identifier, 'password': password, 'role': 'DRIVER'});
  }

  @override
  Future<Response> driverLoginOtpSend({required String phoneNumber}) async {
    final url = ApiEndpoints.driverLoginOtpSend;
    final fullUrl = '${dioClient.dio.options.baseUrl}$url';
    print('🚀 Send OTP URL: $fullUrl');
    print('📱 Phone Number: $phoneNumber');

    return await dioClient.dio.post(url, data: {'phoneNumber': phoneNumber});
  }

  @override
  Future<Response> driverLoginOtpVerify({required String idToken, required String role}) async {
    final url = ApiEndpoints.driverLoginOtpVerify;
    final fullUrl = '${dioClient.dio.options.baseUrl}$url';
    print('🚀 Verify OTP URL: $fullUrl');

    return await dioClient.dio.post(url, data: {'idToken': idToken, 'role': role});
  }

  @override
  Future<Response> driverLogout() async {
    final url = ApiEndpoints.driverLogout;
    final fullUrl = '${dioClient.dio.options.baseUrl}$url';
    print('🚀 Logout URL: $fullUrl');

    return await dioClient.dio.post(url);
  }
}
