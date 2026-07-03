enum AdhkarCategory { morning, evening }

class Adhkar {
  final String id;
  final String title;
  final String text;
  final int totalCount;
  final AdhkarCategory category;
  int currentCount;

  Adhkar({
    required this.id,
    required this.title,
    required this.text,
    required this.totalCount,
    required this.category,
  }) : currentCount = totalCount;

  bool get isCompleted => currentCount == 0;

  void decrement() {
    if (currentCount > 0) {
      currentCount--;
    }
  }

  void reset() {
    currentCount = totalCount;
  }
}
