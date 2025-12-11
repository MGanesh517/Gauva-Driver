extension StringExtensions on String {
  bool get isValidEmail =>
      RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$').hasMatch(this);
}
