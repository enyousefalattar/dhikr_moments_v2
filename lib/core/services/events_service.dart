import '../models/event_model.dart';

class EventsService {
  // Singleton pattern
  static final EventsService _instance = EventsService._internal();
  factory EventsService() => _instance;
  EventsService._internal();

  AppEvent? _manualOverride;

  void setManualOverride(AppEvent? event) {
    _manualOverride = event;
  }

  AppEvent getActiveEvent() {
    if (_manualOverride != null) return _manualOverride!;

    final now = DateTime.now();

    // Check Friday (Highest priority for weekly)
    if (now.weekday == DateTime.friday) {
      return AppEvent(
        id: 'friday',
        name: 'الجمعة 🕌',
        type: EventType.friday,
        description: 'يوم الجمعة خير يوم طلعت فيه الشمس',
        isActive: true,
      );
    }

    // Check Ramadan (Approximation as requested - using Gregorian Month 9 as placeholder logic for month 9)
    // Note: In real app, this would use a Hijri library.
    if (now.month == 9) {
      return AppEvent(
        id: 'ramadan',
        name: 'رمضان 🌙',
        type: EventType.ramadan,
        description: 'شهر الخير والبركة والقرآن',
        isActive: true,
      );
    }

    // Check Hajj (Month 12)
    if (now.month == 12) {
      return AppEvent(
        id: 'hajj',
        name: 'الحج 🕋',
        type: EventType.hajj,
        description: 'موسم الحج والعشر من ذي الحجة',
        isActive: true,
      );
    }

    // Check Eid (Fixed dates placeholders)
    // Example: 1st of month 10 (Eid al-Fitr) or 10th of month 12 (Eid al-Adha)
    if ((now.month == 10 && now.day == 1) || (now.month == 12 && now.day == 10)) {
      return AppEvent(
        id: 'eid',
        name: 'العيد 🎉',
        type: EventType.eid,
        description: 'فرحة المسلمين بعيدهم',
        isActive: true,
      );
    }

    return AppEvent(
      id: 'none',
      name: 'None',
      type: EventType.none,
      description: '',
      isActive: false,
    );
  }

  List<AppEvent> getAllEvents() {
    return [
      AppEvent(id: 'ramadan', name: 'رمضان 🌙', type: EventType.ramadan, description: 'شهر الصيام والقيام'),
      AppEvent(id: 'friday', name: 'الجمعة 🕌', type: EventType.friday, description: 'يوم مبارك وساعة استجابة'),
      AppEvent(id: 'eid', name: 'العيد 🎉', type: EventType.eid, description: 'عيد الفطر وعيد الأضحى'),
      AppEvent(id: 'hajj', name: 'الحج 🕋', type: EventType.hajj, description: 'موسم الحج إلى بيت الله الحرام'),
    ];
  }
}
