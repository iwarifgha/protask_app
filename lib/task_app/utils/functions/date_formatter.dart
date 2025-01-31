  import 'package:intl/intl.dart';

formatDate(DateTime isoDate) {
    final date =  DateFormat.yMMMd().format(isoDate);
  return date;
 }

  formatAsTime(DateTime timeString) {
    final  time =  DateFormat.jm().format(timeString);
  return time.split(' ')[0];
 }
