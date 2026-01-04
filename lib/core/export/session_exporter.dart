import 'package:share_plus/share_plus.dart';

import '../../domain/entities/training_session.dart';
import 'fit_exporter.dart';
import 'tcx_exporter.dart';

/// Export Formate
enum ExportFormat {
  fit('FIT', 'Garmin FIT Format'),
  tcx('TCX', 'Training Center XML');

  final String name;
  final String description;

  const ExportFormat(this.name, this.description);
}

/// Service zum Exportieren und Teilen von Sessions
class SessionExporter {
  /// Exportiert Session und öffnet Share-Dialog
  static Future<void> exportAndShare(
    TrainingSession session,
    ExportFormat format,
  ) async {
    final filePath = await _exportToFile(session, format);

    await Share.shareXFiles(
      [XFile(filePath)],
      subject: 'VibedKickr Training Export',
    );
  }

  /// Exportiert Session in das gewählte Format
  static Future<String> _exportToFile(
    TrainingSession session,
    ExportFormat format,
  ) async {
    return switch (format) {
      ExportFormat.fit => FitExporter.exportToFile(session),
      ExportFormat.tcx => TcxExporter.exportToFile(session),
    };
  }

  /// Generiert den Dateinamen für eine Session
  static String getFileName(TrainingSession session, ExportFormat format) {
    final date = session.startTime;
    final dateStr = '${date.year}${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}_'
        '${date.hour.toString().padLeft(2, '0')}'
        '${date.minute.toString().padLeft(2, '0')}';
    final extension = format.name.toLowerCase();
    return 'workout_$dateStr.$extension';
  }
}
