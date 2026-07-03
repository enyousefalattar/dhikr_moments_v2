import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../../core/services/time_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_theme.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool _isMorning = true;
  bool _isDarkMode = false;
  PrayerTimes? _prayerTimes;
  String _locationStatus = "جاري تحديد الموقع...";

  @override
  void initState() {
    super.initState();
    _isMorning = TimeService.isMorning();
    _loadState();
    _getPrayerTimes();
  }

  Future<void> _loadState() async {
    final dark = await StorageService.isDarkMode();
    setState(() {
      _isDarkMode = dark;
    });
  }

  Future<void> _getPrayerTimes() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _locationStatus = "الإذن مرفوض دائماً");
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      final coordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.egyptian.getParameters();
      params.madhab = Madhab.shafi;

      setState(() {
        _prayerTimes = PrayerTimes.today(coordinates, params);
        _locationStatus = "تم تحديد الموقع";
      });
    } catch (e) {
      setState(() => _locationStatus = "خطأ في تحديد الموقع");
    }
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("القبلة ومواقيت الصلاة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Qibla Placeholder
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.explore, color: Colors.white, size: 60),
                        SizedBox(height: 10),
                        Text("مؤشر القبلة", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(_locationStatus, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 20),
                
                // Prayer Times Card
                Card(
                  color: Colors.white.withValues(alpha: _isDarkMode ? 0.1 : 0.9),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "مواقيت الصلاة اليوم",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 30),
                        if (_prayerTimes != null) ...[
                          _buildPrayerRow("الفجر", _prayerTimes!.fajr, textColor),
                          _buildPrayerRow("الشروق", _prayerTimes!.sunrise, textColor),
                          _buildPrayerRow("الظهر", _prayerTimes!.dhuhr, textColor),
                          _buildPrayerRow("العصر", _prayerTimes!.asr, textColor),
                          _buildPrayerRow("المغرب", _prayerTimes!.maghrib, textColor),
                          _buildPrayerRow("العشاء", _prayerTimes!.isha, textColor),
                        ] else
                          const Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerRow(String name, DateTime time, Color textColor) {
    final format = DateFormat.jm();
    final nextPrayer = _prayerTimes?.nextPrayer();
    bool isNext = false;
    
    if (nextPrayer != null) {
      if (name == "الفجر" && nextPrayer == Prayer.fajr) isNext = true;
      if (name == "الظهر" && nextPrayer == Prayer.dhuhr) isNext = true;
      if (name == "العصر" && nextPrayer == Prayer.asr) isNext = true;
      if (name == "المغرب" && nextPrayer == Prayer.maghrib) isNext = true;
      if (name == "العشاء" && nextPrayer == Prayer.isha) isNext = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16, 
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              color: isNext ? Colors.green : (_isDarkMode ? Colors.white : Colors.black87),
            ),
          ),
          Text(
            format.format(time),
            style: TextStyle(
              fontSize: 16, 
              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              color: isNext ? Colors.green : (_isDarkMode ? Colors.white70 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
