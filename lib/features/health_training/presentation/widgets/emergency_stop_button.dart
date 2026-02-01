import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Emergency Stop Button für Health Training
///
/// Zeigt prominenter Notfall-Stopp Button wenn Health Training aktiv ist.
/// Wird besonders wichtig bei HR-Grenzüberschreitungen.
class EmergencyStopButton extends StatefulWidget {
  /// Callback wenn Notfall-Stopp gedrückt wird
  final VoidCallback onEmergencyStop;

  /// Ist der Button aktiv/sichtbar?
  final bool isActive;

  /// Zusätzliche Warnung anzeigen?
  final bool showWarning;

  /// Warnung-Text wenn showWarning = true
  final String? warningText;

  const EmergencyStopButton({
    required this.onEmergencyStop,
    this.isActive = false,
    this.showWarning = false,
    this.warningText,
    super.key,
  });

  @override
  State<EmergencyStopButton> createState() => _EmergencyStopButtonState();
}

class _EmergencyStopButtonState extends State<EmergencyStopButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    if (widget.showWarning) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(EmergencyStopButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showWarning && !_pulseController.isAnimating) {
      _pulseController.repeat();
    } else if (!widget.showWarning && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Warnung wenn aktiv
        if (widget.showWarning && widget.warningText != null)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning,
                  color: AppColors.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.warningText!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Emergency Stop Button
        Stack(
          alignment: Alignment.center,
          children: [
            // Pulse Animation
            if (widget.showWarning)
              ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.1).animate(
                  CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                ),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error.withValues(alpha: 0.2),
                  ),
                ),
              ),

            // Main Button
            ElevatedButton(
              onPressed: _showConfirmationDialog,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                elevation: widget.showWarning ? 8 : 2,
                shadowColor: widget.showWarning
                    ? AppColors.error.withValues(alpha: 0.5)
                    : AppColors.error.withValues(alpha: 0.2),
              ),
              child: Icon(
                Icons.stop_circle,
                size: widget.showWarning ? 40 : 36,
                color: Colors.white,
              ),
            ),
          ],
        ),

        // Label
        const SizedBox(height: 8),
        const Text(
          'Notfall-Stopp',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.error, size: 28),
            SizedBox(width: 8),
            Text('Notfall-Stopp bestätigen'),
          ],
        ),
        content: const Text(
          'Möchtest du das Training sofort beenden? Dies wird ein Sicherheits-Ereignis registrieren.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onEmergencyStop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Ja, Training beenden'),
          ),
        ],
      ),
    );
  }
}
