import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/song_tile.dart';
import 'player_screen.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();
  bool _focused = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recherche',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Focus(
                  onFocusChange: (v) => setState(() => _focused = v),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppTheme.card,
                      border: Border.all(
                        color: _focused ? AppTheme.accent : AppTheme.divider,
                        width: _focused ? 1.5 : 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Icons.search_rounded,
                          color: _focused
                              ? AppTheme.accent
                              : AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            onChanged: provider.search,
                            style: const TextStyle(
                                color: AppTheme.textPrimary, fontSize: 15),
                            decoration: const InputDecoration(
                              hintText: 'Titres, artistes...',
                              hintStyle: TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 15),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_controller.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: AppTheme.textSecondary, size: 20),
                            onPressed: () {
                              _controller.clear();
                              provider.search('');
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.songs.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun résultat',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 160),
                    itemCount: provider.songs.length,
                    itemBuilder: (context, index) {
                      final song = provider.songs[index];
                      return SongTile(
                        song: song,
                        index: index,
                        isPlaying: provider.currentSong?.id == song.id &&
                            provider.isPlaying,
                        isCurrent: provider.currentSong?.id == song.id,
                        onTap: () {
                          provider.playSong(song, index);
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, animation, __) =>
                                  const PlayerScreen(),
                              transitionsBuilder: (_, animation, __, child) =>
                                  SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic)),
                                child: child,
                              ),
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
