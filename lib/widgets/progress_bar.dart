// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';

class MusicProgressBar extends StatelessWidget {
  const MusicProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MusicProvider>();
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const _GlowThumb(),
            overlayShape: SliderComponentShape.noOverlay,
            activeTrackColor: AppTheme.accent,
            inactiveTrackColor: AppTheme.divider,
            thumbColor: Colors.white,
          ),
          child: Slider(
            value: provider.progress.clamp(0.0, 1.0),
            onChanged: (value) => provider.seekTo(value),
            min: 0,
            max: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(provider.formatDuration(provider.position),
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12)),
              Text(provider.formatDuration(provider.duration),
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class _GlowThumb extends SliderComponentShape {
  const _GlowThumb();
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(20, 20);
  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final canvas = context.canvas;
    canvas.drawCircle(
        center,
        14,
        Paint()
          ..color = AppTheme.accent.withOpacity(0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10));
    canvas.drawCircle(
        center,
        10,
        Paint()
          ..shader =
              const LinearGradient(colors: [AppTheme.accent, AppTheme.cyan])
                  .createShader(Rect.fromCircle(center: center, radius: 12)));
    canvas.drawCircle(center, 5, Paint()..color = Colors.white);
  }
}
