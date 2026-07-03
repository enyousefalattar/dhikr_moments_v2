import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/last_activity_service.dart';
import '../../core/services/progress_service.dart';
import 'data/dua_data.dart';
import 'models/dua_model.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  final List<Dua> _duas = staticDuaList;

  void _onDuaOpened(Dua dua) {
    LastActivityService().updateDua(dua.title);
    ProgressService().incrementDuas();
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم النسخ إلى الحافظة"),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F5),
        appBar: AppBar(
          title: const Text(
            "الأدعية",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Color(0xFF1B5E20),
            indicatorColor: Color(0xFF1B5E20),
            tabs: [
              Tab(text: "الصباح"),
              Tab(text: "المساء"),
              Tab(text: "عامة"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DuaList(
              items: _duas.where((d) => d.category == DuaCategory.morning).toList(),
              onCopy: (text) => _copyToClipboard(context, text),
              onOpened: _onDuaOpened,
            ),
            _DuaList(
              items: _duas.where((d) => d.category == DuaCategory.evening).toList(),
              onCopy: (text) => _copyToClipboard(context, text),
              onOpened: _onDuaOpened,
            ),
            _DuaList(
              items: _duas.where((d) => d.category == DuaCategory.general).toList(),
              onCopy: (text) => _copyToClipboard(context, text),
              onOpened: _onDuaOpened,
            ),
          ],
        ),
      ),
    );
  }
}

class _DuaList extends StatelessWidget {
  final List<Dua> items;
  final Function(String) onCopy;
  final Function(Dua)? onOpened;

  const _DuaList({
    required this.items,
    required this.onCopy,
    this.onOpened,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final dua = items[index];
        return _DuaCard(
          dua: dua,
          onCopy: () => onCopy(dua.text),
          onOpened: onOpened != null ? () => onOpened!(dua) : null,
        );
      },
    );
  }
}

class _DuaCard extends StatelessWidget {
  final Dua dua;
  final VoidCallback? onOpened;
  final VoidCallback onCopy;

  const _DuaCard({
    required this.dua,
    required this.onCopy,
    this.onOpened,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: InkWell(
        onTap: onOpened,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                dua.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ListenableBuilder(
                    listenable: FavoritesService(),
                    builder: (context, _) {
                      final isFav = FavoritesService().isFavorite(dua.id, 'dua');
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => FavoritesService().toggleFavorite(dua.id, 'dua'),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy, color: Color(0xFF1B5E20)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.share, color: Color(0xFF1B5E20)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
