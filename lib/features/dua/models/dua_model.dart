enum DuaCategory { morning, evening, general }

class Dua {
  final String id;
  final String title;
  final String text;
  final DuaCategory category;
  bool isFavorite;

  Dua({
    required this.id,
    required this.title,
    required this.text,
    required this.category,
    this.isFavorite = false,
  });
}
