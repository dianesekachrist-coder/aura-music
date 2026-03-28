// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../theme/app_theme.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final int index;
  final bool isPlaying;
  final bool isCurrent;
  final VoidCallback onTap;

  const SongTile({
    super.key,
    required this.song,
    required this.index,
    required this.isPlaying,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isCurrent ? AppTheme.accent.withOpacity(0.12) : AppTheme.card,
          border: Border.all(
            color: isCurrent
                ? AppTheme.accent.withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            // Artwork / Number
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: isCurrent
                    ? const LinearGradient(
                        colors: [AppTheme.accent, AppTheme.cyan])
                    : null,
                color: isCurrent ? null : AppTheme.surface,
              ),
              child: isCurrent && isPlaying
                  ? const _PlayingAnimation()
                  : QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(12),
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: Center(
                        child: Icon(
                          Icons.music_note_rounded,
                          color:
                              isCurrent ? Colors.white : AppTheme.textSecondary,
                          size: 24,
                        ),
                      ),
                    ),
            ),

            const SizedBox(width: 14),

            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: TextStyle(
                      color: isCurrent ? AppTheme.accent : AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.artist ?? 'Artiste inconnu',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Duration
            if (song.duration != null)
              Text(
                _formatDuration(Duration(milliseconds: song.duration!)),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),

            const SizedBox(width: 8),

            // More options
            Icon(
              Icons.more_vert_rounded,
              color: AppTheme.textSecondary,
              size: 18,
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: index * 30), duration: 400.ms)
          .slideX(begin: 0.1, end: 0),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _PlayingAnimation extends StatefulWidget {
  const _PlayingAnimation();

  @override
  State<_PlayingAnimation> createState() => _PlayingAnimationState();
}

class _PlayingAnimationState extends State<_PlayingAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + i * 100),
      )..repeat(reverse: true),
    );

    _animations = _controllers.map((c) {
      return Tween<double>(begin: 0.2, end: 1.0).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _animations[i],
            builder: (_, __) => Container(
              width: 4,
              height: 22 * _animations[i].value,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white,
              ),
            ),
          );
        }),
      ),
    );
  }
}
