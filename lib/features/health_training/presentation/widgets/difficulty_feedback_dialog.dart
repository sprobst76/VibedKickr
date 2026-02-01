import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class DifficultyFeedbackDialog extends StatefulWidget {
  final Function(int) onFeedback;

  const DifficultyFeedbackDialog({
    required this.onFeedback,
    super.key,
  });

  @override
  State<DifficultyFeedbackDialog> createState() => _DifficultyFeedbackDialogState();
}

class _DifficultyFeedbackDialogState extends State<DifficultyFeedbackDialog> {
  int? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.emoji_emotions, size: 28, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Wie war die Schwierigkeit?'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Dein Feedback hilft uns, zukünftige Programme besser anzupassen.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ..._buildDifficultyOptions(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onFeedback(_selectedDifficulty ?? 3);
          },
          child: const Text('Überspringen'),
        ),
        ElevatedButton(
          onPressed: _selectedDifficulty == null
              ? null
              : () {
                  Navigator.pop(context);
                  widget.onFeedback(_selectedDifficulty!);
                },
          child: const Text('Fertig'),
        ),
      ],
    );
  }

  List<Widget> _buildDifficultyOptions() {
    final options = [
      (
        difficulty: 1,
        emoji: '😴',
        label: 'Viel zu einfach',
        description: 'War kein Problem',
      ),
      (
        difficulty: 2,
        emoji: '😊',
        label: 'Ein wenig leicht',
        description: 'Hätte anspruchsvoller sein können',
      ),
      (
        difficulty: 3,
        emoji: '👍',
        label: 'Perfekt',
        description: 'Gerade richtig',
      ),
      (
        difficulty: 4,
        emoji: '😰',
        label: 'Ein wenig schwer',
        description: 'War herausfordernd',
      ),
      (
        difficulty: 5,
        emoji: '😡',
        label: 'Viel zu schwer',
        description: 'War überwältigend',
      ),
    ];

    return options
        .map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DifficultyOption(
                emoji: option.emoji,
                label: option.label,
                description: option.description,
                isSelected: _selectedDifficulty == option.difficulty,
                onTap: () {
                  setState(() {
                    _selectedDifficulty = option.difficulty;
                  });
                },
              ),
            ))
        .toList();
  }
}

class _DifficultyOption extends StatelessWidget {
  final String emoji;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.emoji,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
