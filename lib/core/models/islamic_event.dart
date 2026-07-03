class IslamicEvent {
  final String name;
  final String description;
  final int hijriMonth;
  final int hijriDay;
  final String themeColor;
  final String icon;
  final List<String> recommendedDuas;

  const IslamicEvent({
    required this.name,
    required this.description,
    required this.hijriMonth,
    required this.hijriDay,
    required this.themeColor,
    required this.icon,
    this.recommendedDuas = const [],
  });
}
