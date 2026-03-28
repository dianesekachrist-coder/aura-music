// ignore_for_file: prefer_const_declarations, deprecated_member_use, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'permission_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _particleController;

  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Generate particles
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(random: _random));
    }

    // Navigate after splash
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => const PermissionScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background gradient orbs
          _buildBackgroundOrbs(size),

          // Animated particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                size: size,
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                ),
              );
            },
          ),

          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo ring
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _rotateController,
                    _pulseController,
                  ]),
                  builder: (context, _) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow ring
                        Transform.rotate(
                          angle: _rotateController.value * 2 * pi,
                          child: Container(
                            width: 140 + 10 * _pulseController.value,
                            height: 140 + 10 * _pulseController.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: [
                                  AppTheme.accent,
                                  AppTheme.cyan,
                                  AppTheme.pink,
                                  AppTheme.accent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Inner dark circle
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.background,
                          ),
                        ),

                        // Logo icon
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppTheme.accent, AppTheme.cyan],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accent.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.music_note_rounded,
                            size: 44,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 40),

                // App name
                const Text(
                  'AURA',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    letterSpacing: 14,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 8),

                const Text(
                  'MUSIC',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                    letterSpacing: 8,
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 800.ms),

                const SizedBox(height: 60),

                // Wave animation
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, _) {
                    return SizedBox(
                      width: 60,
                      height: 24,
                      child: CustomPaint(
                        painter: _WavePainter(progress: _waveController.value),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom tagline
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: const Text(
              'Ton univers sonore',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 1000.ms, duration: 1000.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundOrbs(Size size) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300 + 20 * _pulseController.value,
                height: 300 + 20 * _pulseController.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accent.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              right: -80,
              child: Container(
                width: 250 + 20 * _pulseController.value,
                height: 250 + 20 * _pulseController.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.cyan.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Particle system
class _Particle {
  late double x, y, size, speed, opacity, angle;

  _Particle({required Random random}) {
    reset(random);
    y = random.nextDouble(); // start anywhere
  }

  void reset(Random random) {
    x = random.nextDouble();
    y = 1.0;
    size = random.nextDouble() * 3 + 1;
    speed = random.nextDouble() * 0.003 + 0.001;
    opacity = random.nextDouble() * 0.6 + 0.1;
    angle = random.nextDouble() * 0.4 - 0.2;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = AppTheme.accent.withOpacity(p.opacity * 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      final dy = p.speed * 6 * progress;
      final currentY = (p.y - dy) % 1.0;

      canvas.drawCircle(
        Offset(p.x * size.width, currentY * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

class _WavePainter extends CustomPainter {
  final double progress;
  _WavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final bars = 5;
    final barWidth = size.width / (bars * 2 - 1);

    for (int i = 0; i < bars; i++) {
      final phase = (i / bars) + progress;
      final height = (sin(phase * 2 * pi) * 0.5 + 0.5) * size.height * 0.8 +
          size.height * 0.2;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          i * barWidth * 2,
          (size.height - height) / 2,
          barWidth,
          height,
        ),
        const Radius.circular(4),
      );

      final paint = Paint()
        ..shader = const LinearGradient(
          colors: [AppTheme.accent, AppTheme.cyan],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, barWidth, size.height));

      canvas.drawRRect(rect, paint);
    }
  }

  double sin(double x) => (x - x.floor()) < 0.5
      ? 4 * (x - x.floor()) * (0.5 - (x - x.floor()))
      : -4 * (x - x.floor() - 0.5) * (1 - (x - x.floor()));

  @override
  bool shouldRepaint(_WavePainter old) => true;
}
