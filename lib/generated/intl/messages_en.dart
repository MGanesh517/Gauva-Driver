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

  static String m3(length) => "Must be at least ${length} characters";

  static String m4(secondsRemaining) => "Resend code in 00:${secondsRemaining}";

  static String m5(length) => "Use at least ${length} characters";

  static String m6(method) =>
      "paid via ${method}. We hope you had a great ride! Don\'t forget to leave a rating.";

  static String m7(amount) =>
      "Success! You\'ve requested ${amount} withdrawal. Funds will be transferred to your selected account shortly.";

  static String m8(msg) => "Write ${msg}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accept_ride": MessageLookupByLibrary.simpleMessage("Accept Ride"),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
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
    "bad_certificate_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Bad certificate with API server",
    ),
    "bad_request": MessageLookupByLibrary.simpleMessage("Bad request"),
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
    "enter_amount": MessageLookupByLibrary.simpleMessage("Enter Amount"),
    "enter_cardholder_name": MessageLookupByLibrary.simpleMessage(
      "Enter cardholder name",
    ),
    "enter_details_complete_profile": MessageLookupByLibrary.simpleMessage(
      "Enter your details to complete your profile and enhance your experience.",
    ),
    "enter_experience": MessageLookupByLibrary.simpleMessage(
      "Enter your Experience!",
    ),
    "enter_password": MessageLookupByLibrary.simpleMessage(
      "Enter your Password",
    ),
    "enter_password_description": MessageLookupByLibrary.simpleMessage(
      "Please enter your account password to continue.",
    ),
    "enter_plate_number": MessageLookupByLibrary.simpleMessage(
      "Enter plate no",
    ),
    "enter_valid_card_number": MessageLookupByLibrary.simpleMessage(
      "Enter valid card number",
    ),
    "enter_vehicle_name": MessageLookupByLibrary.simpleMessage(
      "Enter vehicle name",
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
    "initializing": MessageLookupByLibrary.simpleMessage("Initializing..."),
    "insertAllData": MessageLookupByLibrary.simpleMessage(
      "Please insert all Data",
    ),
    "internal_server_error": MessageLookupByLibrary.simpleMessage(
      "Internal server error",
    ),
    "issueSubmitted": MessageLookupByLibrary.simpleMessage(
      "Your Issue Submitted Successfully",
    ),
    "km": MessageLookupByLibrary.simpleMessage("km"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "lets_ride": MessageLookupByLibrary.simpleMessage("Let’s Ride"),
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
    "password_label": MessageLookupByLibrary.simpleMessage("Password"),
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
    "upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "upload_driver_documents": MessageLookupByLibrary.simpleMessage(
      "Upload your driver documents to complete verification and start driving. Quick, easy, and secure!",
    ),
    "upload_image": MessageLookupByLibrary.simpleMessage("Upload image"),
    "use_otp_instead": MessageLookupByLibrary.simpleMessage("Use OTP Instead"),
    "use_your_password_here": MessageLookupByLibrary.simpleMessage(
      "Use your password here",
    ),
    "validation_error": MessageLookupByLibrary.simpleMessage(
      "Validation error",
    ),
    "vehicle_color": MessageLookupByLibrary.simpleMessage("Vehicle Color"),
    "vehicle_name": MessageLookupByLibrary.simpleMessage("Vehicle Name"),
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
    "write": m8,
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
