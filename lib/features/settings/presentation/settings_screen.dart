import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/time_service.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _morningEnabled = true;
  bool _eveningEnabled = true;
  bool _isDarkMode = false;
  bool _isMorning = true;

  @override
  void initState() {
    super.initState();
    _isMorning = TimeService.isMorning();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final m = await StorageService.isMorningNotificationEnabled();
    final e = await StorageService.isEveningNotificationEnabled();
    final d = await StorageService.isDarkMode();
    setState(() {
      _morningEnabled = m;
      _eveningEnabled = e;
      _isDarkMode = d;
    });
  }

  Future<void> _toggleMorning(bool val) async {
    setState(() => _morningEnabled = val);
    await StorageService.setMorningNotification(val);
    if (val) {
      await NotificationService.scheduleMorningReminder();
    } else {
      _syncNotifications();
    }
  }

  Future<void> _toggleEvening(bool val) async {
    setState(() => _eveningEnabled = val);
    await StorageService.setEveningNotification(val);
    if (val) {
      await NotificationService.scheduleEveningReminder();
    } else {
      _syncNotifications();
    }
  }

  Future<void> _toggleDarkMode(bool val) async {
    setState(() => _isDarkMode = val);
    await StorageService.setDarkMode(val);
    // In a real app we might use a ThemeProvider, but here we update local state
  }

  Future<void> _syncNotifications() async {
    await NotificationService.cancelAllReminders();
    if (_morningEnabled) await NotificationService.scheduleMorningReminder();
    if (_eveningEnabled) await NotificationService.scheduleEveningReminder();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode 
        ? (_isMorning ? AppTheme.darkMorningTheme : AppTheme.darkEveningTheme)
        : (_isMorning ? AppTheme.morningTheme : AppTheme.eveningTheme);
    final gradientColors = theme['gradientColors'] as List<Color>;

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("الإعدادات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle("المظهر"),
              Card(
                color: Colors.white.withValues(alpha: _isDarkMode ? 0.1 : 0.9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: SwitchListTile(
                  title: const Text("الوضع الداكن"),
                  value: _isDarkMode,
                  onChanged: _toggleDarkMode,
                  activeThumbColor: Colors.amber,
                ),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle("الإشعارات"),
              Card(
                color: Colors.white.withValues(alpha: _isDarkMode ? 0.1 : 0.9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("تنبيه أذكار الصباح"),
                      subtitle: const Text("الساعة 6:00 صباحاً"),
                      value: _morningEnabled,
                      onChanged: _toggleMorning,
                      activeThumbColor: const Color(0xFFFF8F00),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    SwitchListTile(
                      title: const Text("تنبيه أذكار المساء"),
                      subtitle: const Text("الساعة 6:00 مساءً"),
                      value: _eveningEnabled,
                      onChanged: _toggleEvening,
                      activeThumbColor: const Color(0xFF536DFE),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("التطبيق"),
              Card(
                color: Colors.white.withValues(alpha: _isDarkMode ? 0.1 : 0.9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.share_outlined),
                      title: const Text("مشاركة التطبيق"),
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.star_outline),
                      title: const Text("تقييم التطبيق"),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
