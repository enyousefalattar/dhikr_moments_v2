import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/azkar_repository.dart';
import '../../../core/services/time_service.dart';
import '../../../core/theme/app_theme.dart';
import '../models/azkar_item.dart';
import '../../events/presentation/events_screen.dart';

class AdhkarListScreen extends StatefulWidget {
  const AdhkarListScreen({super.key});

  @override
  State<AdhkarListScreen> createState() => _AdhkarListScreenState();
}

class _AdhkarListScreenState extends State<AdhkarListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tasbihCounter = 0;
  bool _isMorning = true;
  bool _isDarkMode = false;
  final AzkarRepository _repository = AzkarRepository();
  List<AzkarItem> _allAzkar = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _isMorning = TimeService.isMorning();
    // Set initial tab based on time
    _tabController.index = _isMorning ? 0 : 1;
    _loadData();
    _loadState();
  }

  Future<void> _loadState() async {
    final counter = await StorageService.getCounter();
    final dark = await StorageService.isDarkMode();
    setState(() {
      _tasbihCounter = counter;
      _isDarkMode = dark;
    });
  }

  Future<void> _loadData() async {
    final data = await _repository.loadAzkar();
    setState(() {
      _allAzkar = data;
      _isLoading = false;
    });
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _tasbihCounter++;
    });
    await StorageService.saveCounter(_tasbihCounter);
  }

  @override
  Widget build(BuildContext context) {
    final themeSource = _isDarkMode 
        ? (_isMorning ? AppTheme.darkMorningTheme : AppTheme.darkEveningTheme)
        : (_isMorning ? AppTheme.morningTheme : AppTheme.eveningTheme);
    
    final gradientColors = themeSource['gradientColors'] as List<Color>;
    final primaryColor = themeSource['primaryColor'] as Color;
    
    final event = TimeService.getTodaysEvent();

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
          title: Text(
            TimeService.getCurrentHijriDate(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              _buildSmartTab("الصباح", _isMorning),
              _buildSmartTab("المساء", !_isMorning),
              _buildSmartTab(event?.name ?? "المناسبات", false),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildCounterSection(primaryColor),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDhikrList('أذكار الصباح'),
                    _buildDhikrList('أذكار المساء'),
                    const EventsScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmartTab(String label, bool isPriority) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(
          fontSize: isPriority ? 16 : 12,
          fontWeight: isPriority ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildCounterSection(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.white.withValues(alpha: _isDarkMode ? 0.1 : 0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("عداد التسبيح", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text(
                    "$_tasbihCounter",
                    style: TextStyle(
                      fontSize: 42, 
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black87
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _incrementCounter,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDhikrList(String category) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    
    final filtered = _allAzkar.where((item) => item.category.contains(category)).toList();
    
    if (filtered.isEmpty) {
      return const Center(child: Text("لا توجد بيانات", style: TextStyle(color: Colors.white70)));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return Card(
          color: Colors.white.withValues(alpha: _isDarkMode ? 0.1 : 0.9),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            title: Text(
              item.text,
              style: TextStyle(
                fontSize: 16, 
                color: _isDarkMode ? Colors.white : Colors.black87
              ),
              textAlign: TextAlign.right,
            ),
            subtitle: item.count != null 
              ? Text("التكرار: ${item.count}", textAlign: TextAlign.left)
              : null,
          ),
        );
      },
    );
  }
}
