import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsKeys {
  static const nightMode = 'night_mode';
  static const tajweed = 'tajweed_enabled';
  static const lastPage = 'last_page';
  static const bookmarks = 'bookmarks';
}

enum ReadingMode { normal, tajweed }

enum AppTheme { light, dark }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ReadingMode _mode = ReadingMode.normal;
  AppTheme _theme = AppTheme.light;
  int? _lastPage;
  int _bookmarksCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _mode = (sp.getBool(PrefsKeys.tajweed) ?? false) ? ReadingMode.tajweed : ReadingMode.normal;
      _theme = (sp.getBool(PrefsKeys.nightMode) ?? false) ? AppTheme.dark : AppTheme.light;
      _lastPage = sp.getInt(PrefsKeys.lastPage);
      _bookmarksCount = (sp.getStringList(PrefsKeys.bookmarks) ?? const []).length;
    });
  }

  Future<void> _saveMode(ReadingMode m) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(PrefsKeys.tajweed, m == ReadingMode.tajweed);
  }

  Future<void> _saveTheme(AppTheme t) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(PrefsKeys.nightMode, t == AppTheme.dark);
  }

  Future<void> _resetLastPage() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(PrefsKeys.lastPage);
    setState(() => _lastPage = null);
  }

  Future<void> _clearBookmarks() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(PrefsKeys.bookmarks);
    setState(() => _bookmarksCount = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Reading mode', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          RadioListTile<ReadingMode>(
            title: const Text('Normal Mushaf'),
            subtitle: const Text('Standard page images (PNG)'),
            value: ReadingMode.normal,
            groupValue: _mode,
            onChanged: (v) {
              if (v == null) return;
              setState(() => _mode = v);
              _saveMode(v);
            },
          ),
          RadioListTile<ReadingMode>(
            title: const Text('Tajweed Mushaf'),
            subtitle: const Text('Color-coded tajweed pages (GIF)'),
            value: ReadingMode.tajweed,
            groupValue: _mode,
            onChanged: (v) {
              if (v == null) return;
              setState(() => _mode = v);
              _saveMode(v);
            },
          ),
          const Divider(height: 32),
          Text('Theme', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          RadioListTile<AppTheme>(
            title: const Text('Light'),
            value: AppTheme.light,
            groupValue: _theme,
            onChanged: (v) {
              if (v == null) return;
              setState(() => _theme = v);
              _saveTheme(v);
            },
          ),
          RadioListTile<AppTheme>(
            title: const Text('Night'),
            value: AppTheme.dark,
            groupValue: _theme,
            onChanged: (v) {
              if (v == null) return;
              setState(() => _theme = v);
              _saveTheme(v);
            },
          ),
          const Divider(height: 32),
          Text('Data', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: const Text('Last read page'),
            subtitle: Text(_lastPage == null ? 'Not set' : 'Page $_lastPage'),
            trailing: TextButton(
              onPressed: _lastPage == null ? null : _resetLastPage,
              child: const Text('Reset'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bookmarks_outlined),
            title: const Text('Bookmarks'),
            subtitle: Text('$_bookmarksCount saved'),
            trailing: TextButton(
              onPressed: _bookmarksCount == 0
                  ? null
                  : () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Clear all bookmarks?'),
                          content: const Text('This cannot be undone.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await _clearBookmarks();
                      }
                    },
              child: const Text('Clear'),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.check),
            label: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
