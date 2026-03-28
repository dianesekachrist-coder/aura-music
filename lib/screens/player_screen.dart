// ignore_for_file: prefer_const_constructors, deprecated_member_use, unused_import

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/progress_bar.dart' show MusicProgressBar;
import '../widgets/control_button.dart' show ControlButton;

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    final provider = context.read<MusicProvider>();
    if (provider.isPlaying) _rotateController.repeat();
    provider.addListener(_onProviderChange);
  }

  void _onProviderChange() {
    if (!mounted) return;
    final provider = context.read<MusicProvider>();
    if (provider.isPlaying && !_rotateController.isAnimating) {
      _rotateController.repeat();
    } else if (!provider.isPlaying && _rotateController.isAnimating) {
      _rotateController.stop();
    }
  }

  @override
  void dispose() {
    final provider = context.read<MusicProvider>();
    provider.removeListener(_onProviderChange);
    _rotateController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    final song = provider.currentSong;
    if (song == null) return const SizedBox();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          _buildBgFx(),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                const SizedBox(height: 20),
                _buildAlbumArt(song),
                const SizedBox(height: 32),
                _buildSongInfo(song, provider),
                const SizedBox(height: 28),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: MusicProgressBar(),
                ),
                const SizedBox(height: 32),
                _buildControls(provider),
                const SizedBox(height: 32),
                _buildBottomActions(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBgFx() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) => Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 280 + 20 * _pulseController.value,
              height: 280 + 20 * _pulseController.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.accent
                      .withOpacity(0.2 + 0.1 * _pulseController.value),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppTheme.cyan.withOpacity(0.15),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppTheme.textPrimary, size: 28),
          ),
          const Text(
            'EN COURS DE LECTURE',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(Icons.more_horiz_rounded,
              color: AppTheme.textPrimary, size: 24),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(dynamic song) {
    return AnimatedBuilder(
      animation: _rotateController,
      builder: (_, child) => Transform.rotate(
        angle: _rotateController.value * 2 * math.pi,
        child: child,
      ),
      child: Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: AppTheme.accent.withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 8),
            BoxShadow(
                color: AppTheme.cyan.withOpacity(0.2),
                blurRadius: 60,
                spreadRadius: 15),
          ],
        ),
        child: ClipOval(
          child: QueryArtworkWidget(
            id: song.id,
            type: ArtworkType.AUDIO,
            artworkFit: BoxFit.cover,
            artworkBorder: BorderRadius.zero,
            nullArtworkWidget: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accent, AppTheme.cyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(Icons.music_note_rounded,
                    size: 80, color: Colors.white54),
              ),
            ),
          ),
        ),
      ),
    ).animate().scale(
        begin: const Offset(0.6, 0.6),
        curve: Curves.elasticOut,
        duration: 800.ms);
  }

  Widget _buildSongInfo(dynamic song, MusicProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  song.artist ?? 'Artiste inconnu',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.favorite_border_rounded,
                color: AppTheme.pink, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(MusicProvider provider) {
    // Icône repeat selon le mode
    IconData repeatIcon;
    Color repeatColor;
    if (provider.repeatMode == SongRepeatMode.one) {
      repeatIcon = Icons.repeat_one_rounded;
      repeatColor = AppTheme.accent;
    } else if (provider.repeatMode == SongRepeatMode.all) {
      repeatIcon = Icons.repeat_rounded;
      repeatColor = AppTheme.accent;
    } else {
      repeatIcon = Icons.repeat_rounded;
      repeatColor = AppTheme.textSecondary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Shuffle
          GestureDetector(
            onTap: provider.toggleShuffle,
            child: Icon(
              Icons.shuffle_rounded,
              size: 22,
              color: provider.isShuffled
                  ? AppTheme.accent
                  : AppTheme.textSecondary,
            ),
          ),

          // Previous
          GestureDetector(
            onTap: provider.playPrevious,
            child: const Icon(Icons.skip_previous_rounded,
                color: AppTheme.textPrimary, size: 32),
          ),

          // Play/Pause principal
          GestureDetector(
            onTap: provider.togglePlay,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.accent, AppTheme.cyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent
                        .withOpacity(provider.isPlaying ? 0.6 : 0.3),
                    blurRadius: provider.isPlaying ? 30 : 15,
                    spreadRadius: provider.isPlaying ? 5 : 2,
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  provider.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  key: ValueKey(provider.isPlaying),
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Next
          GestureDetector(
            onTap: provider.playNext,
            child: const Icon(Icons.skip_next_rounded,
                color: AppTheme.textPrimary, size: 32),
          ),

          // Repeat
          GestureDetector(
            onTap: provider.toggleRepeat,
            child: Icon(repeatIcon, size: 22, color: repeatColor),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _BottomAction(icon: Icons.queue_music_rounded, label: 'File'),
          _BottomAction(icon: Icons.share_rounded, label: 'Partager'),
          _BottomAction(icon: Icons.equalizer_rounded, label: 'Égaliseur'),
          _BottomAction(icon: Icons.timer_rounded, label: 'Minuterie'),
        ],
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BottomAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppTheme.card,
              border: Border.all(color: AppTheme.divider),
            ),
            child: Icon(icon, color: AppTheme.textSecondary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label,
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
