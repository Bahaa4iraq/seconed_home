import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:z_time_ago/z_time_ago.dart';
String toDateOnly(int millis) {
  var dt = DateTime.fromMillisecondsSinceEpoch(millis);
  return DateFormat('dd-MM-yyyy').format(dt);
}
String toDateTime(String datetime){
  DateTime dateTime = DateTime.parse(datetime).toLocal();
  String formattedDateTime = DateFormat("dd-MM-yyyy\nhh:mm a").format(dateTime);

  return formattedDateTime;
}

String toDateAndTime(int millis, int format) {
  var dt = DateTime.fromMillisecondsSinceEpoch(millis);

  if (format == 12) {
    /// 12 Hour format:
    return DateFormat('dd-MM-yyyy, hh:mm a').format(dt);
  } else {
    /// 24 Hour format:
    return DateFormat('dd-MM-yyyy, HH:mm').format(dt);
  }
}

String getChatDate(int millis, int format) {
  var dt = DateTime.fromMillisecondsSinceEpoch(millis);

  if (format == 12) {
    /// 12 Hour format:
    return DateFormat('dd-MM, hh:mm a').format(dt);
  } else {
    /// 24 Hour format:
    return DateFormat('dd-MM, HH:mm').format(dt);
  }
}

String toTimeOnly(int millis, int format) {
  var dt = DateTime.fromMillisecondsSinceEpoch(millis);

  if (format == 12) {
    /// 12 Hour format:
    return DateFormat('hh:mm a').format(dt);
  } else {
    /// 24 Hour format:
    return DateFormat('HH:mm').format(dt);
  }
}

String secondToTime(int _second) {
  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
  final d3 = Duration(seconds: _second);
  return format(d3);
}

String fromISOToDate(String _date){
  DateTime now = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(_date);
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  return formattedDate;
}

String toDayOnly(int millis) {
  var dt = DateTime.fromMillisecondsSinceEpoch(millis);
  return DateFormat('dd').format(dt);
}
String toDayOfWeek(int millis) {
  initializeDateFormatting('ar_IQ', null);
  var dt = DateTime.fromMillisecondsSinceEpoch(millis);
  return DateFormat('EEEE','ar_IQ').format(dt);
}

String stringToDayOfWeek(String date) {
  initializeDateFormatting('ar_IQ', null);
  DateTime now = DateFormat("yyyy-MM-dd").parse(date);
  return DateFormat('EEEE','ar_IQ').format(now);
}

String toMonthOnlyAR(int millis) {
  initializeDateFormatting('ar_IQ', null);
  var dt = DateTime.fromMillisecondsSinceEpoch(millis);
  return DateFormat('MMM',"ar_IQ").format(dt);
}

String toYearOnly(int millis) {
  var dt = DateTime.fromMillisecondsSinceEpoch(millis);
  return DateFormat('yyyy').format(dt);
}

String lastSeenTime(int? millis) {
  if(millis !=null){
    var dt = DateTime.fromMillisecondsSinceEpoch(millis);
    String _date =  ZTimeAgo().getTimeAgo(
      //'2022-01-28 11:46:54.897839'
      date: DateFormat('yyyy-MM-dd HH:mm:ss').format(dt),
      language: Language.arabic,
    );
    return _date;
  }else{
    return "منذ مدة";
  }

}

DateTime toDateAndTimeDateTime(int millis, int format) {
  var dt = DateTime.fromMillisecondsSinceEpoch(millis);

  if (format == 12) {
    /// 12 Hour format:
     String timeString = DateFormat('dd-MM-yyyy, hh:mm a').format(dt);
     return DateFormat("dd-MM-yyyy, hh:mm a").parse(timeString);
  } else {
    /// 24 Hour format:

    String timeString = DateFormat('dd-MM-yyyy, HH:mm').format(dt);
    return DateFormat("dd-MM-yyyy, HH:mm").parse(timeString);
  }
}
