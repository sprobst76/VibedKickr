import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MedicalDisclaimerDialog extends StatefulWidget {
  final VoidCallback onAccepted;

  const MedicalDisclaimerDialog({
    required this.onAccepted,
    super.key,
  });

  @override
  State<MedicalDisclaimerDialog> createState() => _MedicalDisclaimerDialogState();
}

class _MedicalDisclaimerDialogState extends State<MedicalDisclaimerDialog> {
  bool understood = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning_amber, color: AppColors.warning, size: 24),
          SizedBox(width: 8),
          Text('Wichtiger Gesundheitshinweis'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bitte lies diese Warnung sorgfältig durch:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            _DisclaimerSection(
              icon: Icons.medical_services_outlined,
              title: 'Ärztliche Freigabe',
              content:
                  'Konsultiere vor Beginn eines Trainingsprogramms einen Arzt, besonders wenn:\n'
                  '• Du über 50 Jahre alt bist\n'
                  '• Du lange nicht trainiert hast\n'
                  '• Du chronische Erkrankungen hast\n'
                  '• Du Herzprobleme oder Bluthochdruck hast',
            ),
            const SizedBox(height: 12),
            _DisclaimerSection(
              icon: Icons.error_outline,
              title: 'SOFORT STOPPEN BEI:',
              content:
                  '❌ Brustschmerzen oder -druck\n'
                  '❌ Schwindel oder Benommenheit\n'
                  '❌ Ungewöhnliche oder extreme Kurzatmigkeit\n'
                  '❌ Übelkeit\n'
                  '❌ Unregelmäßigem Herzschlag\n'
                  '❌ Starken Kopfschmerzen',
            ),
            const SizedBox(height: 12),
            _DisclaimerSection(
              icon: Icons.info_outline,
              title: 'Wichtig',
              content:
                  'Diese App ersetzt keine medizinische Beratung. Die Trainingsprogramme basieren auf wissenschaftlichen Protokollen, können aber nicht alle individuelle Gesundheitszustände berücksichtigen.',
            ),
            const SizedBox(height: 16),
            _UnderstandCheckbox(
              value: understood,
              onChanged: (value) {
                setState(() {
                  understood = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ablehnen'),
        ),
        ElevatedButton(
          onPressed: understood
              ? () {
                  widget.onAccepted();
                }
              : null,
          child: const Text('Ich verstehe und akzeptiere'),
        ),
      ],
    );
  }
}

class _DisclaimerSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _DisclaimerSection({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.warning),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnderstandCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  const _UnderstandCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: const Text(
          'Ich habe diese Warnung gelesen und verstanden',
          style: TextStyle(fontSize: 12),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}
