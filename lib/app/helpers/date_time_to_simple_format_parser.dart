import 'package:intl/intl.dart';

String? formatDateTime(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }

  final formatter = DateFormat('dd:MM:yy HH:mm');
  return formatter.format(dateTime);
}