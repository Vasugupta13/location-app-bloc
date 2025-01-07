import 'package:intl/intl.dart';

class FormatTime{
  static String formatTime(DateTime date){
    final formattedTime = DateFormat('d MMM, hh:mm a').format(date);
    return formattedTime;
  }
}