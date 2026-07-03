import 'dart:convert';
import 'package:flutter/services.dart';
import '../../features/adhkar/models/azkar_item.dart';

class AzkarRepository {
  static List<AzkarItem>? _cachedList;

  Future<List<AzkarItem>> loadAzkar() async {
    if (_cachedList != null) return _cachedList!;
    
    try {
      final String response = await rootBundle.loadString('assets/data/azkar.json');
      final data = json.decode(response) as Map<String, dynamic>;
      final rows = data['rows'] as List<dynamic>;
      
      _cachedList = rows.map((row) => AzkarItem.fromRow(row as List<dynamic>)).toList();
      return _cachedList!;
    } catch (e) {
      return [];
    }
  }

  List<AzkarItem> getMorningAzkar(List<AzkarItem> all) {
    return all.where((item) => item.category.contains('أذكار الصباح')).toList();
  }

  List<AzkarItem> getEveningAzkar(List<AzkarItem> all) {
    return all.where((item) => item.category.contains('أذكار المساء')).toList();
  }
}
