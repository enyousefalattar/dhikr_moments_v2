import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/data/events_database.dart';
import '../../../core/services/time_service.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    final hDate = HijriCalendar.now();
    final currentEvent = TimeService.getTodaysEvent();
    final nextEvent = getNextEvent(hDate.hMonth, hDate.hDay);
    
    int remainingDays = 0;
    if (nextEvent != null) {
      remainingDays = getRemainingDays(
        hDate.hMonth, 
        hDate.hDay, 
        nextEvent.hijriMonth, 
        nextEvent.hijriDay
      );
    }

    // Upcoming events in next 30 days
    final upcomingEvents = allEvents.where((e) {
      final days = getRemainingDays(hDate.hMonth, hDate.hDay, e.hijriMonth, e.hijriDay);
      return days > 0 && days <= 30;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hijri Date Header
          Center(
            child: Text(
              TimeService.getCurrentHijriDate(),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // 1. Current Event Card
          if (currentEvent != null) ...[
            const Text(
              "مناسبة اليوم",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _hexToColor(currentEvent.themeColor).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Text(currentEvent.icon, style: const TextStyle(fontSize: 50)),
                  const SizedBox(height: 10),
                  Text(
                    currentEvent.name,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentEvent.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 2. Countdown Card
          if (nextEvent != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.white, size: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("المناسبة القادمة:", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text(nextEvent.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text(
                    "$remainingDays يوم",
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // 3. Upcoming List
          const Text(
            "مناسبات قريبة",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (upcomingEvents.isEmpty)
            const Text("لا توجد مناسبات قريبة", style: TextStyle(color: Colors.white70))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingEvents.length,
              itemBuilder: (context, index) {
                final event = upcomingEvents[index];
                return Card(
                  color: Colors.white.withValues(alpha: 0.9),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Text(event.icon, style: const TextStyle(fontSize: 24)),
                    title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${event.hijriDay} ${hDate.getMonths()[event.hijriMonth]}"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
