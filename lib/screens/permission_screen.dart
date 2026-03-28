// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    setState(() => _isRequesting = true);
    final provider = context.read<MusicProvider>();
    final granted = await provider.requestPermission();

    if (granted) {
      await provider.loadSongs();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => const HomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeOutCubic)),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    } else {
      setState(() => _isRequesting = false);
      _showDeniedDialog();
    }
  }

  void _showDeniedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Permission refusée',
          style: TextStyle(
              color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Aura a besoin d\'accéder à tes fichiers audio pour lire ta musique. Active la permission dans les Paramètres.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _requestPermission();
            },
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: size.height * 0.1,
            left: size.width * 0.5 - 150,
            child: AnimatedBuilder(
              animation: _iconController,
              builder: (_, __) => Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accent
                          .withOpacity(0.15 + 0.1 * _iconController.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  // Animated music folder icon
                  AnimatedBuilder(
                    animation: _iconController,
                    builder: (_, __) => Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [AppTheme.accent, AppTheme.cyan],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accent
                                .withOpacity(0.3 + 0.2 * _iconController.value),
                            blurRadius: 40 + 20 * _iconController.value,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.folder_open_rounded,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().scale(
                      begin: const Offset(0.5, 0.5),
                      curve: Curves.elasticOut,
                      duration: 1000.ms),

                  const SizedBox(height: 48),

                  const Text(
                    'Accès à ta\nMusique',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.1,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 20),

                  const Text(
                    'Aura a besoin d\'accéder à tes fichiers audio pour découvrir et lire toute ta musique locale.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ).animate().fadeIn(delay: 500.ms, duration: 600.ms),

                  const SizedBox(height: 48),

                  // Features list
                  ..._buildFeatureItems(),

                  const Spacer(),

                  // CTA Button
                  _isRequesting
                      ? Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [AppTheme.accent, AppTheme.cyan],
                            ),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: _requestPermission,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [AppTheme.accent, AppTheme.cyan],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accent.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.music_note_rounded,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Autoriser l\'accès',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: _requestPermission,
                    child: const Text(
                      'Continuer sans accès',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureItems() {
    final items = [
      (
        Icons.library_music_rounded,
        'Toute ta bibliothèque',
        'Accède à tous tes fichiers MP3'
      ),
      (Icons.offline_bolt_rounded, 'Hors ligne', 'Aucune connexion requise'),
      (Icons.security_rounded, 'Privé', 'Aucune donnée envoyée'),
    ];

    return items.asMap().entries.map((e) {
      final i = e.key;
      final item = e.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppTheme.accent.withOpacity(0.15),
              ),
              child: Icon(item.$1, color: AppTheme.accent, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.$2,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                Text(item.$3,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13)),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(
              delay: Duration(milliseconds: 700 + i * 150), duration: 500.ms)
          .slideX(begin: -0.2, end: 0);
    }).toList();
  }
}
