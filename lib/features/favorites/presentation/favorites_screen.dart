import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/azkar_repository.dart';
import '../../../core/services/time_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../adhkar/models/azkar_item.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<AzkarItem> _favoriteAzkar = [];
  bool _isLoading = true;
  bool _isMorning = true;

  @override
  void initState() {
    super.initState();
    _isMorning = TimeService.isMorning();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    final repository = AzkarRepository();
    final all = await repository.loadAzkar();
    final favoriteIds = await StorageService.getFavorites();
    
    setState(() {
      _favoriteAzkar = all.where((item) => favoriteIds.contains(item.id)).toList();
      _isLoading = false;
    });
  }

  Future<void> _removeFromFavorites(String id) async {
    await StorageService.toggleFavorite(id);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isMorning ? AppTheme.morningTheme : AppTheme.eveningTheme;
    final gradientColors = theme['gradientColors'] as List<Color>;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("المفضلة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _favoriteAzkar.isEmpty 
              ? const Center(child: Text("قائمة المفضلة فارغة", style: TextStyle(color: Colors.white70, fontSize: 18)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favoriteAzkar.length,
                  itemBuilder: (context, index) {
                    final item = _favoriteAzkar[index];
                    return Card(
                      color: Colors.white.withValues(alpha: 0.9),
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        title: Text(
                          item.text,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Text(item.category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => _removeFromFavorites(item.id),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
