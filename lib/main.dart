import 'dart:async';
import 'package:flutter/material.dart';
import 'core/services/notification_service.dart';
import 'core/services/time_service.dart';
import 'core/theme/app_theme.dart';
import 'features/main/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(const DhikrMomentsApp());
}

class DhikrMomentsApp extends StatefulWidget {
  const DhikrMomentsApp({super.key});

  @override
  State<DhikrMomentsApp> createState() => _DhikrMomentsAppState();
}

class _DhikrMomentsAppState extends State<DhikrMomentsApp> {
  late bool _isMorning;
  Timer? _themeTimer;

  @override
  void initState() {
    super.initState();
    _isMorning = TimeService.isMorning();
    // Check every minute if the theme needs to transition
    _themeTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final nowMorning = TimeService.isMorning();
      if (nowMorning != _isMorning) {
        setState(() {
          _isMorning = nowMorning;
        });
      }
    });
  }

  @override
  void dispose() {
    _themeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeSource = _isMorning ? AppTheme.morningTheme : AppTheme.eveningTheme;
    final primaryColor = themeSource['primaryColor'] as Color;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لحظات الذكر',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryColor,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const MainScreen(),
    );
  }
}
