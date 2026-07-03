enum EventType { ramadan, friday, eid, hajj, none }

class AppEvent {
  final String id;
  final String name;
  final EventType type;
  final String description;
  final bool isActive;

  AppEvent({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.isActive = false,
  });

  AppEvent copyWith({bool? isActive}) {
    return AppEvent(
      id: id,
      name: name,
      type: type,
      description: description,
      isActive: isActive ?? this.isActive,
    );
  }
}
