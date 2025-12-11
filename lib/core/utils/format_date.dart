import 'package:intl/intl.dart';

String formatDateEnglish(String? isoDate) {
  if (isoDate == null) return 'N/A';

  try {
    final date = DateTime.parse(isoDate);
    final formatter = DateFormat('dd/MM/yyyy', 'en');
    return formatter.format(date);
  } catch (e) {
    return 'Invalid';
  }
}


String formatTimeEnglish(String? isoDate) {
  if (isoDate == null) return 'N/A';

  try {
    final date = DateTime.parse(isoDate);
    final formatter = DateFormat('h:mm a', 'en'); // Example: 4:30 PM
    return formatter.format(date);
  } catch (e) {
    return 'Invalid';
  }
}
