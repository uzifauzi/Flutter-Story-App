import 'package:intl/intl.dart';

String formatDateTime(DateTime time) {
  return DateFormat.yMMMMd().add_jm().format(time);
}
