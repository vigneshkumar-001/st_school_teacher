import 'package:intl/intl.dart';

class DateAndTimeConvert {
  static String formatDateTime(
    String dateTimeString, {
    bool showDate = true,
    bool showTime = true,
  }) {
    DateTime dateTime =
        DateTime.parse(
          dateTimeString,
        ).toLocal(); // Convert to Indian local time

    String datePart = showDate ? DateFormat('dd-MM-yyyy').format(dateTime) : '';
    String timePart = showTime ? DateFormat('hh:mm a').format(dateTime) : '';

    if (showDate && showTime) {
      return "$datePart $timePart";
    } else if (showDate) {
      return datePart;
    } else if (showTime) {
      return timePart;
    }
    return '';
  }
}
