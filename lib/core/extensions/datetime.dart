import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  bool isSameDate(DateTime to) =>
      year == to.year && month == to.month && day == to.day;

  bool get isToday => isSameDate(DateTime.now());

  String get _formatTimeAmPm => DateFormat('hh:mm a', 'en').format(this);


  String get _formatDateTimeAmPm => DateFormat('dd MMM hh:mm a', 'en').format(this);


  String get formatTime => _formatTimeAmPm;

  String get formatDateTime => _formatDateTimeAmPm;

  String get formattedSmartTimestamp {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (isSameDate(now)) {
      return formatTime; // today
    } else if (isSameDate(yesterday)) {
      return 'Yesterday, $formatTime';
    } else {
      return DateFormat('dd MMM yyyy, hh:mm a', 'en').format(this); // older
    }
  }

}
