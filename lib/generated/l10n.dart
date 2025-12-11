// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Hello...`
  String get helloText {
    return Intl.message('Hello...', name: 'helloText', desc: '', args: []);
  }

  /// `Welcome Back!`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number to continue your ride and stay updated.`
  String get enterPhoneDes {
    return Intl.message(
      'Enter your phone number to continue your ride and stay updated.',
      name: 'enterPhoneDes',
      desc: '',
      args: [],
    );
  }

  /// `Phone No`
  String get phoneNo {
    return Intl.message('Phone No', name: 'phoneNo', desc: '', args: []);
  }

  /// `Go to Login`
  String get go_to_login {
    return Intl.message('Go to Login', name: 'go_to_login', desc: '', args: []);
  }

  /// `Log in / Sign up`
  String get loginSignup {
    return Intl.message(
      'Log in / Sign up',
      name: 'loginSignup',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Phone number must be at least 6 digits`
  String get phoneMinLengthError {
    return Intl.message(
      'Phone number must be at least 6 digits',
      name: 'phoneMinLengthError',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your OTP`
  String get otp_enter_title {
    return Intl.message(
      'Enter Your OTP',
      name: 'otp_enter_title',
      desc: '',
      args: [],
    );
  }

  /// `We sent OTP code to your phone number`
  String get otp_sent_message {
    return Intl.message(
      'We sent OTP code to your phone number',
      name: 'otp_sent_message',
      desc: '',
      args: [],
    );
  }

  /// `Write Your OTP`
  String get otp_input_hint {
    return Intl.message(
      'Write Your OTP',
      name: 'otp_input_hint',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get otp_resend {
    return Intl.message('Resend', name: 'otp_resend', desc: '', args: []);
  }

  /// `Resend code in 00:{secondsRemaining}`
  String otp_resend_timer(Object secondsRemaining) {
    return Intl.message(
      'Resend code in 00:$secondsRemaining',
      name: 'otp_resend_timer',
      desc: '',
      args: [secondsRemaining],
    );
  }

  /// `Save`
  String get otp_save_button {
    return Intl.message('Save', name: 'otp_save_button', desc: '', args: []);
  }

  /// `OTP`
  String get otp_title_short {
    return Intl.message('OTP', name: 'otp_title_short', desc: '', args: []);
  }

  /// `Password`
  String get password_label {
    return Intl.message('Password', name: 'password_label', desc: '', args: []);
  }

  /// `Set a Strong Password`
  String get password_hint {
    return Intl.message(
      'Set a Strong Password',
      name: 'password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Use at least {length} characters`
  String password_requirements(Object length) {
    return Intl.message(
      'Use at least $length characters',
      name: 'password_requirements',
      desc: '',
      args: [length],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get password_mismatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'password_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get field_required {
    return Intl.message(
      'This field is required',
      name: 'field_required',
      desc: '',
      args: [],
    );
  }

  /// `Must be at least {length} characters`
  String min_length_error(Object length) {
    return Intl.message(
      'Must be at least $length characters',
      name: 'min_length_error',
      desc: '',
      args: [length],
    );
  }

  /// `Name`
  String get name_label {
    return Intl.message('Name', name: 'name_label', desc: '', args: []);
  }

  /// `Email`
  String get email_label {
    return Intl.message('Email', name: 'email_label', desc: '', args: []);
  }

  /// `Gender`
  String get gender_label {
    return Intl.message('Gender', name: 'gender_label', desc: '', args: []);
  }

  /// `Male`
  String get gender_male {
    return Intl.message('Male', name: 'gender_male', desc: '', args: []);
  }

  /// `Female`
  String get gender_female {
    return Intl.message('Female', name: 'gender_female', desc: '', args: []);
  }

  /// `Other`
  String get gender_other {
    return Intl.message('Other', name: 'gender_other', desc: '', args: []);
  }

  /// `Select Gender`
  String get gender_select {
    return Intl.message(
      'Select Gender',
      name: 'gender_select',
      desc: '',
      args: [],
    );
  }

  /// `Personal Info`
  String get personal_info {
    return Intl.message(
      'Personal Info',
      name: 'personal_info',
      desc: '',
      args: [],
    );
  }

  /// `Add Driver Personal Info`
  String get add_driver_personal_info {
    return Intl.message(
      'Add Driver Personal Info',
      name: 'add_driver_personal_info',
      desc: '',
      args: [],
    );
  }

  /// `Enter your details to complete your profile and enhance your experience.`
  String get enter_details_complete_profile {
    return Intl.message(
      'Enter your details to complete your profile and enhance your experience.',
      name: 'enter_details_complete_profile',
      desc: '',
      args: [],
    );
  }

  /// `Profile Image`
  String get profile_image {
    return Intl.message(
      'Profile Image',
      name: 'profile_image',
      desc: '',
      args: [],
    );
  }

  /// `Profile image is required`
  String get profile_image_required {
    return Intl.message(
      'Profile image is required',
      name: 'profile_image_required',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `All field required`
  String get all_field_required {
    return Intl.message(
      'All field required',
      name: 'all_field_required',
      desc: '',
      args: [],
    );
  }

  /// `Emergency Phone`
  String get emergency_phone {
    return Intl.message(
      'Emergency Phone',
      name: 'emergency_phone',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Driver Documents`
  String get driver_documents {
    return Intl.message(
      'Driver Documents',
      name: 'driver_documents',
      desc: '',
      args: [],
    );
  }

  /// `Add Driver Documents`
  String get add_driver_documents {
    return Intl.message(
      'Add Driver Documents',
      name: 'add_driver_documents',
      desc: '',
      args: [],
    );
  }

  /// `Upload your driver documents to complete verification and start driving. Quick, easy, and secure!`
  String get upload_driver_documents {
    return Intl.message(
      'Upload your driver documents to complete verification and start driving. Quick, easy, and secure!',
      name: 'upload_driver_documents',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Name`
  String get vehicle_name {
    return Intl.message(
      'Vehicle Name',
      name: 'vehicle_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter vehicle name`
  String get enter_vehicle_name {
    return Intl.message(
      'Enter vehicle name',
      name: 'enter_vehicle_name',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Type`
  String get vehicle_type {
    return Intl.message(
      'Vehicle Type',
      name: 'vehicle_type',
      desc: '',
      args: [],
    );
  }

  /// `Select vehicle type`
  String get select_vehicle_type {
    return Intl.message(
      'Select vehicle type',
      name: 'select_vehicle_type',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Color`
  String get vehicle_color {
    return Intl.message(
      'Vehicle Color',
      name: 'vehicle_color',
      desc: '',
      args: [],
    );
  }

  /// `Select vehicle color`
  String get select_vehicle_color {
    return Intl.message(
      'Select vehicle color',
      name: 'select_vehicle_color',
      desc: '',
      args: [],
    );
  }

  /// `Plate Number`
  String get plate_number {
    return Intl.message(
      'Plate Number',
      name: 'plate_number',
      desc: '',
      args: [],
    );
  }

  /// `Enter plate no`
  String get enter_plate_number {
    return Intl.message(
      'Enter plate no',
      name: 'enter_plate_number',
      desc: '',
      args: [],
    );
  }

  /// `NID Photo`
  String get nid_photo {
    return Intl.message('NID Photo', name: 'nid_photo', desc: '', args: []);
  }

  /// `Driving License`
  String get driving_license {
    return Intl.message(
      'Driving License',
      name: 'driving_license',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Papers`
  String get vehicle_papers {
    return Intl.message(
      'Vehicle Papers',
      name: 'vehicle_papers',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message('Upload', name: 'upload', desc: '', args: []);
  }

  /// `Driving License is required`
  String get driving_license_required {
    return Intl.message(
      'Driving License is required',
      name: 'driving_license_required',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Papers required`
  String get vehicle_papers_required {
    return Intl.message(
      'Vehicle Papers required',
      name: 'vehicle_papers_required',
      desc: '',
      args: [],
    );
  }

  /// `NID image is required`
  String get nid_image_required {
    return Intl.message(
      'NID image is required',
      name: 'nid_image_required',
      desc: '',
      args: [],
    );
  }

  /// `Production Year`
  String get production_year {
    return Intl.message(
      'Production Year',
      name: 'production_year',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Production Year`
  String get vehicle_production_year {
    return Intl.message(
      'Vehicle Production Year',
      name: 'vehicle_production_year',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Plate Number`
  String get vehicle_plate_number {
    return Intl.message(
      'Vehicle Plate Number',
      name: 'vehicle_plate_number',
      desc: '',
      args: [],
    );
  }

  /// `Your Best Photo Here`
  String get your_best_photo_here {
    return Intl.message(
      'Your Best Photo Here',
      name: 'your_best_photo_here',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Please wait...`
  String get please_wait {
    return Intl.message(
      'Please wait...',
      name: 'please_wait',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Wallet`
  String get wallet {
    return Intl.message('Wallet', name: 'wallet', desc: '', args: []);
  }

  /// `Activity`
  String get activity {
    return Intl.message('Activity', name: 'activity', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `No wallet data available`
  String get no_wallet_data_available {
    return Intl.message(
      'No wallet data available',
      name: 'no_wallet_data_available',
      desc: '',
      args: [],
    );
  }

  /// `Wallet Balance`
  String get wallet_balance {
    return Intl.message(
      'Wallet Balance',
      name: 'wallet_balance',
      desc: '',
      args: [],
    );
  }

  /// `Payment Gateway`
  String get payment_gateway {
    return Intl.message(
      'Payment Gateway',
      name: 'payment_gateway',
      desc: '',
      args: [],
    );
  }

  /// `Add New`
  String get add_new {
    return Intl.message('Add New', name: 'add_new', desc: '', args: []);
  }

  /// `No Cards yet!`
  String get no_cards_yet {
    return Intl.message(
      'No Cards yet!',
      name: 'no_cards_yet',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Complete Ride`
  String get complete_ride {
    return Intl.message(
      'Complete Ride',
      name: 'complete_ride',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Ride`
  String get cancel_ride {
    return Intl.message('Cancel Ride', name: 'cancel_ride', desc: '', args: []);
  }

  /// `No rides yet.`
  String get no_rides_yet {
    return Intl.message(
      'No rides yet.',
      name: 'no_rides_yet',
      desc: '',
      args: [],
    );
  }

  /// `Error: {msg}`
  String error_with_msg(Object msg) {
    return Intl.message(
      'Error: $msg',
      name: 'error_with_msg',
      desc: '',
      args: [msg],
    );
  }

  /// `My Profile`
  String get my_profile {
    return Intl.message('My Profile', name: 'my_profile', desc: '', args: []);
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get terms_conditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'terms_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get log_out {
    return Intl.message('Log Out', name: 'log_out', desc: '', args: []);
  }

  /// `Delete Account`
  String get delete_account {
    return Intl.message(
      'Delete Account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Are You Sure You Want to {msg} from App`
  String are_you_sure_msg(Object msg) {
    return Intl.message(
      'Are You Sure You Want to $msg from App',
      name: 'are_you_sure_msg',
      desc: '',
      args: [msg],
    );
  }

  /// `We hope to see you again soon for your next ride!`
  String get see_you_next_ride {
    return Intl.message(
      'We hope to see you again soon for your next ride!',
      name: 'see_you_next_ride',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message('Exit', name: 'exit', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Location Permission Needed`
  String get location_permission_needed {
    return Intl.message(
      'Location Permission Needed',
      name: 'location_permission_needed',
      desc: '',
      args: [],
    );
  }

  /// `Please enable location access to use this feature.`
  String get location_permission_msg {
    return Intl.message(
      'Please enable location access to use this feature.',
      name: 'location_permission_msg',
      desc: '',
      args: [],
    );
  }

  /// `Grant Permission`
  String get grant_permission {
    return Intl.message(
      'Grant Permission',
      name: 'grant_permission',
      desc: '',
      args: [],
    );
  }

  /// `Let’s Find You Faster!`
  String get find_you_faster {
    return Intl.message(
      'Let’s Find You Faster!',
      name: 'find_you_faster',
      desc: '',
      args: [],
    );
  }

  /// `Enable location access to get matched with nearby drivers quickly and easily.`
  String get find_you_faster_msg {
    return Intl.message(
      'Enable location access to get matched with nearby drivers quickly and easily.',
      name: 'find_you_faster_msg',
      desc: '',
      args: [],
    );
  }

  /// `Skip for Now`
  String get skip_for_now {
    return Intl.message(
      'Skip for Now',
      name: 'skip_for_now',
      desc: '',
      args: [],
    );
  }

  /// `Allow`
  String get allow {
    return Intl.message('Allow', name: 'allow', desc: '', args: []);
  }

  /// `Select Pickup location`
  String get select_pickup_location {
    return Intl.message(
      'Select Pickup location',
      name: 'select_pickup_location',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Pick-up`
  String get pickup {
    return Intl.message('Pick-up', name: 'pickup', desc: '', args: []);
  }

  /// `Stop point`
  String get stop_point {
    return Intl.message('Stop point', name: 'stop_point', desc: '', args: []);
  }

  /// `Destination`
  String get destination {
    return Intl.message('Destination', name: 'destination', desc: '', args: []);
  }

  /// `Ride Preferences`
  String get ride_preferences {
    return Intl.message(
      'Ride Preferences',
      name: 'ride_preferences',
      desc: '',
      args: [],
    );
  }

  /// `No Service Available`
  String get no_service_available {
    return Intl.message(
      'No Service Available',
      name: 'no_service_available',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Select the type of ride that best suits your needs.`
  String get ride_preferences_description {
    return Intl.message(
      'Select the type of ride that best suits your needs.',
      name: 'ride_preferences_description',
      desc: '',
      args: [],
    );
  }

  /// `Initializing...`
  String get initializing {
    return Intl.message(
      'Initializing...',
      name: 'initializing',
      desc: '',
      args: [],
    );
  }

  /// `Select a Service!`
  String get select_service {
    return Intl.message(
      'Select a Service!',
      name: 'select_service',
      desc: '',
      args: [],
    );
  }

  /// `Start Ride`
  String get start_ride {
    return Intl.message('Start Ride', name: 'start_ride', desc: '', args: []);
  }

  /// `Ride requested`
  String get ride_requested {
    return Intl.message(
      'Ride requested',
      name: 'ride_requested',
      desc: '',
      args: [],
    );
  }

  /// `Searching for an online driver..`
  String get searching_for_driver {
    return Intl.message(
      'Searching for an online driver..',
      name: 'searching_for_driver',
      desc: '',
      args: [],
    );
  }

  /// `Type a message`
  String get type_a_message {
    return Intl.message(
      'Type a message',
      name: 'type_a_message',
      desc: '',
      args: [],
    );
  }

  /// `Tell Us Why You're Cancelling The Ride`
  String get cancel_title {
    return Intl.message(
      'Tell Us Why You\'re Cancelling The Ride',
      name: 'cancel_title',
      desc: '',
      args: [],
    );
  }

  /// `Let us know the reason for canceling your ride.`
  String get cancel_subtitle {
    return Intl.message(
      'Let us know the reason for canceling your ride.',
      name: 'cancel_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Go back to ride`
  String get go_back_to_ride {
    return Intl.message(
      'Go back to ride',
      name: 'go_back_to_ride',
      desc: '',
      args: [],
    );
  }

  /// `Cancel the ride`
  String get cancel_the_ride {
    return Intl.message(
      'Cancel the ride',
      name: 'cancel_the_ride',
      desc: '',
      args: [],
    );
  }

  /// `Trips`
  String get trips {
    return Intl.message('Trips', name: 'trips', desc: '', args: []);
  }

  /// `Estimated Time`
  String get estimated_time {
    return Intl.message(
      'Estimated Time',
      name: 'estimated_time',
      desc: '',
      args: [],
    );
  }

  /// `Your Ride is Complete`
  String get ride_complete {
    return Intl.message(
      'Your Ride is Complete',
      name: 'ride_complete',
      desc: '',
      args: [],
    );
  }

  /// `We hope you had a smooth ride. Please complete your payment and rate your experience.`
  String get ride_feedback_prompt {
    return Intl.message(
      'We hope you had a smooth ride. Please complete your payment and rate your experience.',
      name: 'ride_feedback_prompt',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Pay`
  String get confirm_pay {
    return Intl.message('Confirm Pay', name: 'confirm_pay', desc: '', args: []);
  }

  /// `Select payment method`
  String get select_payment_method {
    return Intl.message(
      'Select payment method',
      name: 'select_payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Thank You! Payment Completed`
  String get payment_completed {
    return Intl.message(
      'Thank You! Payment Completed',
      name: 'payment_completed',
      desc: '',
      args: [],
    );
  }

  /// `paid via {method}. We hope you had a great ride! Don't forget to leave a rating.`
  String payment_confirmation(String method) {
    return Intl.message(
      'paid via $method. We hope you had a great ride! Don\'t forget to leave a rating.',
      name: 'payment_confirmation',
      desc: '',
      args: [method],
    );
  }

  /// `Share Your Experience!`
  String get share_experience {
    return Intl.message(
      'Share Your Experience!',
      name: 'share_experience',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Experience!`
  String get enter_experience {
    return Intl.message(
      'Enter your Experience!',
      name: 'enter_experience',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Service Charge`
  String get service_charge {
    return Intl.message(
      'Service Charge',
      name: 'service_charge',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message('Discount', name: 'discount', desc: '', args: []);
  }

  /// `Total Amount`
  String get total_amount {
    return Intl.message(
      'Total Amount',
      name: 'total_amount',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Payment Type`
  String get please_select_payment_type {
    return Intl.message(
      'Please Select Payment Type',
      name: 'please_select_payment_type',
      desc: '',
      args: [],
    );
  }

  /// `No address found`
  String get no_address_found {
    return Intl.message(
      'No address found',
      name: 'no_address_found',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get full_name {
    return Intl.message('Full Name', name: 'full_name', desc: '', args: []);
  }

  /// `Mobile Number`
  String get mobile_number {
    return Intl.message(
      'Mobile Number',
      name: 'mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Gender is required`
  String get gender_required {
    return Intl.message(
      'Gender is required',
      name: 'gender_required',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Current Password`
  String get current_password {
    return Intl.message(
      'Current Password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirm_new_password {
    return Intl.message(
      'Confirm New Password',
      name: 'confirm_new_password',
      desc: '',
      args: [],
    );
  }

  /// `{msg} All rights reserved.`
  String all_rights_reserved(Object msg) {
    return Intl.message(
      '$msg All rights reserved.',
      name: 'all_rights_reserved',
      desc: '',
      args: [msg],
    );
  }

  /// `Registration DONE!`
  String get registration_done {
    return Intl.message(
      'Registration DONE!',
      name: 'registration_done',
      desc: '',
      args: [],
    );
  }

  /// `Your Profile is Under Review`
  String get profile_under_review {
    return Intl.message(
      'Your Profile is Under Review',
      name: 'profile_under_review',
      desc: '',
      args: [],
    );
  }

  /// `Your profile has been submitted and is being reviewed. You will be notified when it is approved.`
  String get profile_submitted_reviewed {
    return Intl.message(
      'Your profile has been submitted and is being reviewed. You will be notified when it is approved.',
      name: 'profile_submitted_reviewed',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Password`
  String get enter_password {
    return Intl.message(
      'Enter your Password',
      name: 'enter_password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your account password to continue.`
  String get enter_password_description {
    return Intl.message(
      'Please enter your account password to continue.',
      name: 'enter_password_description',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `CLOSE`
  String get close {
    return Intl.message('CLOSE', name: 'close', desc: '', args: []);
  }

  /// `Are you sure you want to delete your account?`
  String get delete_account_confirmation {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'delete_account_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `This action is permanent and cannot be undone.`
  String get delete_account_warning {
    return Intl.message(
      'This action is permanent and cannot be undone.',
      name: 'delete_account_warning',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Login with your Password`
  String get login_with_your_password {
    return Intl.message(
      'Login with your Password',
      name: 'login_with_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Use your password here`
  String get use_your_password_here {
    return Intl.message(
      'Use your password here',
      name: 'use_your_password_here',
      desc: '',
      args: [],
    );
  }

  /// `Use OTP Instead`
  String get use_otp_instead {
    return Intl.message(
      'Use OTP Instead',
      name: 'use_otp_instead',
      desc: '',
      args: [],
    );
  }

  /// `Either phone number is null or password is empty`
  String get either_phone_number_is_null_or_password_is_empty {
    return Intl.message(
      'Either phone number is null or password is empty',
      name: 'either_phone_number_is_null_or_password_is_empty',
      desc: '',
      args: [],
    );
  }

  /// `Add Balance to Your Wallet`
  String get add_balance_to_your_wallet {
    return Intl.message(
      'Add Balance to Your Wallet',
      name: 'add_balance_to_your_wallet',
      desc: '',
      args: [],
    );
  }

  /// `Top up your wallet securely and enjoy seamless payments.`
  String get top_up_your_wallet_securely_and_enjoy_seamless_payments {
    return Intl.message(
      'Top up your wallet securely and enjoy seamless payments.',
      name: 'top_up_your_wallet_securely_and_enjoy_seamless_payments',
      desc: '',
      args: [],
    );
  }

  /// `No Payment methods available`
  String get no_payment_methods_available {
    return Intl.message(
      'No Payment methods available',
      name: 'no_payment_methods_available',
      desc: '',
      args: [],
    );
  }

  /// `Select Card type`
  String get select_card_type {
    return Intl.message(
      'Select Card type',
      name: 'select_card_type',
      desc: '',
      args: [],
    );
  }

  /// `Enter Amount`
  String get enter_amount {
    return Intl.message(
      'Enter Amount',
      name: 'enter_amount',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid amount`
  String get enter_a_valid_amount {
    return Intl.message(
      'Enter a valid amount',
      name: 'enter_a_valid_amount',
      desc: '',
      args: [],
    );
  }

  /// `Add Wallet`
  String get add_wallet {
    return Intl.message('Add Wallet', name: 'add_wallet', desc: '', args: []);
  }

  /// `Form is not valid`
  String get form_is_not_valid {
    return Intl.message(
      'Form is not valid',
      name: 'form_is_not_valid',
      desc: '',
      args: [],
    );
  }

  /// `Add Payment Gateway`
  String get add_payment_gateway {
    return Intl.message(
      'Add Payment Gateway',
      name: 'add_payment_gateway',
      desc: '',
      args: [],
    );
  }

  /// `Cardholder Name`
  String get cardholder_name {
    return Intl.message(
      'Cardholder Name',
      name: 'cardholder_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter cardholder name`
  String get enter_cardholder_name {
    return Intl.message(
      'Enter cardholder name',
      name: 'enter_cardholder_name',
      desc: '',
      args: [],
    );
  }

  /// `Card no`
  String get card_number {
    return Intl.message('Card no', name: 'card_number', desc: '', args: []);
  }

  /// `Write {msg}`
  String write(Object msg) {
    return Intl.message('Write $msg', name: 'write', desc: '', args: [msg]);
  }

  /// `Enter valid card number`
  String get enter_valid_card_number {
    return Intl.message(
      'Enter valid card number',
      name: 'enter_valid_card_number',
      desc: '',
      args: [],
    );
  }

  /// `Exp. Date`
  String get exp_date {
    return Intl.message('Exp. Date', name: 'exp_date', desc: '', args: []);
  }

  /// `Pick a date`
  String get pick_a_date {
    return Intl.message('Pick a date', name: 'pick_a_date', desc: '', args: []);
  }

  /// `CVV`
  String get cvv {
    return Intl.message('CVV', name: 'cvv', desc: '', args: []);
  }

  /// `Enter 3-digit CVV`
  String get enter_3_digit_cvv {
    return Intl.message(
      'Enter 3-digit CVV',
      name: 'enter_3_digit_cvv',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Select a country`
  String get select_a_country {
    return Intl.message(
      'Select a country',
      name: 'select_a_country',
      desc: '',
      args: [],
    );
  }

  /// `Connection timeout with API server`
  String get connection_timeout_with_api_server {
    return Intl.message(
      'Connection timeout with API server',
      name: 'connection_timeout_with_api_server',
      desc: '',
      args: [],
    );
  }

  /// `Receive timeout with API server`
  String get receive_timeout_with_api_server {
    return Intl.message(
      'Receive timeout with API server',
      name: 'receive_timeout_with_api_server',
      desc: '',
      args: [],
    );
  }

  /// `Send timeout with API server`
  String get send_timeout_with_api_server {
    return Intl.message(
      'Send timeout with API server',
      name: 'send_timeout_with_api_server',
      desc: '',
      args: [],
    );
  }

  /// `Bad certificate with API server`
  String get bad_certificate_with_api_server {
    return Intl.message(
      'Bad certificate with API server',
      name: 'bad_certificate_with_api_server',
      desc: '',
      args: [],
    );
  }

  /// `Received an invalid response from the server.`
  String get received_invalid_response_from_server {
    return Intl.message(
      'Received an invalid response from the server.',
      name: 'received_invalid_response_from_server',
      desc: '',
      args: [],
    );
  }

  /// `Request to API server was cancelled`
  String get request_to_api_server_was_cancelled {
    return Intl.message(
      'Request to API server was cancelled',
      name: 'request_to_api_server_was_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Connection error with API server`
  String get connection_error_with_api_server {
    return Intl.message(
      'Connection error with API server',
      name: 'connection_error_with_api_server',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection. Please check your internet connection.`
  String get no_internet_connection_please_check {
    return Intl.message(
      'No internet connection. Please check your internet connection.',
      name: 'no_internet_connection_please_check',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred`
  String get unexpected_error_occurred {
    return Intl.message(
      'An unexpected error occurred',
      name: 'unexpected_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected response format`
  String get unexpected_response_format {
    return Intl.message(
      'Unexpected response format',
      name: 'unexpected_response_format',
      desc: '',
      args: [],
    );
  }

  /// `Bad request`
  String get bad_request {
    return Intl.message('Bad request', name: 'bad_request', desc: '', args: []);
  }

  /// `Unauthorized access. Please login again.`
  String get unauthorized_access_please_login_again {
    return Intl.message(
      'Unauthorized access. Please login again.',
      name: 'unauthorized_access_please_login_again',
      desc: '',
      args: [],
    );
  }

  /// `Forbidden access. Please login again.`
  String get forbidden_access_please_login_again {
    return Intl.message(
      'Forbidden access. Please login again.',
      name: 'forbidden_access_please_login_again',
      desc: '',
      args: [],
    );
  }

  /// `Validation error`
  String get validation_error {
    return Intl.message(
      'Validation error',
      name: 'validation_error',
      desc: '',
      args: [],
    );
  }

  /// `Internal server error`
  String get internal_server_error {
    return Intl.message(
      'Internal server error',
      name: 'internal_server_error',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get something_went_wrong {
    return Intl.message(
      'Something went wrong',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection.`
  String get no_internet_connection {
    return Intl.message(
      'No internet connection.',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Request timed out. Please try again.`
  String get request_timed_out_please_try_again {
    return Intl.message(
      'Request timed out. Please try again.',
      name: 'request_timed_out_please_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong!`
  String get something_went_wrong_exclamation {
    return Intl.message(
      'Something went wrong!',
      name: 'something_went_wrong_exclamation',
      desc: '',
      args: [],
    );
  }

  /// `Resource not found.`
  String get resource_not_found {
    return Intl.message(
      'Resource not found.',
      name: 'resource_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected Application Crash`
  String get unexpected_application_crash {
    return Intl.message(
      'Unexpected Application Crash',
      name: 'unexpected_application_crash',
      desc: '',
      args: [],
    );
  }

  /// `The app encountered an unexpected error and had to close. This could be caused by insufficient device memory, a bug in the app, or a corrupted file. Please restart the app or reinstall it if the issue continues.`
  String get app_encountered_unexpected_error {
    return Intl.message(
      'The app encountered an unexpected error and had to close. This could be caused by insufficient device memory, a bug in the app, or a corrupted file. Please restart the app or reinstall it if the issue continues.',
      name: 'app_encountered_unexpected_error',
      desc: '',
      args: [],
    );
  }

  /// `Contact Support`
  String get contact_support {
    return Intl.message(
      'Contact Support',
      name: 'contact_support',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offline {
    return Intl.message('Offline', name: 'offline', desc: '', args: []);
  }

  /// `Let’s Ride`
  String get lets_ride {
    return Intl.message('Let’s Ride', name: 'lets_ride', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Your Balance`
  String get your_balance {
    return Intl.message(
      'Your Balance',
      name: 'your_balance',
      desc: '',
      args: [],
    );
  }

  /// `Today's Earning`
  String get todays_earning {
    return Intl.message(
      'Today\'s Earning',
      name: 'todays_earning',
      desc: '',
      args: [],
    );
  }

  /// `Ride complete`
  String get your_ride_complete {
    return Intl.message(
      'Ride complete',
      name: 'your_ride_complete',
      desc: '',
      args: [],
    );
  }

  /// `Today's Activity`
  String get todays_activity {
    return Intl.message(
      'Today\'s Activity',
      name: 'todays_activity',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get view_all {
    return Intl.message('View All', name: 'view_all', desc: '', args: []);
  }

  /// `Ride History`
  String get ride_history {
    return Intl.message(
      'Ride History',
      name: 'ride_history',
      desc: '',
      args: [],
    );
  }

  /// `Payment Received`
  String get payment_received {
    return Intl.message(
      'Payment Received',
      name: 'payment_received',
      desc: '',
      args: [],
    );
  }

  /// `Payment Withdraw`
  String get payment_withdraw {
    return Intl.message(
      'Payment Withdraw',
      name: 'payment_withdraw',
      desc: '',
      args: [],
    );
  }

  /// `Current Balance`
  String get current_balance {
    return Intl.message(
      'Current Balance',
      name: 'current_balance',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get withdraw {
    return Intl.message('Withdraw', name: 'withdraw', desc: '', args: []);
  }

  /// `Withdraw Your Earnings`
  String get withdraw_your_earnings {
    return Intl.message(
      'Withdraw Your Earnings',
      name: 'withdraw_your_earnings',
      desc: '',
      args: [],
    );
  }

  /// `You've earned it! Choose where you want to send your money and hit withdraw.`
  String get withdraw_instruction {
    return Intl.message(
      'You\'ve earned it! Choose where you want to send your money and hit withdraw.',
      name: 'withdraw_instruction',
      desc: '',
      args: [],
    );
  }

  /// `Please enter amount`
  String get please_enter_amount {
    return Intl.message(
      'Please enter amount',
      name: 'please_enter_amount',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal Request Submitted Successfully!`
  String get withdrawal_success {
    return Intl.message(
      'Withdrawal Request Submitted Successfully!',
      name: 'withdrawal_success',
      desc: '',
      args: [],
    );
  }

  /// `Success! You've requested {amount} withdrawal. Funds will be transferred to your selected account shortly.`
  String withdrawal_request_success(Object amount) {
    return Intl.message(
      'Success! You\'ve requested $amount withdrawal. Funds will be transferred to your selected account shortly.',
      name: 'withdrawal_request_success',
      desc: '',
      args: [amount],
    );
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw History`
  String get withdraw_history {
    return Intl.message(
      'Withdraw History',
      name: 'withdraw_history',
      desc: '',
      args: [],
    );
  }

  /// `No transactions found`
  String get no_transactions_found {
    return Intl.message(
      'No transactions found',
      name: 'no_transactions_found',
      desc: '',
      args: [],
    );
  }

  /// `ID: `
  String get id {
    return Intl.message('ID: ', name: 'id', desc: '', args: []);
  }

  /// `Method: `
  String get method {
    return Intl.message('Method: ', name: 'method', desc: '', args: []);
  }

  /// `Total Rides`
  String get total_rides {
    return Intl.message('Total Rides', name: 'total_rides', desc: '', args: []);
  }

  /// `Total Distance`
  String get total_distance {
    return Intl.message(
      'Total Distance',
      name: 'total_distance',
      desc: '',
      args: [],
    );
  }

  /// `Average Rating`
  String get average_rating {
    return Intl.message(
      'Average Rating',
      name: 'average_rating',
      desc: '',
      args: [],
    );
  }

  /// `Payout Method`
  String get payout_method {
    return Intl.message(
      'Payout Method',
      name: 'payout_method',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get payment_method {
    return Intl.message(
      'Payment Method',
      name: 'payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Select Profile Image`
  String get select_profile_image {
    return Intl.message(
      'Select Profile Image',
      name: 'select_profile_image',
      desc: '',
      args: [],
    );
  }

  /// `Upload image`
  String get upload_image {
    return Intl.message(
      'Upload image',
      name: 'upload_image',
      desc: '',
      args: [],
    );
  }

  /// `Or select an avatar from the list below:`
  String get or_select_avatar {
    return Intl.message(
      'Or select an avatar from the list below:',
      name: 'or_select_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Accept Ride`
  String get accept_ride {
    return Intl.message('Accept Ride', name: 'accept_ride', desc: '', args: []);
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Rider Waiting — Move Now`
  String get rider_waiting_move_now {
    return Intl.message(
      'Rider Waiting — Move Now',
      name: 'rider_waiting_move_now',
      desc: '',
      args: [],
    );
  }

  /// `Time to pick up your rider! Follow the navigation and arrive without delay`
  String get time_to_pickup {
    return Intl.message(
      'Time to pick up your rider! Follow the navigation and arrive without delay',
      name: 'time_to_pickup',
      desc: '',
      args: [],
    );
  }

  /// `Go to Pickup Location`
  String get go_to_pickup_location {
    return Intl.message(
      'Go to Pickup Location',
      name: 'go_to_pickup_location',
      desc: '',
      args: [],
    );
  }

  /// `You’ve Arrived at the Pickup Point`
  String get arrived_pickup_point {
    return Intl.message(
      'You’ve Arrived at the Pickup Point',
      name: 'arrived_pickup_point',
      desc: '',
      args: [],
    );
  }

  /// `You’ve reached the pickup location. Please wait a few minutes for the rider to approach your vehicle.`
  String get reached_pickup_wait {
    return Intl.message(
      'You’ve reached the pickup location. Please wait a few minutes for the rider to approach your vehicle.',
      name: 'reached_pickup_wait',
      desc: '',
      args: [],
    );
  }

  /// `Tap to Confirm Your Arrival`
  String get tap_to_confirm_arrival {
    return Intl.message(
      'Tap to Confirm Your Arrival',
      name: 'tap_to_confirm_arrival',
      desc: '',
      args: [],
    );
  }

  /// `Pickup Rider`
  String get pickup_rider {
    return Intl.message(
      'Pickup Rider',
      name: 'pickup_rider',
      desc: '',
      args: [],
    );
  }

  /// `Double-check the rider’s name and verify their destination before proceeding.`
  String get double_check_rider {
    return Intl.message(
      'Double-check the rider’s name and verify their destination before proceeding.',
      name: 'double_check_rider',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Pickup`
  String get confirm_pickup {
    return Intl.message(
      'Confirm Pickup',
      name: 'confirm_pickup',
      desc: '',
      args: [],
    );
  }

  /// `All Set? Start the Ride Now`
  String get all_set_start_ride {
    return Intl.message(
      'All Set? Start the Ride Now',
      name: 'all_set_start_ride',
      desc: '',
      args: [],
    );
  }

  /// `Your Ride Has Started!`
  String get ride_started {
    return Intl.message(
      'Your Ride Has Started!',
      name: 'ride_started',
      desc: '',
      args: [],
    );
  }

  /// `Start the journey by following the in-app navigation. Make sure both parties are comfortable before beginning.`
  String get start_journey_navigation {
    return Intl.message(
      'Start the journey by following the in-app navigation. Make sure both parties are comfortable before beginning.',
      name: 'start_journey_navigation',
      desc: '',
      args: [],
    );
  }

  /// `Tap to Start Ride`
  String get tap_to_start_ride {
    return Intl.message(
      'Tap to Start Ride',
      name: 'tap_to_start_ride',
      desc: '',
      args: [],
    );
  }

  /// `Follow the directions, stay calm, and create a comfortable ride environment.`
  String get follow_directions_comfortable {
    return Intl.message(
      'Follow the directions, stay calm, and create a comfortable ride environment.',
      name: 'follow_directions_comfortable',
      desc: '',
      args: [],
    );
  }

  /// `You’ve Reached the Passenger’s Destination.`
  String get reached_passenger_destination {
    return Intl.message(
      'You’ve Reached the Passenger’s Destination.',
      name: 'reached_passenger_destination',
      desc: '',
      args: [],
    );
  }

  /// `The trip has ended as the passenger has reached their destination.`
  String get trip_ended_passenger_destination {
    return Intl.message(
      'The trip has ended as the passenger has reached their destination.',
      name: 'trip_ended_passenger_destination',
      desc: '',
      args: [],
    );
  }

  /// `Reached Destination`
  String get reached_destination {
    return Intl.message(
      'Reached Destination',
      name: 'reached_destination',
      desc: '',
      args: [],
    );
  }

  /// `The trip has ended. Wait for the passenger to complete their payment before closing the ride.`
  String get trip_ended_wait_payment {
    return Intl.message(
      'The trip has ended. Wait for the passenger to complete their payment before closing the ride.',
      name: 'trip_ended_wait_payment',
      desc: '',
      args: [],
    );
  }

  /// `Report Issue`
  String get reportIssue {
    return Intl.message(
      'Report Issue',
      name: 'reportIssue',
      desc: '',
      args: [],
    );
  }

  /// `Ride Details`
  String get rideDetails {
    return Intl.message(
      'Ride Details',
      name: 'rideDetails',
      desc: '',
      args: [],
    );
  }

  /// `Text been copied`
  String get textCopied {
    return Intl.message(
      'Text been copied',
      name: 'textCopied',
      desc: '',
      args: [],
    );
  }

  /// `Something Went Wrong? Report an Issue`
  String get reportIssueTitle {
    return Intl.message(
      'Something Went Wrong? Report an Issue',
      name: 'reportIssueTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tell us what went wrong. We’ll look into it immediately.`
  String get reportIssueSubtitle {
    return Intl.message(
      'Tell us what went wrong. We’ll look into it immediately.',
      name: 'reportIssueSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Report Type`
  String get reportType {
    return Intl.message('Report Type', name: 'reportType', desc: '', args: []);
  }

  /// `Select Report type`
  String get selectReportType {
    return Intl.message(
      'Select Report type',
      name: 'selectReportType',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `Write Issue Details`
  String get writeIssueDetails {
    return Intl.message(
      'Write Issue Details',
      name: 'writeIssueDetails',
      desc: '',
      args: [],
    );
  }

  /// `Please insert all Data`
  String get insertAllData {
    return Intl.message(
      'Please insert all Data',
      name: 'insertAllData',
      desc: '',
      args: [],
    );
  }

  /// `Your Issue Submitted Successfully`
  String get issueSubmitted {
    return Intl.message(
      'Your Issue Submitted Successfully',
      name: 'issueSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for reporting. Our team will review your issue and get back to you shortly.`
  String get thanksForReporting {
    return Intl.message(
      'Thanks for reporting. Our team will review your issue and get back to you shortly.',
      name: 'thanksForReporting',
      desc: '',
      args: [],
    );
  }

  /// `Request Entity Too Large`
  String get requestEntityTooLarge {
    return Intl.message(
      'Request Entity Too Large',
      name: 'requestEntityTooLarge',
      desc: '',
      args: [],
    );
  }

  /// `Ride Charge`
  String get rideCharge {
    return Intl.message('Ride Charge', name: 'rideCharge', desc: '', args: []);
  }

  /// `Expiry Date`
  String get expiryDate {
    return Intl.message('Expiry Date', name: 'expiryDate', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Your account is already active on another device. To use it here, the other device will be logged out.`
  String get yourAccountAlreadyActive {
    return Intl.message(
      'Your account is already active on another device. To use it here, the other device will be logged out.',
      name: 'yourAccountAlreadyActive',
      desc: '',
      args: [],
    );
  }

  /// `Logging in Somewhere Else`
  String get loggingInSomewhereElse {
    return Intl.message(
      'Logging in Somewhere Else',
      name: 'loggingInSomewhereElse',
      desc: '',
      args: [],
    );
  }

  /// `Stay on This Device`
  String get stayOnThisDevice {
    return Intl.message(
      'Stay on This Device',
      name: 'stayOnThisDevice',
      desc: '',
      args: [],
    );
  }

  /// `Pick from Gallery`
  String get pickFromGallery {
    return Intl.message(
      'Pick from Gallery',
      name: 'pickFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Take a Photo`
  String get takeAPhoto {
    return Intl.message('Take a Photo', name: 'takeAPhoto', desc: '', args: []);
  }

  /// `km`
  String get km {
    return Intl.message('km', name: 'km', desc: '', args: []);
  }

  /// `min`
  String get min {
    return Intl.message('min', name: 'min', desc: '', args: []);
  }

  /// `You can cancel ride in`
  String get you_can_cancel_ride_in {
    return Intl.message(
      'You can cancel ride in',
      name: 'you_can_cancel_ride_in',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
