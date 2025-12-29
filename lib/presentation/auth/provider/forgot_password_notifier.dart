import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauva_driver/core/utils/helpers.dart';
import 'package:gauva_driver/data/repositories/interfaces/auth_repo_interface.dart';
import '../../../data/services/navigation_service.dart';
import '../../../core/routes/app_routes.dart';

// State classes
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;
  ForgotPasswordSuccess(this.message);
}

class ForgotPasswordError extends ForgotPasswordState {
  final String error;
  ForgotPasswordError(this.error);
}

// Notifier for sending OTP
class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final IAuthRepository authRepository;

  ForgotPasswordNotifier(this.authRepository) : super(ForgotPasswordInitial());

  Future<void> sendOtp(String email) async {
    state = ForgotPasswordLoading();

    final result = await authRepository.forgotPassword(email: email);

    result.fold(
      (failure) {
        state = ForgotPasswordError(failure.message);
        showNotification(message: failure.message);
      },
      (response) {
        state = ForgotPasswordSuccess(response.message ?? 'OTP sent successfully to your email');
        showNotification(message: response.message ?? 'OTP sent successfully to your email');
        // Navigate to reset password screen with email as argument
        NavigationService.pushNamed('/reset-password', arguments: email);
      },
    );
  }

  void reset() {
    state = ForgotPasswordInitial();
  }
}

// State classes for reset password
abstract class ForgotPasswordResetState {}

class ForgotPasswordResetInitial extends ForgotPasswordResetState {}

class ForgotPasswordResetLoading extends ForgotPasswordResetState {}

class ForgotPasswordResetSuccess extends ForgotPasswordResetState {
  final String message;
  ForgotPasswordResetSuccess(this.message);
}

class ForgotPasswordResetError extends ForgotPasswordResetState {
  final String error;
  ForgotPasswordResetError(this.error);
}

// Notifier for resetting password
class ForgotPasswordResetNotifier extends StateNotifier<ForgotPasswordResetState> {
  final IAuthRepository authRepository;

  ForgotPasswordResetNotifier(this.authRepository) : super(ForgotPasswordResetInitial());

  Future<void> resetPassword({required String email, required String otp, required String newPassword}) async {
    state = ForgotPasswordResetLoading();

    final result = await authRepository.resetPasswordWithOtp(email: email, otp: otp, newPassword: newPassword);

    result.fold(
      (failure) {
        state = ForgotPasswordResetError(failure.message);
        showNotification(message: failure.message);
      },
      (response) {
        state = ForgotPasswordResetSuccess(response.message ?? 'Password reset successfully');
        showNotification(message: response.message ?? 'Password reset successfully');
        // Navigate back to login
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.login);
      },
    );
  }

  void reset() {
    state = ForgotPasswordResetInitial();
  }
}
