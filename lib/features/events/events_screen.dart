import 'package:flutter/material.dart';
import '../../core/models/event_model.dart';
import '../../core/services/events_service.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final EventsService _eventsService = EventsService();
  late AppEvent _activeEvent;
  late List<AppEvent> _allEvents;

  @override
  void initState() {
    super.initState();
    _refreshEvents();
  }

  void _refreshEvents() {
    setState(() {
      _activeEvent = _eventsService.getActiveEvent();
      _allEvents = _eventsService.getAllEvents();
    });
  }

  void _onOverride(AppEvent event) {
    setState(() {
      if (_activeEvent.id == event.id) {
        _eventsService.setManualOverride(null);
      } else {
        _eventsService.setManualOverride(event.copyWith(isActive: true));
      }
      _refreshEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      appBar: AppBar(
        title: const Text("المناسبات الإسلامية", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("الحدث الحالي", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _EventCard(
              event: _activeEvent,
              isCurrent: true,
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const Text("جميع المناسبات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._allEvents.map((event) => _EventCard(
                  event: event,
                  isCurrent: _activeEvent.id == event.id,
                  onTap: () => _onOverride(event),
                )),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final AppEvent event;
  final bool isCurrent;
  final VoidCallback onTap;

  const _EventCard({
    required this.event,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (event.type == EventType.none && isCurrent) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text("لا توجد مناسبة نشطة حالياً", textAlign: TextAlign.center),
      );
    }

    return Card(
      elevation: isCurrent ? 4 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrent ? const BorderSide(color: Colors.green, width: 2) : BorderSide.none,
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(event.description),
        trailing: isCurrent ? const Icon(Icons.check_circle, color: Colors.green) : const Icon(Icons.circle_outlined),
      ),
    );
  }
}
