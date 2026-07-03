import '../models/islamic_event.dart';

final List<IslamicEvent> allEvents = [
  const IslamicEvent(
    name: 'رأس السنة الهجرية',
    description: 'بداية العام الهجري الجديد ذكرى هجرة النبي ﷺ',
    hijriMonth: 1,
    hijriDay: 1,
    themeColor: '#2C3E50',
    icon: '🕌',
  ),
  const IslamicEvent(
    name: 'يوم عاشوراء',
    description: 'اليوم الذي نجى الله فيه موسى عليه السلام',
    hijriMonth: 1,
    hijriDay: 10,
    themeColor: '#8E44AD',
    icon: '🌙',
  ),
  const IslamicEvent(
    name: 'المولد النبوي',
    description: 'ذكرى مولد خير الأنام محمد ﷺ',
    hijriMonth: 3,
    hijriDay: 12,
    themeColor: '#27AE60',
    icon: '🌟',
  ),
  const IslamicEvent(
    name: 'الإسراء والمعراج',
    description: 'رحلة النبي ﷺ من المسجد الحرام إلى المسجد الأقصى',
    hijriMonth: 7,
    hijriDay: 27,
    themeColor: '#2980B9',
    icon: '✈️',
  ),
  const IslamicEvent(
    name: 'ليلة النصف من شعبان',
    description: 'ليلة مباركة تُحول فيها القبلة وتُرفع فيها الأعمال',
    hijriMonth: 8,
    hijriDay: 15,
    themeColor: '#8E44AD',
    icon: '🌙',
  ),
  const IslamicEvent(
    name: 'بداية رمضان',
    description: 'أول يوم في شهر الصيام والقيام والقرآن',
    hijriMonth: 9,
    hijriDay: 1,
    themeColor: '#1ABC9C',
    icon: '📖',
  ),
  const IslamicEvent(
    name: 'ليلة القدر',
    description: 'ليلة خير من ألف شهر نزل فيها القرآن',
    hijriMonth: 9,
    hijriDay: 27,
    themeColor: '#F1C40F',
    icon: '⭐',
  ),
  const IslamicEvent(
    name: 'عيد الفطر',
    description: 'جائزة الصائمين وفرحة المسلمين بإتمام رمضان',
    hijriMonth: 10,
    hijriDay: 1,
    themeColor: '#F39C12',
    icon: '🎉',
  ),
  const IslamicEvent(
    name: 'يوم عرفة',
    description: 'خير يوم طلعت فيه الشمس، ركن الحج الأعظم',
    hijriMonth: 12,
    hijriDay: 9,
    themeColor: '#E74C3C',
    icon: '🕋',
  ),
  const IslamicEvent(
    name: 'عيد الأضحى',
    description: 'يوم النحر وذكرى فداء إسماعيل عليه السلام',
    hijriMonth: 12,
    hijriDay: 10,
    themeColor: '#C0392B',
    icon: '🐏',
  ),
];

IslamicEvent? getCurrentEvent(int month, int day) {
  try {
    return allEvents.firstWhere(
      (event) => event.hijriMonth == month && event.hijriDay == day,
    );
  } catch (e) {
    return null;
  }
}

// إيجاد أقرب مناسبة قادمة (بعد اليوم الحالي)
IslamicEvent? getNextEvent(int month, int day) {
  final currentVal = month * 32 + day;
  
  // فرز المناسبات زمنياً
  List<IslamicEvent> sortedEvents = List.from(allEvents);
  sortedEvents.sort((a, b) => (a.hijriMonth * 32 + a.hijriDay).compareTo(b.hijriMonth * 32 + b.hijriDay));

  try {
    // البحث عن أول مناسبة بعد التاريخ الحالي
    return sortedEvents.firstWhere(
      (event) => (event.hijriMonth * 32 + event.hijriDay) > currentVal,
    );
  } catch (e) {
    // إذا لم توجد مناسبة متبقية في السنة الحالية، نعود لأول مناسبة في السنة القادمة
    return sortedEvents.first;
  }
}

// حساب الأيام المتبقية لمناسبة معينة
int getRemainingDays(int currentMonth, int currentDay, int targetMonth, int targetDay) {
  int currentDays = currentMonth * 30 + currentDay;
  int targetDays = targetMonth * 30 + targetDay;

  if (targetDays >= currentDays) {
    return targetDays - currentDays;
  } else {
    // إذا كانت المناسبة في السنة القادمة
    return (360 - currentDays) + targetDays;
  }
}
