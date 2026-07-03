import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/time_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/habit_analyzer.dart';
import '../../../core/services/azkar_repository.dart';
import '../../adhkar/models/azkar_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _todayAdhkar = 0;
  int _todayTasbih = 0;
  int _favoritesCount = 0;
  int _streak = 0;
  bool _isMorning = true;
  bool _isDarkMode = false;
  AzkarItem? _dailySuggestion;

  @override
  void initState() {
    super.initState();
    _isMorning = TimeService.isMorning();
    _loadStats();
    _loadSuggestion();
  }

  Future<void> _loadStats() async {
    final adhkar = await StorageService.getTodayAdhkarCount();
    final tasbih = await StorageService.getCounter();
    final favorites = await StorageService.getFavorites();
    final isDark = await StorageService.isDarkMode();
    
    // Streak logic
    final lastDateStr = await StorageService.getLastActivityDate();
    final today = DateTime.now();
    final todayStr = today.toIso8601String().split('T')[0];
    
    int streak = 0;
    if (lastDateStr != null) {
      final lastDate = DateTime.parse(lastDateStr);
      final difference = today.difference(lastDate).inDays;
      
      if (difference == 0) {
        streak = 1; // Simplified streak: active today
      } else if (difference == 1) {
        streak = 2; // Active yesterday and today
      }
    } else {
      streak = 1;
    }
    
    setState(() {
      _todayAdhkar = adhkar;
      _todayTasbih = tasbih;
      _favoritesCount = favorites.length;
      _streak = streak; 
      _isDarkMode = isDark;
    });
    
    await StorageService.saveLastActivityDate(todayStr);
    await StorageService.recordAppOpen();
  }

  Future<void> _loadSuggestion() async {
    final all = await AzkarRepository().loadAzkar();
    final suggestion = await HabitAnalyzer.getDailySuggestion(all);
    setState(() {
      _dailySuggestion = suggestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = TimeService.getTodaysEvent();
    
    final themeSource = _isDarkMode 
        ? (_isMorning ? AppTheme.darkMorningTheme : AppTheme.darkEveningTheme)
        : (_isMorning ? AppTheme.morningTheme : AppTheme.eveningTheme);
    
    final gradientColors = themeSource['gradientColors'] as List<Color>;
    final textColor = themeSource['textColor'] as Color;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Welcome Card
                Text(
                  _isMorning ? "صباح الخير" : "مساء الخير",
                  style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  "تقبل الله منك صالح الأعمال",
                  style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Suggestion Card
                if (_dailySuggestion != null)
                  _buildSuggestionCard(_dailySuggestion!, textColor),

                const SizedBox(height: 20),

                // Circular Progress
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: _isDarkMode ? 0.1 : 0.9),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: _todayAdhkar / 30.0, // Fixed goal for UI
                            strokeWidth: 8,
                            backgroundColor: Colors.grey.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${(_todayAdhkar / 30.0 * 100).toInt()}%",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black),
                            ),
                            const Text("إنجاز اليوم", style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Event Card
                if (event != null)
                  _buildEventCard(event),
                const SizedBox(height: 20),

                // 3. Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildStatCard("الأذكار اليومية", "$_todayAdhkar", Icons.check_circle_outline, _isDarkMode),
                    _buildStatCard("مجموع التسبيح", "$_todayTasbih", Icons.add_circle_outline, _isDarkMode),
                    _buildStatCard("المفضلة", "$_favoritesCount", Icons.favorite_border, _isDarkMode),
                    _buildStatCard("الاستمرار", "$_streak", Icons.local_fire_department_outlined, _isDarkMode),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(dynamic event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(event.icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(event.description, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(AzkarItem item, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text("اقتراح اليوم المميز", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor, fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String val, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(height: 8),
          Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
