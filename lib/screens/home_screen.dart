// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/mini_player.dart';
import '../widgets/animated_nav_bar.dart';
import 'library_tab.dart';
import 'search_tab.dart';
import 'favorites_tab.dart';
import 'settings_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Widget> _tabs = const [
    LibraryTab(),
    SearchTab(),
    FavoritesTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Tab content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: _tabs[provider.currentNavIndex],
          ),

          // Mini player (floating above nav)
          if (provider.currentSong != null)
            Positioned(
              bottom: 88,
              left: 12,
              right: 12,
              child: const MiniPlayer(),
            ),
        ],
      ),
      bottomNavigationBar: const AnimatedNavBar(),
    );
  }
}
