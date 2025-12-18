// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(msg) => "${msg} All rights reserved.";

  static String m1(msg) => "Are You Sure You Want to ${msg} from App";

  static String m2(msg) => "Error: ${msg}";

  static String m8(error) => "Error: ${error}";

  static String m9(error) => "Verification Failed: ${error}";

  static String m3(length) => "Must be at least ${length} characters";

  static String m4(secondsRemaining) => "Resend code in 00:${secondsRemaining}";

  static String m5(length) => "Use at least ${length} characters";

  static String m6(method) =>
      "paid via ${method}. We hope you had a great ride! Don\'t forget to leave a rating.";

  static String m7(amount) =>
      "Success! You\'ve requested ${amount} withdrawal. Funds will be transferred to your selected account shortly.";

  static String m10(msg) => "Write ${msg}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aadhaar_back": MessageLookupByLibrary.simpleMessage("Aadhaar Back"),
    "aadhaar_front": MessageLookupByLibrary.simpleMessage("Aadhaar Front"),
    "aadhaar_length_error": MessageLookupByLibrary.simpleMessage(
      "Aadhaar number must be exactly 12 digits",
    ),
    "aadhaar_number": MessageLookupByLibrary.simpleMessage("Aadhaar Number"),
    "aadhaar_number_hint": MessageLookupByLibrary.simpleMessage(
      "Enter 12-digit Aadhaar number",
    ),
    "accept_ride": MessageLookupByLibrary.simpleMessage("Accept Ride"),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "account_holder_name": MessageLookupByLibrary.simpleMessage(
      "Account Holder Name",
    ),
    "account_holder_name_hint": MessageLookupByLibrary.simpleMessage(
      "Enter account holder name as per bank records",
    ),
    "account_number": MessageLookupByLibrary.simpleMessage("Account Number"),
    "account_number_hint": MessageLookupByLibrary.simpleMessage(
      "Enter bank account number (9-18 digits, numbers only)",
    ),
    "account_number_length_error": MessageLookupByLibrary.simpleMessage(
      "Account number must be between 9 and 18 digits",
    ),
    "account_number_numeric_error": MessageLookupByLibrary.simpleMessage(
      "Account number must contain only numbers",
    ),
    "activity": MessageLookupByLibrary.simpleMessage("Activity"),
    "add_balance_to_your_wallet": MessageLookupByLibrary.simpleMessage(
      "Add Balance to Your Wallet",
    ),
    "add_driver_documents": MessageLookupByLibrary.simpleMessage(
      "Add Driver Documents",
    ),
    "add_driver_personal_info": MessageLookupByLibrary.simpleMessage(
      "Add Driver Personal Info",
    ),
    "add_new": MessageLookupByLibrary.simpleMessage("Add New"),
    "add_payment_gateway": MessageLookupByLibrary.simpleMessage(
      "Add Payment Gateway",
    ),
    "add_wallet": MessageLookupByLibrary.simpleMessage("Add Wallet"),
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "all_field_required": MessageLookupByLibrary.simpleMessage(
      "All field required",
    ),
    "all_rights_reserved": m0,
    "all_set_start_ride": MessageLookupByLibrary.simpleMessage(
      "All Set? Start the Ride Now",
    ),
    "allow": MessageLookupByLibrary.simpleMessage("Allow"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "app_encountered_unexpected_error": MessageLookupByLibrary.simpleMessage(
      "The app encountered an unexpected error and had to close. This could be caused by insufficient device memory, a bug in the app, or a corrupted file. Please restart the app or reinstall it if the issue continues.",
    ),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "are_you_sure_msg": m1,
    "arrived_pickup_point": MessageLookupByLibrary.simpleMessage(
      "You’ve Arrived at the Pickup Point",
    ),
    "average_rating": MessageLookupByLibrary.simpleMessage("Average Rating"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "bad_certificate_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Bad certificate with API server",
    ),
    "bad_request": MessageLookupByLibrary.simpleMessage("Bad request"),
    "bank_name": MessageLookupByLibrary.simpleMessage("Bank Name"),
    "bank_name_hint": MessageLookupByLibrary.simpleMessage(
      "Enter bank name (e.g., State Bank of India)",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancel_ride": MessageLookupByLibrary.simpleMessage("Cancel Ride"),
    "cancel_subtitle": MessageLookupByLibrary.simpleMessage(
      "Let us know the reason for canceling your ride.",
    ),
    "cancel_the_ride": MessageLookupByLibrary.simpleMessage("Cancel the ride"),
    "cancel_title": MessageLookupByLibrary.simpleMessage(
      "Tell Us Why You\'re Cancelling The Ride",
    ),
    "card_number": MessageLookupByLibrary.simpleMessage("Card no"),
    "cardholder_name": MessageLookupByLibrary.simpleMessage("Cardholder Name"),
    "change_password": MessageLookupByLibrary.simpleMessage("Change Password"),
    "close": MessageLookupByLibrary.simpleMessage("CLOSE"),
    "complete_ride": MessageLookupByLibrary.simpleMessage("Complete Ride"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirm_new_password": MessageLookupByLibrary.simpleMessage(
      "Confirm New Password",
    ),
    "confirm_password": MessageLookupByLibrary.simpleMessage(
      "Confirm Password",
    ),
    "confirm_pay": MessageLookupByLibrary.simpleMessage("Confirm Pay"),
    "confirm_pickup": MessageLookupByLibrary.simpleMessage("Confirm Pickup"),
    "connection_error_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Connection error with API server",
    ),
    "connection_timeout_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Connection timeout with API server",
    ),
    "contact_support": MessageLookupByLibrary.simpleMessage("Contact Support"),
    "country": MessageLookupByLibrary.simpleMessage("Country"),
    "current_balance": MessageLookupByLibrary.simpleMessage("Current Balance"),
    "current_password": MessageLookupByLibrary.simpleMessage(
      "Current Password",
    ),
    "cvv": MessageLookupByLibrary.simpleMessage("CVV"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "delete_account": MessageLookupByLibrary.simpleMessage("Delete Account"),
    "delete_account_confirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete your account?",
    ),
    "delete_account_warning": MessageLookupByLibrary.simpleMessage(
      "This action is permanent and cannot be undone.",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Destination"),
    "details": MessageLookupByLibrary.simpleMessage("Details"),
    "discount": MessageLookupByLibrary.simpleMessage("Discount"),
    "dont_have_account": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? ",
    ),
    "double_check_rider": MessageLookupByLibrary.simpleMessage(
      "Double-check the rider’s name and verify their destination before proceeding.",
    ),
    "driver_documents": MessageLookupByLibrary.simpleMessage(
      "Driver Documents",
    ),
    "driving_license": MessageLookupByLibrary.simpleMessage("Driving License"),
    "driving_license_required": MessageLookupByLibrary.simpleMessage(
      "Driving License is required",
    ),
    "either_phone_number_is_null_or_password_is_empty":
        MessageLookupByLibrary.simpleMessage(
          "Either phone number is null or password is empty",
        ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "email_hint": MessageLookupByLibrary.simpleMessage("Enter your email"),
    "email_hint_example": MessageLookupByLibrary.simpleMessage(
      "Enter your email address (e.g., name@example.com)",
    ),
    "email_label": MessageLookupByLibrary.simpleMessage("Email"),
    "emergency_phone": MessageLookupByLibrary.simpleMessage("Emergency Phone"),
    "enterPhoneDes": MessageLookupByLibrary.simpleMessage(
      "Enter your phone number to continue your ride and stay updated.",
    ),
    "enterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Enter phone number",
    ),
    "enter_3_digit_cvv": MessageLookupByLibrary.simpleMessage(
      "Enter 3-digit CVV",
    ),
    "enter_a_valid_amount": MessageLookupByLibrary.simpleMessage(
      "Enter a valid amount",
    ),
    "enter_aadhaar_number_error": MessageLookupByLibrary.simpleMessage(
      "Please enter Aadhaar number",
    ),
    "enter_account_holder_name_error": MessageLookupByLibrary.simpleMessage(
      "Please enter account holder name",
    ),
    "enter_account_number_error": MessageLookupByLibrary.simpleMessage(
      "Please enter account number",
    ),
    "enter_amount": MessageLookupByLibrary.simpleMessage("Enter Amount"),
    "enter_bank_name_error": MessageLookupByLibrary.simpleMessage(
      "Please enter bank name",
    ),
    "enter_cardholder_name": MessageLookupByLibrary.simpleMessage(
      "Enter cardholder name",
    ),
    "enter_details_complete_profile": MessageLookupByLibrary.simpleMessage(
      "Enter your details to complete your profile and enhance your experience.",
    ),
    "enter_email_error": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "enter_experience": MessageLookupByLibrary.simpleMessage(
      "Enter your Experience!",
    ),
    "enter_full_name_error": MessageLookupByLibrary.simpleMessage(
      "Please enter your full name",
    ),
    "enter_ifsc_code_error": MessageLookupByLibrary.simpleMessage(
      "Please enter IFSC code",
    ),
    "enter_license_number_error": MessageLookupByLibrary.simpleMessage(
      "Please enter license number",
    ),
    "enter_password": MessageLookupByLibrary.simpleMessage(
      "Enter your Password",
    ),
    "enter_password_description": MessageLookupByLibrary.simpleMessage(
      "Please enter your account password to continue.",
    ),
    "enter_password_error": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "enter_phone_error": MessageLookupByLibrary.simpleMessage(
      "Please enter phone number",
    ),
    "enter_plate_number": MessageLookupByLibrary.simpleMessage(
      "Enter plate no",
    ),
    "enter_rc_number_error": MessageLookupByLibrary.simpleMessage(
      "Please enter RC number",
    ),
    "enter_upi_id_error": MessageLookupByLibrary.simpleMessage(
      "Please enter UPI ID",
    ),
    "enter_valid_card_number": MessageLookupByLibrary.simpleMessage(
      "Enter valid card number",
    ),
    "enter_valid_email_error": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email address",
    ),
    "enter_valid_ifsc_error": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid IFSC code (e.g., ABCD0123456)",
    ),
    "enter_valid_phone_error": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid 10-digit phone number",
    ),
    "enter_valid_upi_error": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid UPI ID (e.g., name@paytm)",
    ),
    "enter_vehicle_color_error": MessageLookupByLibrary.simpleMessage(
      "Please enter vehicle color",
    ),
    "enter_vehicle_model_error": MessageLookupByLibrary.simpleMessage(
      "Please enter vehicle model",
    ),
    "enter_vehicle_name": MessageLookupByLibrary.simpleMessage(
      "Enter vehicle name",
    ),
    "enter_vehicle_number_error": MessageLookupByLibrary.simpleMessage(
      "Please enter vehicle number",
    ),
    "enter_vehicle_type_error": MessageLookupByLibrary.simpleMessage(
      "Please enter vehicle type",
    ),
    "error_with_msg": m2,
    "estimated_time": MessageLookupByLibrary.simpleMessage("Estimated Time"),
    "exit": MessageLookupByLibrary.simpleMessage("Exit"),
    "exp_date": MessageLookupByLibrary.simpleMessage("Exp. Date"),
    "expiryDate": MessageLookupByLibrary.simpleMessage("Expiry Date"),
    "field_required": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "find_you_faster": MessageLookupByLibrary.simpleMessage(
      "Let’s Find You Faster!",
    ),
    "find_you_faster_msg": MessageLookupByLibrary.simpleMessage(
      "Enable location access to get matched with nearby drivers quickly and easily.",
    ),
    "follow_directions_comfortable": MessageLookupByLibrary.simpleMessage(
      "Follow the directions, stay calm, and create a comfortable ride environment.",
    ),
    "forbidden_access_please_login_again": MessageLookupByLibrary.simpleMessage(
      "Forbidden access. Please login again.",
    ),
    "form_is_not_valid": MessageLookupByLibrary.simpleMessage(
      "Form is not valid",
    ),
    "full_name": MessageLookupByLibrary.simpleMessage("Full Name"),
    "full_name_hint": MessageLookupByLibrary.simpleMessage(
      "Full name as per ID proof",
    ),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "gender_female": MessageLookupByLibrary.simpleMessage("Female"),
    "gender_label": MessageLookupByLibrary.simpleMessage("Gender"),
    "gender_male": MessageLookupByLibrary.simpleMessage("Male"),
    "gender_other": MessageLookupByLibrary.simpleMessage("Other"),
    "gender_required": MessageLookupByLibrary.simpleMessage(
      "Gender is required",
    ),
    "gender_select": MessageLookupByLibrary.simpleMessage("Select Gender"),
    "go_back_to_ride": MessageLookupByLibrary.simpleMessage("Go back to ride"),
    "go_to_login": MessageLookupByLibrary.simpleMessage("Go to Login"),
    "go_to_pickup_location": MessageLookupByLibrary.simpleMessage(
      "Go to Pickup Location",
    ),
    "grant_permission": MessageLookupByLibrary.simpleMessage(
      "Grant Permission",
    ),
    "helloText": MessageLookupByLibrary.simpleMessage("Hello..."),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "id": MessageLookupByLibrary.simpleMessage("ID: "),
    "ifsc_code": MessageLookupByLibrary.simpleMessage("IFSC Code"),
    "ifsc_code_hint": MessageLookupByLibrary.simpleMessage(
      "Enter IFSC code (e.g., SBIN0001234)",
    ),
    "initializing": MessageLookupByLibrary.simpleMessage("Initializing..."),
    "insertAllData": MessageLookupByLibrary.simpleMessage(
      "Please insert all Data",
    ),
    "intercityActionAccept": MessageLookupByLibrary.simpleMessage("Accept"),
    "intercityActionReject": MessageLookupByLibrary.simpleMessage("Reject"),
    "intercityActionRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "intercityBookingType": MessageLookupByLibrary.simpleMessage(
      "Booking Type",
    ),
    "intercityBookings": MessageLookupByLibrary.simpleMessage("Bookings"),
    "intercityCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "intercityCar": MessageLookupByLibrary.simpleMessage("Car"),
    "intercityComplete": MessageLookupByLibrary.simpleMessage("Complete"),
    "intercityCreateNewTrip": MessageLookupByLibrary.simpleMessage(
      "Create New Trip",
    ),
    "intercityDepartureTime": MessageLookupByLibrary.simpleMessage(
      "Departure Time",
    ),
    "intercityDistance": MessageLookupByLibrary.simpleMessage("Distance (km)"),
    "intercityDriverTitle": MessageLookupByLibrary.simpleMessage(
      "Intercity Driver",
    ),
    "intercityDropAddress": MessageLookupByLibrary.simpleMessage(
      "Drop Address (Edit if needed)",
    ),
    "intercityDropLat": MessageLookupByLibrary.simpleMessage("Drop Lat"),
    "intercityDropLng": MessageLookupByLibrary.simpleMessage("Drop Lng"),
    "intercityEnterOtpDialog": MessageLookupByLibrary.simpleMessage(
      "Enter OTP",
    ),
    "intercityError": m8,
    "intercityFromCity": MessageLookupByLibrary.simpleMessage(
      "From City/Area (Search)",
    ),
    "intercityLabel": MessageLookupByLibrary.simpleMessage("Intercity"),
    "intercityLabelAmount": MessageLookupByLibrary.simpleMessage("Amount"),
    "intercityLabelPayment": MessageLookupByLibrary.simpleMessage("Payment"),
    "intercityLabelSeats": MessageLookupByLibrary.simpleMessage("Seats"),
    "intercityLocationsCoords": MessageLookupByLibrary.simpleMessage(
      "Locations & Coords",
    ),
    "intercityMap": MessageLookupByLibrary.simpleMessage("Map"),
    "intercityMapLaunchError": MessageLookupByLibrary.simpleMessage(
      "Could not launch map",
    ),
    "intercityMsgBookingAccepted": MessageLookupByLibrary.simpleMessage(
      "Booking accepted",
    ),
    "intercityMsgBookingRejected": MessageLookupByLibrary.simpleMessage(
      "Booking rejected",
    ),
    "intercityMyTrips": MessageLookupByLibrary.simpleMessage("My Trips"),
    "intercityNightFare": MessageLookupByLibrary.simpleMessage("Night Fare"),
    "intercityNightFareMultiplier": MessageLookupByLibrary.simpleMessage(
      "Night Fare Multiplier",
    ),
    "intercityNoBookings": MessageLookupByLibrary.simpleMessage(
      "No bookings for this trip",
    ),
    "intercityNoPendingBookings": MessageLookupByLibrary.simpleMessage(
      "No pending bookings.",
    ),
    "intercityNoPublishedTrips": MessageLookupByLibrary.simpleMessage(
      "No published trips found.",
    ),
    "intercityOnboarded": MessageLookupByLibrary.simpleMessage("Onboarded"),
    "intercityOnboardedLabel": MessageLookupByLibrary.simpleMessage(
      "Onboarded: ",
    ),
    "intercityOtpHint": MessageLookupByLibrary.simpleMessage("6-Digit OTP"),
    "intercityOtpVerifiedSuccess": MessageLookupByLibrary.simpleMessage(
      "OTP Verified Successfully",
    ),
    "intercityPassengers": MessageLookupByLibrary.simpleMessage("Passengers"),
    "intercityPaymentCash": MessageLookupByLibrary.simpleMessage("CASH"),
    "intercityPickupAddress": MessageLookupByLibrary.simpleMessage(
      "Pickup Address (Edit if needed)",
    ),
    "intercityPickupLat": MessageLookupByLibrary.simpleMessage("Pickup Lat"),
    "intercityPickupLng": MessageLookupByLibrary.simpleMessage("Pickup Lng"),
    "intercityPrivate": MessageLookupByLibrary.simpleMessage("Private"),
    "intercityPublishTrip": MessageLookupByLibrary.simpleMessage(
      "PUBLISH TRIP",
    ),
    "intercityRequiredError": MessageLookupByLibrary.simpleMessage("Required"),
    "intercityReturnDeparture": MessageLookupByLibrary.simpleMessage(
      "Return Departure",
    ),
    "intercityReturnTrip": MessageLookupByLibrary.simpleMessage("Return Trip"),
    "intercityRouteSelection": MessageLookupByLibrary.simpleMessage(
      "Route Selection",
    ),
    "intercityScheduleFare": MessageLookupByLibrary.simpleMessage(
      "Schedule & Fare",
    ),
    "intercitySeats": MessageLookupByLibrary.simpleMessage("Seats"),
    "intercitySelectDateTime": MessageLookupByLibrary.simpleMessage(
      "Select Date & Time",
    ),
    "intercitySelectDepartureTimeError": MessageLookupByLibrary.simpleMessage(
      "Please select departure time",
    ),
    "intercitySharePool": MessageLookupByLibrary.simpleMessage("Share Pool"),
    "intercityStartTrip": MessageLookupByLibrary.simpleMessage("Start Trip"),
    "intercityStatusCancelled": MessageLookupByLibrary.simpleMessage(
      "CANCELLED",
    ),
    "intercityStatusCompleted": MessageLookupByLibrary.simpleMessage(
      "COMPLETED",
    ),
    "intercityStatusDispatched": MessageLookupByLibrary.simpleMessage(
      "DISPATCHED",
    ),
    "intercityStatusFilling": MessageLookupByLibrary.simpleMessage("FILLING"),
    "intercityStatusInProgress": MessageLookupByLibrary.simpleMessage(
      "IN PROGRESS",
    ),
    "intercityStatusMinReached": MessageLookupByLibrary.simpleMessage(
      "MIN REACHED",
    ),
    "intercityStatusPending": MessageLookupByLibrary.simpleMessage("PENDING"),
    "intercityStatusPublished": MessageLookupByLibrary.simpleMessage(
      "PUBLISHED",
    ),
    "intercityStatusUnknown": MessageLookupByLibrary.simpleMessage("UNKNOWN"),
    "intercityToCity": MessageLookupByLibrary.simpleMessage(
      "To City/Area (Search)",
    ),
    "intercityTotalFareInput": MessageLookupByLibrary.simpleMessage(
      "Total Fare (₹)",
    ),
    "intercityTripCompleted": MessageLookupByLibrary.simpleMessage(
      "Trip completed successfully",
    ),
    "intercityTripDetails": MessageLookupByLibrary.simpleMessage(
      "Trip Details",
    ),
    "intercityTripInstruction": MessageLookupByLibrary.simpleMessage(
      "Select trip details. Search locations using Google Maps. Distance is auto-calculated.",
    ),
    "intercityTripPublishedSuccess": MessageLookupByLibrary.simpleMessage(
      "Trip published successfully!",
    ),
    "intercityTripStarted": MessageLookupByLibrary.simpleMessage(
      "Trip started successfully",
    ),
    "intercityUnknownPassenger": MessageLookupByLibrary.simpleMessage(
      "Unknown Passenger",
    ),
    "intercityVehicleAuto": MessageLookupByLibrary.simpleMessage("Auto Normal"),
    "intercityVehicleCarNormal": MessageLookupByLibrary.simpleMessage(
      "Car Normal",
    ),
    "intercityVehicleCarPremium": MessageLookupByLibrary.simpleMessage(
      "Car Premium Express",
    ),
    "intercityVehicleTataMagic": MessageLookupByLibrary.simpleMessage(
      "Tata Magic Lite",
    ),
    "intercityVehicleType": MessageLookupByLibrary.simpleMessage(
      "Vehicle Type",
    ),
    "intercityVerificationFailed": m9,
    "intercityVerified": MessageLookupByLibrary.simpleMessage("Verified"),
    "intercityVerify": MessageLookupByLibrary.simpleMessage("Verify"),
    "intercityVerifyOtp": MessageLookupByLibrary.simpleMessage("Verify OTP"),
    "internal_server_error": MessageLookupByLibrary.simpleMessage(
      "Internal server error",
    ),
    "issueSubmitted": MessageLookupByLibrary.simpleMessage(
      "Your Issue Submitted Successfully",
    ),
    "km": MessageLookupByLibrary.simpleMessage("km"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "lets_ride": MessageLookupByLibrary.simpleMessage("Let’s Ride"),
    "license_back": MessageLookupByLibrary.simpleMessage("License Back"),
    "license_front": MessageLookupByLibrary.simpleMessage("License Front"),
    "license_number": MessageLookupByLibrary.simpleMessage("License Number"),
    "license_number_hint": MessageLookupByLibrary.simpleMessage(
      "Enter driving license number (e.g., DL-0123456789)",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Location"),
    "location_permission_msg": MessageLookupByLibrary.simpleMessage(
      "Please enable location access to use this feature.",
    ),
    "location_permission_needed": MessageLookupByLibrary.simpleMessage(
      "Location Permission Needed",
    ),
    "log_out": MessageLookupByLibrary.simpleMessage("Log Out"),
    "loggingInSomewhereElse": MessageLookupByLibrary.simpleMessage(
      "Logging in Somewhere Else",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginSignup": MessageLookupByLibrary.simpleMessage("Log in / Sign up"),
    "login_subtitle": MessageLookupByLibrary.simpleMessage(
      "Enter your email and password to continue",
    ),
    "login_with_your_password": MessageLookupByLibrary.simpleMessage(
      "Login with your Password",
    ),
    "method": MessageLookupByLibrary.simpleMessage("Method: "),
    "min": MessageLookupByLibrary.simpleMessage("min"),
    "min_length_error": m3,
    "mobile_number": MessageLookupByLibrary.simpleMessage("Mobile Number"),
    "my_profile": MessageLookupByLibrary.simpleMessage("My Profile"),
    "name_label": MessageLookupByLibrary.simpleMessage("Name"),
    "new_password": MessageLookupByLibrary.simpleMessage("New Password"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "nid_image_required": MessageLookupByLibrary.simpleMessage(
      "NID image is required",
    ),
    "nid_photo": MessageLookupByLibrary.simpleMessage("NID Photo"),
    "no_address_found": MessageLookupByLibrary.simpleMessage(
      "No address found",
    ),
    "no_cards_yet": MessageLookupByLibrary.simpleMessage("No Cards yet!"),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "No internet connection.",
    ),
    "no_internet_connection_please_check": MessageLookupByLibrary.simpleMessage(
      "No internet connection. Please check your internet connection.",
    ),
    "no_payment_methods_available": MessageLookupByLibrary.simpleMessage(
      "No Payment methods available",
    ),
    "no_rides_today": MessageLookupByLibrary.simpleMessage("No rides today"),
    "no_rides_yet": MessageLookupByLibrary.simpleMessage("No rides yet."),
    "no_service_available": MessageLookupByLibrary.simpleMessage(
      "No Service Available",
    ),
    "no_transactions_found": MessageLookupByLibrary.simpleMessage(
      "No transactions found",
    ),
    "no_wallet_data_available": MessageLookupByLibrary.simpleMessage(
      "No wallet data available",
    ),
    "offline": MessageLookupByLibrary.simpleMessage("Offline"),
    "or_select_avatar": MessageLookupByLibrary.simpleMessage(
      "Or select an avatar from the list below:",
    ),
    "otp_enter_title": MessageLookupByLibrary.simpleMessage("Enter Your OTP"),
    "otp_input_hint": MessageLookupByLibrary.simpleMessage("Write Your OTP"),
    "otp_resend": MessageLookupByLibrary.simpleMessage("Resend"),
    "otp_resend_timer": m4,
    "otp_save_button": MessageLookupByLibrary.simpleMessage("Save"),
    "otp_sent_message": MessageLookupByLibrary.simpleMessage(
      "We sent OTP code to your phone number",
    ),
    "otp_title_short": MessageLookupByLibrary.simpleMessage("OTP"),
    "password_hint": MessageLookupByLibrary.simpleMessage(
      "Set a Strong Password",
    ),
    "password_hint_min": MessageLookupByLibrary.simpleMessage(
      "Enter password (minimum 6 characters)",
    ),
    "password_label": MessageLookupByLibrary.simpleMessage("Password"),
    "password_length_error": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "password_mismatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match.",
    ),
    "password_requirements": m5,
    "payment_completed": MessageLookupByLibrary.simpleMessage(
      "Thank You! Payment Completed",
    ),
    "payment_confirmation": m6,
    "payment_gateway": MessageLookupByLibrary.simpleMessage("Payment Gateway"),
    "payment_method": MessageLookupByLibrary.simpleMessage("Payment Method"),
    "payment_received": MessageLookupByLibrary.simpleMessage(
      "Payment Received",
    ),
    "payment_withdraw": MessageLookupByLibrary.simpleMessage(
      "Payment Withdraw",
    ),
    "payout_method": MessageLookupByLibrary.simpleMessage("Payout Method"),
    "personal_info": MessageLookupByLibrary.simpleMessage("Personal Info"),
    "phoneMinLengthError": MessageLookupByLibrary.simpleMessage(
      "Phone number must be at least 6 digits",
    ),
    "phoneNo": MessageLookupByLibrary.simpleMessage("Phone No"),
    "phone_numeric_error": MessageLookupByLibrary.simpleMessage(
      "Phone number must contain only numbers",
    ),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage(
      "Pick from Gallery",
    ),
    "pick_a_date": MessageLookupByLibrary.simpleMessage("Pick a date"),
    "pickup": MessageLookupByLibrary.simpleMessage("Pick-up"),
    "pickup_rider": MessageLookupByLibrary.simpleMessage("Pickup Rider"),
    "plate_number": MessageLookupByLibrary.simpleMessage("Plate Number"),
    "please_enter_amount": MessageLookupByLibrary.simpleMessage(
      "Please enter amount",
    ),
    "please_select_payment_type": MessageLookupByLibrary.simpleMessage(
      "Please Select Payment Type",
    ),
    "please_wait": MessageLookupByLibrary.simpleMessage("Please wait..."),
    "privacy_policy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "production_year": MessageLookupByLibrary.simpleMessage("Production Year"),
    "profile_image": MessageLookupByLibrary.simpleMessage("Profile Image"),
    "profile_image_required": MessageLookupByLibrary.simpleMessage(
      "Profile image is required",
    ),
    "profile_submitted_reviewed": MessageLookupByLibrary.simpleMessage(
      "Your profile has been submitted and is being reviewed. You will be notified when it is approved.",
    ),
    "profile_under_review": MessageLookupByLibrary.simpleMessage(
      "Your Profile is Under Review",
    ),
    "rc_back": MessageLookupByLibrary.simpleMessage("RC Back"),
    "rc_front": MessageLookupByLibrary.simpleMessage("RC Front"),
    "rc_number": MessageLookupByLibrary.simpleMessage("RC Number"),
    "rc_number_hint": MessageLookupByLibrary.simpleMessage(
      "Enter vehicle RC number (Registration Certificate)",
    ),
    "reached_destination": MessageLookupByLibrary.simpleMessage(
      "Reached Destination",
    ),
    "reached_passenger_destination": MessageLookupByLibrary.simpleMessage(
      "You’ve Reached the Passenger’s Destination.",
    ),
    "reached_pickup_wait": MessageLookupByLibrary.simpleMessage(
      "You’ve reached the pickup location. Please wait a few minutes for the rider to approach your vehicle.",
    ),
    "receive_timeout_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Receive timeout with API server",
    ),
    "received_invalid_response_from_server":
        MessageLookupByLibrary.simpleMessage(
          "Received an invalid response from the server.",
        ),
    "registration_done": MessageLookupByLibrary.simpleMessage(
      "Registration DONE!",
    ),
    "reportIssue": MessageLookupByLibrary.simpleMessage("Report Issue"),
    "reportIssueSubtitle": MessageLookupByLibrary.simpleMessage(
      "Tell us what went wrong. We’ll look into it immediately.",
    ),
    "reportIssueTitle": MessageLookupByLibrary.simpleMessage(
      "Something Went Wrong? Report an Issue",
    ),
    "reportType": MessageLookupByLibrary.simpleMessage("Report Type"),
    "requestEntityTooLarge": MessageLookupByLibrary.simpleMessage(
      "Request Entity Too Large",
    ),
    "request_timed_out_please_try_again": MessageLookupByLibrary.simpleMessage(
      "Request timed out. Please try again.",
    ),
    "request_to_api_server_was_cancelled": MessageLookupByLibrary.simpleMessage(
      "Request to API server was cancelled",
    ),
    "resource_not_found": MessageLookupByLibrary.simpleMessage(
      "Resource not found.",
    ),
    "rideCharge": MessageLookupByLibrary.simpleMessage("Ride Charge"),
    "rideDetails": MessageLookupByLibrary.simpleMessage("Ride Details"),
    "ride_complete": MessageLookupByLibrary.simpleMessage(
      "Your Ride is Complete",
    ),
    "ride_feedback_prompt": MessageLookupByLibrary.simpleMessage(
      "We hope you had a smooth ride. Please complete your payment and rate your experience.",
    ),
    "ride_history": MessageLookupByLibrary.simpleMessage("Ride History"),
    "ride_preferences": MessageLookupByLibrary.simpleMessage(
      "Ride Preferences",
    ),
    "ride_preferences_description": MessageLookupByLibrary.simpleMessage(
      "Select the type of ride that best suits your needs.",
    ),
    "ride_requested": MessageLookupByLibrary.simpleMessage("Ride requested"),
    "ride_started": MessageLookupByLibrary.simpleMessage(
      "Your Ride Has Started!",
    ),
    "rider_waiting_move_now": MessageLookupByLibrary.simpleMessage(
      "Rider Waiting — Move Now",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "searching_for_driver": MessageLookupByLibrary.simpleMessage(
      "Searching for an online driver..",
    ),
    "see_you_next_ride": MessageLookupByLibrary.simpleMessage(
      "We hope to see you again soon for your next ride!",
    ),
    "selectReportType": MessageLookupByLibrary.simpleMessage(
      "Select Report type",
    ),
    "select_a_country": MessageLookupByLibrary.simpleMessage(
      "Select a country",
    ),
    "select_card_type": MessageLookupByLibrary.simpleMessage(
      "Select Card type",
    ),
    "select_payment_method": MessageLookupByLibrary.simpleMessage(
      "Select payment method",
    ),
    "select_pickup_location": MessageLookupByLibrary.simpleMessage(
      "Select Pickup location",
    ),
    "select_profile_image": MessageLookupByLibrary.simpleMessage(
      "Select Profile Image",
    ),
    "select_service": MessageLookupByLibrary.simpleMessage("Select a Service!"),
    "select_vehicle_color": MessageLookupByLibrary.simpleMessage(
      "Select vehicle color",
    ),
    "select_vehicle_type": MessageLookupByLibrary.simpleMessage(
      "Select vehicle type",
    ),
    "send_timeout_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Send timeout with API server",
    ),
    "service_charge": MessageLookupByLibrary.simpleMessage("Service Charge"),
    "share_experience": MessageLookupByLibrary.simpleMessage(
      "Share Your Experience!",
    ),
    "signup_action": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "skip_for_now": MessageLookupByLibrary.simpleMessage("Skip for Now"),
    "something_went_wrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong",
    ),
    "something_went_wrong_exclamation": MessageLookupByLibrary.simpleMessage(
      "Something went wrong!",
    ),
    "start_journey_navigation": MessageLookupByLibrary.simpleMessage(
      "Start the journey by following the in-app navigation. Make sure both parties are comfortable before beginning.",
    ),
    "start_ride": MessageLookupByLibrary.simpleMessage("Start Ride"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "stayOnThisDevice": MessageLookupByLibrary.simpleMessage(
      "Stay on This Device",
    ),
    "step_bank_details": MessageLookupByLibrary.simpleMessage("Bank Details"),
    "step_create_account": MessageLookupByLibrary.simpleMessage(
      "Create Account",
    ),
    "step_license_docs": MessageLookupByLibrary.simpleMessage(
      "License & Documents",
    ),
    "step_personal_info": MessageLookupByLibrary.simpleMessage(
      "Personal Information",
    ),
    "step_subtitle_bank": MessageLookupByLibrary.simpleMessage(
      "Enter your bank account details",
    ),
    "step_subtitle_default": MessageLookupByLibrary.simpleMessage(
      "Fill in your details to get started",
    ),
    "step_subtitle_docs": MessageLookupByLibrary.simpleMessage(
      "Upload required documents",
    ),
    "step_subtitle_personal": MessageLookupByLibrary.simpleMessage(
      "Enter your basic details",
    ),
    "step_subtitle_vehicle": MessageLookupByLibrary.simpleMessage(
      "Tell us about your vehicle",
    ),
    "step_vehicle_info": MessageLookupByLibrary.simpleMessage(
      "Vehicle Information",
    ),
    "stop_point": MessageLookupByLibrary.simpleMessage("Stop point"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "takeAPhoto": MessageLookupByLibrary.simpleMessage("Take a Photo"),
    "tap_to_confirm_arrival": MessageLookupByLibrary.simpleMessage(
      "Tap to Confirm Your Arrival",
    ),
    "tap_to_start_ride": MessageLookupByLibrary.simpleMessage(
      "Tap to Start Ride",
    ),
    "terms_conditions": MessageLookupByLibrary.simpleMessage(
      "Terms & Conditions",
    ),
    "textCopied": MessageLookupByLibrary.simpleMessage("Text been copied"),
    "thanksForReporting": MessageLookupByLibrary.simpleMessage(
      "Thanks for reporting. Our team will review your issue and get back to you shortly.",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "time_to_pickup": MessageLookupByLibrary.simpleMessage(
      "Time to pick up your rider! Follow the navigation and arrive without delay",
    ),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "todays_activity": MessageLookupByLibrary.simpleMessage(
      "Today\'s Activity",
    ),
    "todays_earning": MessageLookupByLibrary.simpleMessage("Today\'s Earning"),
    "top_up_your_wallet_securely_and_enjoy_seamless_payments":
        MessageLookupByLibrary.simpleMessage(
          "Top up your wallet securely and enjoy seamless payments.",
        ),
    "total_amount": MessageLookupByLibrary.simpleMessage("Total Amount"),
    "total_distance": MessageLookupByLibrary.simpleMessage("Total Distance"),
    "total_rides": MessageLookupByLibrary.simpleMessage("Total Rides"),
    "transactions": MessageLookupByLibrary.simpleMessage("Transactions"),
    "trip_ended_passenger_destination": MessageLookupByLibrary.simpleMessage(
      "The trip has ended as the passenger has reached their destination.",
    ),
    "trip_ended_wait_payment": MessageLookupByLibrary.simpleMessage(
      "The trip has ended. Wait for the passenger to complete their payment before closing the ride.",
    ),
    "trips": MessageLookupByLibrary.simpleMessage("Trips"),
    "type_a_message": MessageLookupByLibrary.simpleMessage("Type a message"),
    "unauthorized_access_please_login_again":
        MessageLookupByLibrary.simpleMessage(
          "Unauthorized access. Please login again.",
        ),
    "unexpected_application_crash": MessageLookupByLibrary.simpleMessage(
      "Unexpected Application Crash",
    ),
    "unexpected_error_occurred": MessageLookupByLibrary.simpleMessage(
      "An unexpected error occurred",
    ),
    "unexpected_response_format": MessageLookupByLibrary.simpleMessage(
      "Unexpected response format",
    ),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "upi_id": MessageLookupByLibrary.simpleMessage("UPI ID"),
    "upi_id_hint": MessageLookupByLibrary.simpleMessage(
      "Enter UPI ID (e.g., name@paytm, name@phonepe)",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "upload_aadhaar_back_error": MessageLookupByLibrary.simpleMessage(
      "Please upload Aadhaar back photo",
    ),
    "upload_aadhaar_front_error": MessageLookupByLibrary.simpleMessage(
      "Please upload Aadhaar front photo",
    ),
    "upload_driver_documents": MessageLookupByLibrary.simpleMessage(
      "Upload your driver documents to complete verification and start driving. Quick, easy, and secure!",
    ),
    "upload_image": MessageLookupByLibrary.simpleMessage("Upload image"),
    "upload_license_back_error": MessageLookupByLibrary.simpleMessage(
      "Please upload license back photo",
    ),
    "upload_license_front_error": MessageLookupByLibrary.simpleMessage(
      "Please upload license front photo",
    ),
    "upload_profile_photo_error": MessageLookupByLibrary.simpleMessage(
      "Please upload profile photo",
    ),
    "upload_rc_back_error": MessageLookupByLibrary.simpleMessage(
      "Please upload RC back photo",
    ),
    "upload_rc_front_error": MessageLookupByLibrary.simpleMessage(
      "Please upload RC front photo",
    ),
    "use_otp_instead": MessageLookupByLibrary.simpleMessage("Use OTP Instead"),
    "use_your_password_here": MessageLookupByLibrary.simpleMessage(
      "Use your password here",
    ),
    "validation_error": MessageLookupByLibrary.simpleMessage(
      "Validation error",
    ),
    "vehicle_color": MessageLookupByLibrary.simpleMessage("Vehicle Color"),
    "vehicle_color_hint": MessageLookupByLibrary.simpleMessage(
      "Enter vehicle color (e.g., Red, Blue, White)",
    ),
    "vehicle_model": MessageLookupByLibrary.simpleMessage("Vehicle Model"),
    "vehicle_model_hint": MessageLookupByLibrary.simpleMessage(
      "Enter vehicle model (e.g., Swift, Activa, City)",
    ),
    "vehicle_name": MessageLookupByLibrary.simpleMessage("Vehicle Name"),
    "vehicle_number_hint": MessageLookupByLibrary.simpleMessage(
      "Enter vehicle registration number (e.g., MH12AB1234)",
    ),
    "vehicle_papers": MessageLookupByLibrary.simpleMessage("Vehicle Papers"),
    "vehicle_papers_required": MessageLookupByLibrary.simpleMessage(
      "Vehicle Papers required",
    ),
    "vehicle_plate_number": MessageLookupByLibrary.simpleMessage(
      "Vehicle Plate Number",
    ),
    "vehicle_production_year": MessageLookupByLibrary.simpleMessage(
      "Vehicle Production Year",
    ),
    "vehicle_type": MessageLookupByLibrary.simpleMessage("Vehicle Type"),
    "vehicle_type_hint": MessageLookupByLibrary.simpleMessage(
      "Select vehicle type (e.g., CAR, BIKE, SUV)",
    ),
    "verify_otp_action": MessageLookupByLibrary.simpleMessage("Confirm OTP"),
    "view_all": MessageLookupByLibrary.simpleMessage("View All"),
    "wallet": MessageLookupByLibrary.simpleMessage("Wallet"),
    "wallet_balance": MessageLookupByLibrary.simpleMessage("Wallet Balance"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back!"),
    "withdraw": MessageLookupByLibrary.simpleMessage("Withdraw"),
    "withdraw_history": MessageLookupByLibrary.simpleMessage(
      "Withdraw History",
    ),
    "withdraw_instruction": MessageLookupByLibrary.simpleMessage(
      "You\'ve earned it! Choose where you want to send your money and hit withdraw.",
    ),
    "withdraw_your_earnings": MessageLookupByLibrary.simpleMessage(
      "Withdraw Your Earnings",
    ),
    "withdrawal_request_success": m7,
    "withdrawal_success": MessageLookupByLibrary.simpleMessage(
      "Withdrawal Request Submitted Successfully!",
    ),
    "write": m10,
    "writeIssueDetails": MessageLookupByLibrary.simpleMessage(
      "Write Issue Details",
    ),
    "you_can_cancel_ride_in": MessageLookupByLibrary.simpleMessage(
      "You can cancel ride in",
    ),
    "yourAccountAlreadyActive": MessageLookupByLibrary.simpleMessage(
      "Your account is already active on another device. To use it here, the other device will be logged out.",
    ),
    "your_balance": MessageLookupByLibrary.simpleMessage("Your Balance"),
    "your_best_photo_here": MessageLookupByLibrary.simpleMessage(
      "Your Best Photo Here",
    ),
    "your_ride_complete": MessageLookupByLibrary.simpleMessage("Ride complete"),
  };
}
