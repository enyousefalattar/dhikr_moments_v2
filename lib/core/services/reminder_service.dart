class ReminderService {
  static final ReminderService _instance = ReminderService._internal();
  factory ReminderService() => _instance;
  ReminderService._internal();

  String? getPendingReminder() {
    final now = DateTime.now();
    
    // Morning: 8 AM to 10 AM
    if (now.hour >= 8 && now.hour < 10) {
      return "حان وقت أذكار الصباح ☀️";
    }
    
    // Evening: 6 PM to 8 PM
    if (now.hour >= 18 && now.hour < 20) {
      return "حان وقت أذكار المساء 🌙";
    }
    
    // Friday
    if (now.weekday == DateTime.friday && now.hour >= 10 && now.hour < 14) {
      return "لا تنس قراءة سورة الكهف والصلاة على النبي ﷺ 🕌";
    }
    
    return null;
  }
}
