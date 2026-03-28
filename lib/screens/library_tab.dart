// ignore_for_file: unused_import, deprecated_member_use, duplicate_ignore, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/song_tile.dart';
import 'player_screen.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: _buildHeader(context, provider),
        ),

        // Songs list
        if (provider.isLoading)
          const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.accent,
                strokeWidth: 2,
              ),
            ),
          )
        else if (provider.songs.isEmpty)
          SliverFillRemaining(
            child: _buildEmptyState(),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = provider.songs[index];
                return SongTile(
                  song: song,
                  index: index,
                  isPlaying:
                      provider.currentSong?.id == song.id && provider.isPlaying,
                  isCurrent: provider.currentSong?.id == song.id,
                  onTap: () {
                    provider.playSong(song, index);
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, animation, __) => const PlayerScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            )),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                );
              },
              childCount: provider.songs.length,
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 160)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, MusicProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                // ignore: prefer_const_constructors
                Expanded(
                  // ignore: prefer_const_constructors
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonne écoute 🎵',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Text(
                        'Ta Bibliothèque',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.accent, AppTheme.cyan],
                    ),
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: Colors.white, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats row
            Row(
              children: [
                _StatChip(
                  icon: Icons.music_note_rounded,
                  label: '${provider.songs.length} titres',
                ),
                const SizedBox(width: 10),
                const _StatChip(
                  icon: Icons.headphones_rounded,
                  label: 'Local',
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Play all button
            if (provider.songs.isNotEmpty)
              GestureDetector(
                onTap: () {
                  if (provider.songs.isNotEmpty) {
                    provider.playSong(provider.songs[0], 0);
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, animation, __) => const PlayerScreen(),
                        transitionsBuilder: (_, animation, __, child) =>
                            SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                              parent: animation, curve: Curves.easeOutCubic)),
                          child: child,
                        ),
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [AppTheme.accent, AppTheme.cyan],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withOpacity(0.35),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 26),
                      SizedBox(width: 8),
                      Text(
                        'Tout lire',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accent.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.music_off_rounded,
              size: 48,
              color: AppTheme.accent,
            ),
          ).animate().scale(curve: Curves.elasticOut, duration: 800.ms),
          const SizedBox(height: 24),
          const Text(
            'Aucune musique trouvée',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          const Text(
            'Ajoute des fichiers audio sur\nton appareil pour commencer',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.card,
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.accent),
          const SizedBox(width: 6),
          Text(label,
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
