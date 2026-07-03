import 'package:hijri/hijri_calendar.dart';
import '../data/events_database.dart';
import '../models/islamic_event.dart';

class TimeService {
  static bool isMorning() {
    final hour = DateTime.now().hour;
    return hour >= 4 && hour < 12;
  }

  static String getCurrentHijriDate() {
    final hDate = HijriCalendar.now();
    return "${hDate.hDay} ${hDate.longMonthName} ${hDate.hYear}";
  }

  static IslamicEvent? getTodaysEvent() {
    final hDate = HijriCalendar.now();
    return getCurrentEvent(hDate.hMonth, hDate.hDay);
  }
}
