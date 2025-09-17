import 'package:intl/intl.dart';

class DateAndTimeConvert {
  static String formatDateTime(
      String dateTimeStr, {
        bool showDate = true,
        bool showTime = true,
      }) {
    if (dateTimeStr.isEmpty) return '';

    final dateTime = DateTime.tryParse(dateTimeStr);
    if (dateTime == null) return '';

    String datePart = showDate ? DateFormat('dd-MM-yyyy').format(dateTime) : '';
    String timePart = showTime ? DateFormat('hh:mm a').format(dateTime) : '';

    if (showDate && showTime) return "$datePart $timePart";
    if (showDate) return datePart;
    if (showTime) return timePart;
    return '';
  }

  /// ✅ "08:59 AM  18-Jul-2025"
  static String timeWithShortDate(String dateTimeStr) {
    if (dateTimeStr.isEmpty) return '';

    final dateTime = DateTime.tryParse(dateTimeStr);
    if (dateTime == null) return '';

    final time = DateFormat('hh:mm a').format(dateTime);
    final date = DateFormat('dd.MMM.yyyy').format(dateTime);

    return "$time  $date";
  }

  /// ✅ "12 Jul 25"
  static String shortDate(String dateTimeStr) {
    if (dateTimeStr.isEmpty) return '';

    final dateTime = DateTime.tryParse(dateTimeStr);
    if (dateTime == null) return '';

    return DateFormat('dd MMM yy').format(dateTime);
  }
}
