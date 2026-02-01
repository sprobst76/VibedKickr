import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/strength_exercise.dart';
import '../../../../domain/entities/strength_workout.dart';

/// Widget zum Konfigurieren von Trainingsintervallen
/// Konfiguriert Sätze, Wiederholungen, Last, Ruhezeit, Tempo
class IntervalConfigWidget extends StatefulWidget {
  final StrengthExercise exercise;
  final dynamic initialData;
  final Function(dynamic) onSave;

  const IntervalConfigWidget({
    required this.exercise,
    required this.initialData,
    required this.onSave,
  });

  @override
  State<IntervalConfigWidget> createState() => _IntervalConfigWidgetState();
}

class _IntervalConfigWidgetState extends State<IntervalConfigWidget> {
  late int _sets;
  late int _repsMin;
  late int _repsMax;
  late String _loadType; // weight, percentage, rpe, bodyweight
  late double _loadValue;
  late int _restSeconds;
  late String? _tempo;
  late String? _instructions;

  @override
  void initState() {
    super.initState();
    _sets = widget.initialData.sets ?? 3;
    _repsMin = widget.initialData.repsMin ?? 10;
    _repsMax = widget.initialData.repsMax ?? _repsMin;
    _tempo = widget.initialData.tempo;
    _instructions = widget.initialData.instructions;
    _restSeconds = widget.initialData.restBetweenSets?.inSeconds ?? 90;

    // Determine load type from initialData.loadTarget
    final loadTarget = widget.initialData.loadTarget;
    switch (loadTarget.type) {
      case LoadTargetType.absolute:
        _loadType = 'weight';
        _loadValue = loadTarget.weight ?? 0;
        break;
      case LoadTargetType.percentage:
        _loadType = 'percentage';
        _loadValue = (loadTarget.percentage ?? 50).toDouble();
        break;
      case LoadTargetType.rpe:
        _loadType = 'rpe';
        _loadValue = (loadTarget.rpe ?? 5).toDouble();
        break;
      case LoadTargetType.bodyweight:
        _loadType = 'bodyweight';
        _loadValue = 0;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          color: AppColors.surface,
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Konfigurieren: ${widget.exercise.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // Sets Configuration
              _buildSectionHeader('SÄTZE'),
              _buildNumberInput(
                label: 'Anzahl Sätze',
                value: _sets,
                onChanged: (value) => setState(() => _sets = value),
                min: 1,
                max: 10,
              ),
              const SizedBox(height: 24),

              // Reps Configuration
              _buildSectionHeader('WIEDERHOLUNGEN'),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberInput(
                      label: 'Min',
                      value: _repsMin,
                      onChanged: (value) => setState(() => _repsMin = value),
                      min: 1,
                      max: 50,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNumberInput(
                      label: 'Max',
                      value: _repsMax,
                      onChanged: (value) => setState(() => _repsMax = value),
                      min: _repsMin,
                      max: 50,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Load Type Selection
              _buildSectionHeader('LAST'),
              _buildLoadTypeSelector(),
              const SizedBox(height: 12),

              // Load Value Input
              if (_loadType != 'bodyweight')
                _buildNumberInput(
                  label: _getLoadLabel(),
                  value: _loadValue.toInt(),
                  onChanged: (value) => setState(() => _loadValue = value.toDouble()),
                  min: _getLoadMin(),
                  max: _getLoadMax(),
                  isDouble: _loadType == 'percentage' || _loadType == 'rpe',
                ),
              const SizedBox(height: 24),

              // Rest Configuration
              _buildSectionHeader('RUHEZEIT'),
              _buildRestSelector(),
              const SizedBox(height: 24),

              // Tempo (optional)
              _buildSectionHeader('TEMPO (Optional)'),
              TextField(
                onChanged: (value) => setState(() => _tempo = value.isEmpty ? null : value),
                decoration: InputDecoration(
                  hintText: 'z.B. 3-1-1 (down-pause-up)',
                  labelText: 'Bewegungstempo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Instructions (optional)
              _buildSectionHeader('ANMERKUNGEN (Optional)'),
              TextField(
                maxLines: 3,
                onChanged: (value) => setState(() => _instructions = value.isEmpty ? null : value),
                decoration: InputDecoration(
                  hintText: 'Zusätzliche Hinweise für diese Übung...',
                  labelText: 'Anmerkungen',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveConfiguration,
                  child: const Text('Speichern'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
    required int min,
    required int max,
    bool isDouble = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                color: AppColors.primary,
                onPressed: value > min ? () => onChanged(value - 1) : null,
              ),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: AppColors.primary,
                onPressed: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildLoadTypeButton('Gewicht', 'weight'),
          _buildLoadTypeButton('% 1RM', 'percentage'),
          _buildLoadTypeButton('RPE', 'rpe'),
          _buildLoadTypeButton('BW', 'bodyweight'),
        ],
      ),
    );
  }

  Widget _buildLoadTypeButton(String label, String type) {
    final isSelected = _loadType == type;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _loadType = type),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : null,
              border: Border(
                right: type != 'bodyweight'
                    ? BorderSide(color: AppColors.surfaceLight)
                    : BorderSide.none,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestSelector() {
    final options = [
      (45, '45 Sek'),
      (60, '1 Min'),
      (90, '1,5 Min'),
      (120, '2 Min'),
      (180, '3 Min'),
    ];

    return Wrap(
      spacing: 8,
      children: options.map((option) {
        final (seconds, label) = option;
        final isSelected = _restSeconds == seconds;
        return FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => setState(() => _restSeconds = seconds),
          backgroundColor: AppColors.surfaceLight,
          selectedColor: AppColors.primary.withValues(alpha: 0.3),
          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontSize: 12,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.surfaceLight,
          ),
        );
      }).toList(),
    );
  }

  String _getLoadLabel() {
    return switch (_loadType) {
      'weight' => 'Gewicht (kg)',
      'percentage' => '% 1RM',
      'rpe' => 'RPE (1-10)',
      _ => 'Last',
    };
  }

  int _getLoadMin() {
    return switch (_loadType) {
      'weight' => 5,
      'percentage' => 30,
      'rpe' => 1,
      _ => 0,
    };
  }

  int _getLoadMax() {
    return switch (_loadType) {
      'weight' => 200,
      'percentage' => 100,
      'rpe' => 10,
      _ => 0,
    };
  }

  void _saveConfiguration() {
    // Create updated LoadTarget based on type
    final loadTarget = switch (_loadType) {
      'weight' => LoadTarget.weight(_loadValue),
      'percentage' => LoadTarget.percentage(_loadValue.toInt(), 100),
      'rpe' => LoadTarget.rpe(_loadValue.toInt()),
      _ => LoadTarget.bodyweight(),
    };

    // Update initialData with new values
    final updatedData = widget.initialData.copyWith(
      sets: _sets,
      repsMin: _repsMin,
      repsMax: _repsMax,
      loadTarget: loadTarget,
      restBetweenSets: Duration(seconds: _restSeconds),
      tempo: _tempo,
      instructions: _instructions,
    );

    widget.onSave(updatedData);
  }
}
