// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Favoris',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.pink.withOpacity(0.2),
                          AppTheme.accent.withOpacity(0.1)
                        ],
                      ),
                    ),
                    child: const Icon(Icons.favorite_rounded,
                        size: 48, color: AppTheme.pink),
                  ).animate().scale(curve: Curves.elasticOut, duration: 800.ms),
                  const SizedBox(height: 24),
                  const Text(
                    'Aucun favori pour l\'instant',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 8),
                  const Text(
                    'Appuie sur ❤️ lors d\'une lecture\npour ajouter une chanson ici',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        height: 1.5),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
