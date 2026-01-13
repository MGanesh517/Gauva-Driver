class ApiEndpoints {
  static const String mediator = 'driver';
  static const String loginUrl = '/sign-in/$mediator';
  static const String resendSignIn = '/resend-sign-in';
  static const String resendOTP = '/resend-otp';
  static const String updatePassword = '/password-setup';
  static const String requestOTP = '/forgot-password/request-otp';
  static const String forgetVerifyOtp = '/forgot-password/verify-otp';
  static const String resetPassword = '/forgot-password/reset-password';
  static const String changePassword = '/v1/driver/change-password';
  static const String updatePersonalInfo = '$mediator/personal-info';
  static const String updateProfile = '/v1/driver/profile';
  static const String updateVehicleDetails = '$mediator/professional-info';
  static const String updateProfilePhoto = '/update/$mediator/profile-photo';
  static const String uploadDocuments = '/upload-documents';
  static const String getCarColors = '/configs/vehicle-color-details';
  static const String getCarModels = '/configs/vehicle-details';
  static const String onlineOfflineStatusUpdate = '$mediator/update-status';
  static const String updateRadius = '/radius-update';
  static const String getDriverDetails = '/v1/driver/profile';
  static const String logout = '/sign-out';
  static const String sendMessage = '/send-message';
  static const String getMessage = '/message';
  static const String orderRide = '$mediator/order';
  static const String checkActiveTrip = '/v1/driver/rides/started';
  static const String dashboard = '/v1/driver/dashboard';
  static const String cancelRide = '/cancel-ride';
  static const String driverLocationsUpdate = '/v1/driver/locations/update';
  static const String rideHistory = '/v1/ride/driver/history';
  static const String earnings = '/earning';
  static const String paymentMethods = '/payment-method';
  static const String wallets = '/$mediator/wallet';
  static const String walletBalance = '/v1/driver/wallet/balance'; // New endpoint
  static const String walletTransactions = '/v1/driver/wallet/transactions'; // New endpoint
  static const String withdraw = '/$mediator/withdraw';
  static const String addCard = '/$mediator/add-card';
  static const String myCard = '/$mediator/my-card';
  static const String deleteCard = '/$mediator/delete-card';
  static const String transactionHistory = '/$mediator/transaction/details';
  static const String paymentTransactions = '/v1/payments/transactions';
  static const String getReportTypes = '/report-types';
  static const String submitReport = '/report-create';
  static const String deleteAccount = '/$mediator/destroy';
  static const String getCountryList = '/configs/country-code';
  static const String termsAndConditions = '/legal-terms';
  static const String privacyPolicy = '/privacy-policy';
  static const String sendTravelInfo = '/$mediator/locations/send-travel-info';

  // New API endpoints (without /api prefix since Environment.apiUrl already includes it)
  static const String driverRegister = '/v1/auth/register/driver/documents';
  static const String driverLogin = '/v1/auth/login';
  static const String driverLoginOtpSend = '/v1/auth/login/otp';
  static const String driverLoginOtpVerify = '/v1/auth/login/otp';
  static const String driverLogout = '/v1/auth/logout/driver';
  static const String driverStatusOnline = '/v1/driver/status/online';

  // Driver Ride APIs (matching HTML tool flow)
  static const String getCurrentRide = '/v1/driver'; // /{driverId}/current_ride (legacy)
  static const String getCurrentRides = '/v1/driver/rides/current'; // GET current rides (accepted/started)
  static const String getStartedRides = '/v1/driver/rides/started';
  static const String getAllocatedRides = '/v1/driver/rides/allocated';
  static const String getCompletedRides = '/v1/driver/rides/completed';
  static const String acceptRide = '/v1/ride'; // /{rideId}/accept
  static const String declineRide = '/v1/ride'; // /{rideId}/decline
  static const String startRide = '/v1/ride'; // /{rideId}/start
  static const String completeRide = '/v1/ride'; // /{rideId}/complete
  static const String getRideDetails = '/v1/ride'; // /{rideId}
  static const String cancelRideDriver = '/v1/ride'; // /{rideId}/cancel/driver
  static const String goToPickup = 'driver/order'; // /{id}/go_to_pickup
  static const String saveFcmToken = '/notifications/token';
  static const String getWebSocketUrl = '/customer/config/websocket-url';
  static const String rateCard = '/public/legal-documents/rate-card/driver';

  // Forgot Password endpoints
  static const String forgotPassword = '/v1/auth/forgot-password';
  static const String verifyPasswordResetOtp = '/v1/auth/verify-password-reset-otp';
  static const String resetPasswordWithOtp = '/v1/auth/reset-password';

  // Subscription APIs
  static const String subscriptionPlans = '/v1/driver/subscriptions/plans';
  static const String currentSubscription = '/v1/driver/subscriptions/current';
  static const String purchaseSubscription = '/v1/driver/subscriptions/purchase';
  static const String verifySubscriptionPayment = '/v1/driver/subscriptions/verify-payment';
  static const String subscriptionHistory = '/v1/driver/subscriptions/history';
  static const String coupons = '/v1/driver/subscriptions/coupons';

  // Notification APIs
  // Note: Environment.apiUrl already includes '/api', so endpoints should not start with '/api'
  static const String notificationsInbox = '/notifications/inbox';
  static const String notificationsUnreadCount = '/notifications/inbox/unread/count';
  static const String notificationMarkRead = '/notifications/inbox'; // /{id}/read
  static const String notificationsMarkAllRead = '/notifications/inbox/read-all';
  static const String notificationsClearAll = '/notifications/inbox';
}
