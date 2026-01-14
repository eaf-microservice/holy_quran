import 'dart:math' as math;

import 'package:eaf/utils/quran_surahs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../widgets/about.dart' show AboutMe;
import 'settings_screen.dart';

class PrefsKeys {
  static const lastPage = 'last_page';
  static const bookmarks = 'bookmarks'; // List<int>
  static const nightMode = 'night_mode';
  static const tajweed = 'tajweed_enabled';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _lastPage;
  Set<int> _bookmarks = {};
  bool _night = false;
  bool _tajweed = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    WakelockPlus.enable(); // keep screen on
  }

  @override
  void dispose() {
    WakelockPlus.disable(); // allow screen to sleep when app is closed
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _lastPage = sp.getInt(PrefsKeys.lastPage);
      _bookmarks = (sp.getStringList(PrefsKeys.bookmarks) ?? [])
          .map((e) => int.tryParse(e) ?? -1)
          .where((e) => e > 0)
          .toSet();
      _night = sp.getBool(PrefsKeys.nightMode) ?? false;
      _tajweed = sp.getBool(PrefsKeys.tajweed) ?? false;
    });
  }

  Future<void> _savePref(String key, dynamic value) async {
    final sp = await SharedPreferences.getInstance();
    if (value is bool) await sp.setBool(key, value);
    if (value is int) await sp.setInt(key, value);
    if (value is List<String>) await sp.setStringList(key, value);
  }

  List<SurahInfo> get _filteredSurahs {
    if (_query.trim().isEmpty) return kSurahs;
    final q = _query.toLowerCase();
    return kSurahs.where((s) {
      return s.arabic.contains(_query) ||
          s.english.toLowerCase().contains(q) ||
          s.index.toString() == q;
    }).toList();
  }

  void _openReader({int? initialPage}) async {
    // navigate and await for possible updates
    final result = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          initialPage: initialPage ?? _lastPage ?? 1,
          night: _night,
          tajweed: _tajweed,
          bookmarks: _bookmarks,
        ),
      ),
    );
    if (result != null) {
      // result is last read page
      setState(() => _lastPage = result);
      _savePref(PrefsKeys.lastPage, result);
    }
    // reload prefs in case bookmarks/toggles changed inside reader
    _loadPrefs();
  }

  ThemeData _theme(bool dark) {
    final base = dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: Colors.teal,
        secondary: Colors.tealAccent,
      ),
      appBarTheme: base.appBarTheme.copyWith(centerTitle: true, elevation: 0),
      scaffoldBackgroundColor: dark
          ? const Color(0xFF0F1115)
          : const Color(0xFFF8F8F8),
      listTileTheme: ListTileThemeData(
        iconColor: dark ? Colors.white70 : Colors.black54,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _theme(false),
      darkTheme: _theme(true),
      themeMode: _night ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Holy Quran'),
          actions: [
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () async {
                final changed = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
                await _loadPrefs();
                setState(() {});
              },
            ),
            IconButton(
              tooltip: 'About',
              icon: const Icon(Icons.info_outline),
              onPressed: () async {
                AboutMe(
                  applicationName: 'القرآن الكريم',
                  logo: Image.asset(
                    'assets/icon/icon.png',
                    width: 100,
                    height: 100,
                  ),
                  version: '1.0.1',
                  description:
                      //'Mushaf with search, bookmarks, tajweed, and night mode.',
                      'المصحف مزود بخاصية البحث، والإشارات المرجعية، والتجويد، والوضع الليلي.',
                ).showCustomAbout(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search surah (Arabic/English or number)',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                ],
              ),
            ),
            if (_lastPage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.play_circle_outline),
                    title: const Text('Continue reading'),
                    subtitle: Text('Page $_lastPage'),
                    onTap: () => _openReader(initialPage: _lastPage),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_added_outlined),
                      onPressed: () => _openReader(initialPage: _lastPage),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Surahs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredSurahs.length,
                itemBuilder: (ctx, i) {
                  final s = _filteredSurahs[i];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.15),
                        child: Text(
                          '${s.index}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(s.arabic),
                      subtitle: Text(
                        '${s.english} • p${s.startPage}-${s.endPage}',
                      ),
                      trailing: IconButton(
                        tooltip: 'Open',
                        icon: const Icon(Icons.menu_book_outlined),
                        onPressed: () => _openReader(initialPage: s.startPage),
                      ),
                      onTap: () => _openReader(initialPage: s.startPage),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReaderScreen extends StatefulWidget {
  final int initialPage; // 1..604
  final bool night;
  final bool tajweed;
  final Set<int> bookmarks;

  const ReaderScreen({
    super.key,
    required this.initialPage,
    required this.night,
    required this.tajweed,
    required this.bookmarks,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen>
    with SingleTickerProviderStateMixin {
  static const int totalPages = 604; // Madani mushaf
  late final PageController _pageController;
  late int _currentPage;
  late bool _night;
  late bool _tajweed;
  late Set<int> _bookmarks;

  // For 3D effect we keep track of page scroll
  // ignore: unused_field
  double _pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(1, totalPages);
    _pageController = PageController(
      initialPage: totalPages - _currentPage,
    ); // RTL mapping
    _night = widget.night;
    _tajweed = widget.tajweed;
    _bookmarks = {...widget.bookmarks};

    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _persistLastPage() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(PrefsKeys.lastPage, _currentPage);
  }

  Future<void> _persistBookmarks() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(
      PrefsKeys.bookmarks,
      _bookmarks.map((e) => e.toString()).toList(),
    );
  }

  String _assetForPage(int page) {
    // assets/images/quran/###.png or tajweed folder if enabled assets/images/tajweed/###.gif
    final idx = page.toString().padLeft(3, '0');
    final base = 'assets/images${_tajweed ? '/tajweed' : '/quran'}';
    if (_tajweed) {
      return '$base/$idx.gif';
    } else {
      return '$base/$idx.png';
    }
  }

  // Map PageView index (0..totalPages-1) to actual page number RTL
  int _pageForIndex(int index) => totalPages - index;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = _pageForIndex(index);
    });
    _persistLastPage();
  }

  void _toggleBookmark() {
    setState(() {
      if (_bookmarks.contains(_currentPage)) {
        _bookmarks.remove(_currentPage);
      } else {
        _bookmarks.add(_currentPage);
      }
    });
    _persistBookmarks();
  }

  void _jumpToPageDialog() async {
    final controller = TextEditingController(text: _currentPage.toString());
    final page = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Go to page'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: '1..604'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final v = int.tryParse(controller.text);
              if (v == null) {
                Navigator.pop(ctx);
                return;
              }
              Navigator.pop(ctx, v.clamp(1, totalPages));
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
    if (page != null) {
      setState(() => _currentPage = page);
      _pageController.jumpToPage(totalPages - _currentPage);
      _persistLastPage();
    }
  }

  // void _toggleTajweed() async {
  //   setState(() => _tajweed = !_tajweed);
  //   final sp = await SharedPreferences.getInstance();
  //   await sp.setBool(PrefsKeys.tajweed, _tajweed);
  // }

  // void _toggleNight() async {
  //   setState(() => _night = !_night);
  //   final sp = await SharedPreferences.getInstance();
  //   await sp.setBool(PrefsKeys.nightMode, _night);
  // }

  @override
  Widget build(BuildContext context) {
    final bg = _night ? const Color(0xFF0F1115) : const Color(0xFFF2EFEA);
    final fg = _night ? Colors.white : Colors.black87;

    return Theme(
      data: _night
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          foregroundColor: fg,
          title: Text('Page $_currentPage / $totalPages'),
          actions: [
            IconButton(
              tooltip: 'Bookmarks list',
              icon: const Icon(Icons.bookmarks_outlined),
              onPressed: () async {
                final selected = await showModalBottomSheet<int>(
                  context: context,
                  showDragHandle: true,
                  builder: (ctx) {
                    final bms = _bookmarks.toList()..sort();
                    if (bms.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(child: Text('No bookmarks yet')),
                      );
                    }
                    return ListView.builder(
                      itemCount: bms.length,
                      itemBuilder: (c, i) => ListTile(
                        leading: const Icon(Icons.bookmark_outline),
                        title: Text('Page ${bms[i]}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              _bookmarks.remove(bms[i]);
                            });
                            _persistBookmarks();
                            if (Navigator.canPop(c)) Navigator.pop(c);
                          },
                        ),
                        onTap: () => Navigator.pop(ctx, bms[i]),
                      ),
                    );
                  },
                );
                if (selected != null) {
                  setState(() => _currentPage = selected);
                  _pageController.jumpToPage(totalPages - _currentPage);
                  _persistLastPage();
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Chip(
                avatar: Icon(
                  _tajweed ? Icons.color_lens : Icons.menu_book_outlined,
                  size: 18,
                ),
                label: Text(
                  '${_tajweed ? 'Tajweed' : 'Normal'} • ${_night ? 'Night' : 'Light'}',
                ),
              ),
            ),
          ],
        ),
        body: Directionality(
          textDirection: TextDirection.rtl, // enforce RTL scroll
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) => false,
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalPages,
              onPageChanged: _onPageChanged,
              scrollDirection: Axis.horizontal,
              // physics remain default; RTL achieved by reversing index mapping
              itemBuilder: (ctx, index) {
                final page = _pageForIndex(index);
                final rotation = _computeYRotation(index);
                return Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // perspective
                      ..rotateY(rotation),
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 3.0,
                      child: AspectRatio(
                        aspectRatio:
                            595 / 842, // approximate portrait page ratio
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: bg,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  _night ? 0.6 : 0.2,
                                ),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _assetForPage(page),
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) {
                                return Center(
                                  child: Text(
                                    'Missing page image: ${_assetForPage(page)}',
                                    style: TextStyle(color: fg),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context, bg, fg),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _toggleBookmark,
          label: Text(
            _bookmarks.contains(_currentPage) ? 'Bookmarked' : 'Bookmark',
          ),
          icon: Icon(
            _bookmarks.contains(_currentPage)
                ? Icons.bookmark_added
                : Icons.bookmark_add_outlined,
          ),
        ),
      ),
    );
  }

  double _computeYRotation(int index) {
    // 3D effect around the current scroll position
    final page = _pageController.hasClients
        ? (_pageController.page ?? 0.0)
        : _pageController.initialPage.toDouble();
    final delta = (index - page).clamp(-1.0, 1.0);
    // Rotate a small amount, flipping subtly as it transitions
    return -delta * (math.pi / 24); // ~7.5 degrees
  }

  Widget _buildBottomBar(BuildContext context, Color bg, Color fg) {
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              tooltip: 'Previous page',
              icon: const Icon(Icons.chevron_right), // RTL previous
              color: fg,
              onPressed: () {
                final target = (_currentPage + 1).clamp(1, totalPages);
                setState(() => _currentPage = target);
                _pageController.animateToPage(
                  totalPages - target,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
                _persistLastPage();
              },
            ),
            Expanded(
              child: Slider(
                value: _currentPage.toDouble(),
                min: 1,
                max: totalPages.toDouble(),
                divisions: totalPages - 1,
                onChanged: (v) {
                  setState(() => _currentPage = v.round());
                },
                onChangeEnd: (v) {
                  _pageController.jumpToPage(totalPages - _currentPage);
                  _persistLastPage();
                },
              ),
            ),
            IconButton(
              tooltip: 'Next page',
              icon: const Icon(Icons.chevron_left), // RTL next
              color: fg,
              onPressed: () {
                final target = (_currentPage - 1).clamp(1, totalPages);
                setState(() => _currentPage = target);
                _pageController.animateToPage(
                  totalPages - target,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
                _persistLastPage();
              },
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: _jumpToPageDialog,
              child: const Text('Go'),
            ),
          ],
        ),
      ),
    );
  }
}
