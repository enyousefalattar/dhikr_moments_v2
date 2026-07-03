import 'package:flutter/material.dart';
import '../../core/services/progress_service.dart';
import '../../core/services/last_activity_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      appBar: AppBar(
        title: const Text("لوحة الإنجاز", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "إنجازات اليوم",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: ProgressService(),
              builder: (context, _) {
                final progress = ProgressService();
                return Row(
                  children: [
                    Expanded(
                      child: _ProgressCard(
                        title: "أذكار مكتملة",
                        count: progress.adhkarCount,
                        icon: Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ProgressCard(
                        title: "أدعية مقروءة",
                        count: progress.duasCount,
                        icon: Icons.menu_book_outlined,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "آخر النشاطات",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: LastActivityService(),
              builder: (context, _) {
                final lastActivity = LastActivityService();
                return Column(
                  children: [
                    _ActivityTile(
                      title: "آخر ذكر",
                      subtitle: lastActivity.lastAdhkar ?? "لا يوجد نشاط",
                      icon: Icons.history,
                    ),
                    _ActivityTile(
                      title: "آخر دعاء",
                      subtitle: lastActivity.lastDua ?? "لا يوجد نشاط",
                      icon: Icons.history,
                    ),
                    _ActivityTile(
                      title: "آخر سورة",
                      subtitle: lastActivity.lastSurah ?? "لا يوجد نشاط",
                      icon: Icons.history,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF1B5E20), size: 30),
                  SizedBox(height: 12),
                  Text(
                    "\"أحب الأعمال إلى الله أدومها وإن قل\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _ProgressCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            "$count",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(subtitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
