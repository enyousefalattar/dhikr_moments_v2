import 'dart:math';
import '../services/storage_service.dart';
import '../../features/adhkar/models/azkar_item.dart';

class HabitAnalyzer {
  static Future<AzkarItem?> getDailySuggestion(List<AzkarItem> allAzkar) async {
    if (allAzkar.isEmpty) return null;
    
    // Logic: Find an item with low view count
    // For simplicity, pick 10 random items and select the one with minimum view count
    final random = Random();
    AzkarItem? best;
    int minViews = 999999;

    for (int i = 0; i < 10; i++) {
      final candidate = allAzkar[random.nextInt(allAzkar.length)];
      final views = await StorageService.getDhikrViewCount(candidate.id);
      if (views < minViews) {
        minViews = views;
        best = candidate;
      }
    }
    
    if (best != null) {
      await StorageService.updateDhikrViewCount(best.id);
    }
    
    return best;
  }

  static List<AzkarItem> reorderBasedOnHabits(List<AzkarItem> list) {
    // Placeholder logic for reordering based on habits
    // In a full implementation, we'd track 'skipped' items
    return list;
  }
}
