import 'package:flutter/material.dart';
import '../../models/surah_model.dart';

class SurahDetailScreen extends StatelessWidget {
  final Surah surah;
  const SurahDetailScreen({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      appBar: AppBar(
        title: Text(surah.nameArabic, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                surah.nameArabic,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
              ),
              const SizedBox(height: 16),
              Text(
                "سورَة ${surah.type == SurahType.meccan ? 'مكية' : 'مدنية'}",
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              const Text(
                "محتوى السورة سيظهر هنا قريباً إن شاء الله",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, height: 1.5),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Color(0xFF1B5E20)),
            ],
          ),
        ),
      ),
    );
  }
}
