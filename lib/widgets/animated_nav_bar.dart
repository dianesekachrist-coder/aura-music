// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';

class AnimatedNavBar extends StatefulWidget {
  const AnimatedNavBar({super.key});

  @override
  State<AnimatedNavBar> createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<_NavItem> _items = const [
    _NavItem(icon: Icons.library_music_rounded, label: 'Bibliothèque'),
    _NavItem(icon: Icons.search_rounded, label: 'Recherche'),
    _NavItem(icon: Icons.favorite_rounded, label: 'Favoris'),
    _NavItem(icon: Icons.settings_rounded, label: 'Paramètres'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: const Border(
          top: BorderSide(color: AppTheme.divider, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _items.asMap().entries.map((e) {
            final index = e.key;
            final item = e.value;
            final isSelected = provider.currentNavIndex == index;

            return GestureDetector(
              onTap: () {
                provider.setNavIndex(index);
              },
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isSelected
                      ? AppTheme.accent.withOpacity(0.15)
                      : Colors.transparent,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated icon
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      transform: Matrix4.identity()
                        ..scale(isSelected ? 1.15 : 1.0),
                      child: ShaderMask(
                        shaderCallback: (bounds) => isSelected
                            ? const LinearGradient(
                                colors: [AppTheme.accent, AppTheme.cyan],
                              ).createShader(bounds)
                            : const LinearGradient(
                                colors: [
                                  AppTheme.textSecondary,
                                  AppTheme.textSecondary
                                ],
                              ).createShader(bounds),
                        child: Icon(
                          item.icon,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Label
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.accent
                            : AppTheme.textSecondary,
                      ),
                      child: Text(item.label),
                    ),

                    // Active dot indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isSelected ? 4 : 0,
                      height: isSelected ? 4 : 0,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppTheme.accent, AppTheme.cyan],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
