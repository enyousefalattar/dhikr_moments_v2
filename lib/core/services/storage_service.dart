import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _counterKey = 'tasbih_counter';
  static const String _lastDateKey = 'last_date';
  static const String _lastActivityDateKey = 'last_activity_date';
  static const String _todayAdhkarCountKey = 'today_adhkar_count';
  static const String _totalDhikrCountKey = 'total_dhikr_count';
  static const String _morningNotifKey = 'morning_notification_enabled';
  static const String _eveningNotifKey = 'evening_notification_enabled';
  static const String _favoritesKey = 'favorites_list';
  static const String _darkModeKey = 'is_dark_mode';
  static const String _lastOpenKey = 'last_app_open';
  static const String _dhikrViewCountsKey = 'dhikr_view_counts'; // Map of ID to count

  static Future<void> saveCounter(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, count);
    await prefs.setString(_lastDateKey, DateTime.now().toIso8601String().split('T')[0]);
  }

  static Future<int> getCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_lastDateKey) ?? '';
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastDate != today) {
      await prefs.setInt(_counterKey, 0);
      return 0;
    }
    return prefs.getInt(_counterKey) ?? 0;
  }

  static Future<void> saveLastActivityDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastActivityDateKey, date);
  }

  static Future<String?> getLastActivityDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastActivityDateKey);
  }

  static Future<void> incrementTodayAdhkarCount() async {
    final prefs = await SharedPreferences.getInstance();
    int current = prefs.getInt(_todayAdhkarCountKey) ?? 0;
    await prefs.setInt(_todayAdhkarCountKey, current + 1);
  }

  static Future<int> getTodayAdhkarCount() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_lastDateKey) ?? '';
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastDate != today) {
      await prefs.setInt(_todayAdhkarCountKey, 0);
      return 0;
    }
    return prefs.getInt(_todayAdhkarCountKey) ?? 0;
  }

  static Future<void> saveTotalDhikrCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalDhikrCountKey, count);
  }

  static Future<int> getTotalDhikrCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalDhikrCountKey) ?? 0;
  }

  static Future<void> setMorningNotification(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_morningNotifKey, enabled);
  }

  static Future<bool> isMorningNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_morningNotifKey) ?? true;
  }

  static Future<void> setEveningNotification(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_eveningNotifKey, enabled);
  }

  static Future<bool> isEveningNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_eveningNotifKey) ?? true;
  }

  static Future<void> toggleFavorite(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (favorites.contains(itemId)) {
      favorites.remove(itemId);
    } else {
      favorites.add(itemId);
    }
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<bool> isFavorite(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.contains(itemId);
  }

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, enabled);
  }

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? false;
  }

  static Future<void> recordAppOpen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastOpenKey, DateTime.now().toIso8601String());
  }

  static Future<DateTime?> getLastOpenTime() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_lastOpenKey);
    return val != null ? DateTime.parse(val) : null;
  }

  static Future<void> updateDhikrViewCount(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final counts = prefs.getStringList(_dhikrViewCountsKey) ?? [];
    // Simple encoding for a map-like structure in SharedPreferences
    // format: id:count
    int foundIndex = counts.indexWhere((s) => s.startsWith('$id:'));
    if (foundIndex != -1) {
      final parts = counts[foundIndex].split(':');
      int current = int.parse(parts[1]);
      counts[foundIndex] = '$id:${current + 1}';
    } else {
      counts.add('$id:1');
    }
    await prefs.setStringList(_dhikrViewCountsKey, counts);
  }

  static Future<int> getDhikrViewCount(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final counts = prefs.getStringList(_dhikrViewCountsKey) ?? [];
    int foundIndex = counts.indexWhere((s) => s.startsWith('$id:'));
    if (foundIndex != -1) {
      return int.parse(counts[foundIndex].split(':')[1]);
    }
    return 0;
  }
}
