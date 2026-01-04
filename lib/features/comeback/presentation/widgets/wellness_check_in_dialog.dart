import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/comeback_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/comeback_mode.dart';

/// Dialog für den täglichen Wellness Check-In
class WellnessCheckInDialog extends ConsumerStatefulWidget {
  const WellnessCheckInDialog({super.key});

  @override
  ConsumerState<WellnessCheckInDialog> createState() =>
      _WellnessCheckInDialogState();
}

class _WellnessCheckInDialogState extends ConsumerState<WellnessCheckInDialog> {
  int _energyLevel = 3;
  int _sleepQuality = 3;
  int _musclesoreness = 3;
  int _motivation = 3;
  int? _restingHeartRate;
  final _notesController = TextEditingController();
  final _hrController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _hrController.dispose();
    super.dispose();
  }

  int get _totalScore =>
      _energyLevel + _sleepQuality + _musclesoreness + _motivation;

  double get _normalizedScore => (_totalScore - 4) / 16 * 100;

  WellnessRecommendation get _recommendation {
    if (_normalizedScore >= 75) return WellnessRecommendation.readyToTrain;
    if (_normalizedScore >= 50) return WellnessRecommendation.lightTraining;
    if (_normalizedScore >= 25) return WellnessRecommendation.activeRecovery;
    return WellnessRecommendation.restDay;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.self_improvement,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Wellness Check-In',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Wie fühlst du dich heute?',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),

                // Energie
                _buildRatingRow(
                  icon: Icons.bolt,
                  label: 'Energie',
                  value: _energyLevel,
                  lowLabel: 'Müde',
                  highLabel: 'Energiegeladen',
                  onChanged: (v) => setState(() => _energyLevel = v),
                ),
                const SizedBox(height: 16),

                // Schlaf
                _buildRatingRow(
                  icon: Icons.bedtime,
                  label: 'Schlafqualität',
                  value: _sleepQuality,
                  lowLabel: 'Schlecht',
                  highLabel: 'Ausgezeichnet',
                  onChanged: (v) => setState(() => _sleepQuality = v),
                ),
                const SizedBox(height: 16),

                // Muskelkater
                _buildRatingRow(
                  icon: Icons.fitness_center,
                  label: 'Muskelkater',
                  value: _musclesoreness,
                  lowLabel: 'Stark',
                  highLabel: 'Keiner',
                  onChanged: (v) => setState(() => _musclesoreness = v),
                ),
                const SizedBox(height: 16),

                // Motivation
                _buildRatingRow(
                  icon: Icons.psychology,
                  label: 'Motivation',
                  value: _motivation,
                  lowLabel: 'Keine Lust',
                  highLabel: 'Hochmotiviert',
                  onChanged: (v) => setState(() => _motivation = v),
                ),
                const SizedBox(height: 24),

                // Optional: Ruhepuls
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 20, color: AppColors.error),
                    const SizedBox(width: 8),
                    const Text('Ruhepuls (optional)'),
                    const Spacer(),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: _hrController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'bpm',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        onChanged: (v) {
                          setState(() {
                            _restingHeartRate = int.tryParse(v);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Notizen
                TextField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Notizen (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Ergebnis/Empfehlung
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getRecommendationColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getRecommendationColor().withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getRecommendationIcon(),
                        color: _getRecommendationColor(),
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _recommendation.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getRecommendationColor(),
                              ),
                            ),
                            Text(
                              _recommendation.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getRecommendationColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_normalizedScore.round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Abbrechen'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _saveCheckIn,
                      child: const Text('Speichern'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingRow({
    required IconData icon,
    required String label,
    required int value,
    required String lowLabel,
    required String highLabel,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              lowLabel,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final level = index + 1;
                  final isSelected = level == value;
                  return GestureDetector(
                    onTap: () => onChanged(level),
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? _getLevelColor(level)
                            : AppColors.surfaceLight,
                        border: Border.all(
                          color: isSelected
                              ? _getLevelColor(level)
                              : AppColors.textMuted.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$level',
                          style: TextStyle(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Text(
              highLabel,
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.warning;
      case 4:
        return AppColors.success;
      case 5:
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  Color _getRecommendationColor() {
    switch (_recommendation) {
      case WellnessRecommendation.restDay:
        return AppColors.error;
      case WellnessRecommendation.activeRecovery:
        return AppColors.warning;
      case WellnessRecommendation.lightTraining:
        return AppColors.primary;
      case WellnessRecommendation.readyToTrain:
        return AppColors.success;
    }
  }

  IconData _getRecommendationIcon() {
    switch (_recommendation) {
      case WellnessRecommendation.restDay:
        return Icons.hotel;
      case WellnessRecommendation.activeRecovery:
        return Icons.self_improvement;
      case WellnessRecommendation.lightTraining:
        return Icons.directions_walk;
      case WellnessRecommendation.readyToTrain:
        return Icons.directions_bike;
    }
  }

  void _saveCheckIn() {
    final checkIn = WellnessCheckIn(
      date: DateTime.now(),
      energyLevel: _energyLevel,
      sleepQuality: _sleepQuality,
      musclesoreness: _musclesoreness,
      motivation: _motivation,
      restingHeartRate: _restingHeartRate,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    ref.read(comebackModeProvider.notifier).addCheckIn(checkIn);
    Navigator.pop(context, checkIn);
  }
}

/// Zeigt den Check-In Dialog an
Future<WellnessCheckIn?> showWellnessCheckInDialog(BuildContext context) {
  return showDialog<WellnessCheckIn>(
    context: context,
    builder: (context) => const WellnessCheckInDialog(),
  );
}
