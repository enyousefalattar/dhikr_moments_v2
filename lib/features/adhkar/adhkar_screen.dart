import 'package:flutter/material.dart';
import '../../core/services/favorites_service.dart';
import '../../core/services/last_activity_service.dart';
import '../../core/services/progress_service.dart';
import 'data/adhkar_data.dart';
import 'models/adhkar_model.dart';

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  // Use a local copy of the list to manage state
  late List<Adhkar> _adhkarList;

  @override
  void initState() {
    super.initState();
    _adhkarList = staticAdhkarList;
  }

  void _onItemTapped(Adhkar adhk) {
    setState(() {
      final wasCompleted = adhk.isCompleted;
      adhk.decrement();
      
      LastActivityService().updateAdhkar(adhk.title);
      
      if (!wasCompleted && adhk.isCompleted) {
        ProgressService().incrementAdhkar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F5),
        appBar: AppBar(
          title: const Text(
            "الأذكار",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Color(0xFF1B5E20), // Subtle green accent (#1B5E20)
            indicatorColor: Color(0xFF1B5E20),
            tabs: [
              Tab(text: "أذكار الصباح"),
              Tab(text: "أذكار المساء"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AdhkarList(
              items: _adhkarList
                  .where((a) => a.category == AdhkarCategory.morning)
                  .toList(),
              onTap: _onItemTapped,
            ),
            _AdhkarList(
              items: _adhkarList
                  .where((a) => a.category == AdhkarCategory.evening)
                  .toList(),
              onTap: _onItemTapped,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdhkarList extends StatelessWidget {
  final List<Adhkar> items;
  final Function(Adhkar) onTap;

  const _AdhkarList({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final adhk = items[index];
        return _AdhkarCard(adhk: adhk, onTap: () => onTap(adhk));
      },
    );
  }
}

class _AdhkarCard extends StatelessWidget {
  final Adhkar adhk;
  final VoidCallback onTap;

  const _AdhkarCard({required this.adhk, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: adhk.isCompleted ? 0.6 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: adhk.isCompleted ? 0 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: adhk.isCompleted ? Colors.green.withValues(alpha: 0.05) : Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  adhk.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.6,
                    decoration: adhk.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: adhk.isCompleted ? Colors.grey : Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListenableBuilder(
                      listenable: FavoritesService(),
                      builder: (context, _) {
                        final isFav = FavoritesService().isFavorite(adhk.id, 'adhkar');
                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => FavoritesService().toggleFavorite(adhk.id, 'adhkar'),
                        );
                      },
                    ),
                    if (adhk.isCompleted)
                      const Icon(Icons.check_circle, color: Colors.green)
                    else
                      const SizedBox(width: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: adhk.isCompleted
                            ? Colors.grey.shade200
                            : const Color(0xFF1B5E20),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "${adhk.currentCount}",
                        style: TextStyle(
                          color: adhk.isCompleted ? Colors.grey : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
