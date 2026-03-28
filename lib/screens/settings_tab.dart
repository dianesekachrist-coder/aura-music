// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Paramètres',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 28),

            // 🎧 Tip banner
            _buildTipBanner(),

            const SizedBox(height: 28),

            _buildSection(
              'Audio',
              [
                _SettingItem(
                    icon: Icons.equalizer_rounded,
                    label: 'Égaliseur',
                    trailing: const _GradientChip('Bientôt')),
                _SettingItem(
                    icon: Icons.volume_up_rounded,
                    label: 'Normalisation du volume'),
                _SettingItem(
                    icon: Icons.timer_rounded, label: 'Minuterie de sommeil'),
              ],
            ),

            const SizedBox(height: 20),

            _buildSection(
              'Bibliothèque',
              [
                _SettingItem(
                    icon: Icons.refresh_rounded,
                    label: 'Rafraîchir la bibliothèque'),
                _SettingItem(
                    icon: Icons.folder_rounded, label: 'Dossiers analysés'),
                _SettingItem(icon: Icons.sort_rounded, label: 'Ordre de tri'),
              ],
            ),

            const SizedBox(height: 20),

            _buildSection(
              'Apparence',
              [
                _SettingItem(
                    icon: Icons.palette_rounded, label: 'Thème de couleur'),
                _SettingItem(
                    icon: Icons.animation_rounded, label: 'Animations'),
              ],
            ),

            const SizedBox(height: 20),

            _buildSection(
              'À propos',
              [
                _SettingItem(
                    icon: Icons.info_rounded,
                    label: 'Version 1.0.0',
                    interactive: false),
                _SettingItem(icon: Icons.star_rounded, label: 'Noter l\'app'),
                _SettingItem(
                    icon: Icons.mail_rounded,
                    label: 'Contacter le développeur'),
              ],
            ),

            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }

  Widget _buildTipBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0E35), Color(0xFF0E1E35)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.accent, AppTheme.cyan],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withOpacity(0.4),
                  blurRadius: 15,
                ),
              ],
            ),
            child: const Text(
              '🎧',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Conseil du jour',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Utilise tes écouteurs pour une meilleure expérience !',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Les basses, les détails et la scène sonore sont bien plus riches avec des écouteurs ou un casque de qualité.',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppTheme.card,
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              return Column(
                children: [
                  item,
                  if (i < items.length - 1)
                    const Divider(
                      color: AppTheme.divider,
                      height: 1,
                      indent: 56,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final bool interactive;

  const _SettingItem({
    required this.icon,
    required this.label,
    this.trailing,
    this.interactive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: interactive ? () {} : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.accent.withOpacity(0.12),
                ),
                child: Icon(icon, color: AppTheme.accent, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                  ),
                ),
              ),
              trailing ??
                  (interactive
                      ? const Icon(
                          Icons.chevron_right_rounded,
                          color: AppTheme.textSecondary,
                          size: 20,
                        )
                      : const SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientChip extends StatelessWidget {
  final String label;
  const _GradientChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [AppTheme.accent, AppTheme.cyan],
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
