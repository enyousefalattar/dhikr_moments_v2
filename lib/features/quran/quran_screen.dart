import 'package:flutter/material.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/last_activity_service.dart';
import 'data/surah_data.dart';
import 'models/surah_model.dart';
import 'presentation/surah_detail/surah_detail_screen.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      appBar: AppBar(
        title: const Text("القرآن الكريم", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: staticSurahList.length,
        itemBuilder: (context, index) {
          final surah = staticSurahList[index];
          return _SurahCard(
            surah: surah,
            onTap: () {
              LastActivityService().updateSurah(surah.nameArabic);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurahDetailScreen(surah: surah),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const _SurahCard({
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20).withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "${surah.id}",
              style: const TextStyle(
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          surah.nameArabic,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text("${surah.nameEnglish} • ${surah.versesCount} آية"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListenableBuilder(
              listenable: FavoritesService(),
              builder: (context, _) {
                final isFavorite = FavoritesService().isFavorite(surah.id.toString(), 'quran');
                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                  onPressed: () => FavoritesService().toggleFavorite(surah.id.toString(), 'quran'),
                );
              },
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
