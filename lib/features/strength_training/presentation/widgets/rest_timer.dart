import 'package:flutter/material.dart';
import 'dart:async';

import '../../../../core/theme/app_theme.dart';

/// Rest Timer Widget für Krafttraining Sessions
/// Zeigt Countdown mit zirkulärer Animation, Audio Cues und Haptic Feedback
class RestTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onComplete;
  final VoidCallback? onSkip;

  const RestTimer({
    required this.duration,
    required this.onComplete,
    this.onSkip,
  });

  @override
  State<RestTimer> createState() => _RestTimerState();
}

class _RestTimerState extends State<RestTimer> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late int _remainingSeconds;
  late AnimationController _animationController;
  bool _audioPlayedAt10 = false;
  bool _audioPlayedAt5 = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _startTimer();
    _animationController.forward();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;

        // Audio cues
        if (_remainingSeconds == 10 && !_audioPlayedAt10) {
          _audioPlayedAt10 = true;
          _playAudioCue('10 seconds remaining');
        }

        if (_remainingSeconds == 5 && !_audioPlayedAt5) {
          _audioPlayedAt5 = true;
          _playAudioCue('5 seconds');
        }

        if (_remainingSeconds <= 0) {
          _timer.cancel();
          _playAudioCue('beep'); // Short beep at completion
          _triggerHapticFeedback();
          widget.onComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final timeString = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return Column(
      children: [
        // Circular progress indicator
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceLight.withValues(alpha: 0.3),
                ),
              ),

              // Progress circle
              ScaleTransition(
                scale: Tween(begin: 1.0, end: 0.95).animate(_animationController),
                child: CustomPaint(
                  size: const Size(200, 200),
                  painter: _TimerPainter(
                    progress: _animationController.value,
                    color: _getTimerColor(),
                  ),
                ),
              ),

              // Center text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeString,
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ruhezeit',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getTimerColor() {
    if (_remainingSeconds > 10) {
      return AppColors.primary;
    } else if (_remainingSeconds > 5) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  void _playAudioCue(String cue) {
    // TODO: Integrate with AudioCueService from existing app
    // For now, this is a placeholder
    // Example: AudioCueService.play(cue);
    debugPrint('Audio cue: $cue');
  }

  void _triggerHapticFeedback() {
    // TODO: Integrate with HapticFeedbackService from existing app
    // For now, this is a placeholder
    // Example: HapticFeedbackService.heavyImpact();
    debugPrint('Haptic feedback triggered');
  }
}

/// Custom painter für circular timer
class _TimerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _TimerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background arc
    final backgroundPaint = Paint()
      ..color = AppColors.surfaceLight.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (1 - progress) * 2 * 3.141592653589793;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_TimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
