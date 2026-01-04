import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../domain/entities/training_session.dart';

/// Exportiert Training Sessions im TCX Format (Training Center XML)
class TcxExporter {
  /// Generiert TCX XML String aus einer Session
  static String generateTcx(TrainingSession session) {
    final buffer = StringBuffer();

    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln(
        '<TrainingCenterDatabase xmlns="http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2" '
        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
        'xsi:schemaLocation="http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2 '
        'http://www.garmin.com/xmlschemas/TrainingCenterDatabasev2.xsd">');

    buffer.writeln('  <Activities>');
    buffer.writeln('    <Activity Sport="Biking">');
    buffer.writeln('      <Id>${_formatDateTime(session.startTime)}</Id>');

    // Single Lap für die gesamte Session
    buffer.writeln('      <Lap StartTime="${_formatDateTime(session.startTime)}">');

    final stats = session.stats;
    final durationSeconds = stats?.duration.inSeconds ?? 0;
    final distanceMeters = (stats?.distance ?? 0) * 1000;

    buffer.writeln('        <TotalTimeSeconds>$durationSeconds</TotalTimeSeconds>');
    buffer.writeln('        <DistanceMeters>$distanceMeters</DistanceMeters>');

    if (stats != null) {
      buffer.writeln('        <MaximumSpeed>${_calcMaxSpeed(session)}</MaximumSpeed>');
      buffer.writeln('        <Calories>${stats.calories ?? 0}</Calories>');

      if (stats.avgHeartRate != null) {
        buffer.writeln('        <AverageHeartRateBpm>');
        buffer.writeln('          <Value>${stats.avgHeartRate}</Value>');
        buffer.writeln('        </AverageHeartRateBpm>');
      }
      if (stats.maxHeartRate != null) {
        buffer.writeln('        <MaximumHeartRateBpm>');
        buffer.writeln('          <Value>${stats.maxHeartRate}</Value>');
        buffer.writeln('        </MaximumHeartRateBpm>');
      }
    }

    buffer.writeln('        <Intensity>Active</Intensity>');
    buffer.writeln('        <TriggerMethod>Manual</TriggerMethod>');

    // Track mit Trackpoints
    buffer.writeln('        <Track>');

    for (final point in session.dataPoints) {
      final pointTime = session.startTime.add(Duration(milliseconds: point.timestamp));
      buffer.writeln('          <Trackpoint>');
      buffer.writeln('            <Time>${_formatDateTime(pointTime)}</Time>');

      if (point.heartRate != null) {
        buffer.writeln('            <HeartRateBpm>');
        buffer.writeln('              <Value>${point.heartRate}</Value>');
        buffer.writeln('            </HeartRateBpm>');
      }

      if (point.cadence != null) {
        buffer.writeln('            <Cadence>${point.cadence}</Cadence>');
      }

      if (point.distance != null) {
        buffer.writeln('            <DistanceMeters>${point.distance}</DistanceMeters>');
      }

      // Extensions für Power
      buffer.writeln('            <Extensions>');
      buffer.writeln('              <TPX xmlns="http://www.garmin.com/xmlschemas/ActivityExtension/v2">');
      buffer.writeln('                <Watts>${point.power}</Watts>');
      if (point.speed != null) {
        buffer.writeln('                <Speed>${(point.speed! / 3.6).toStringAsFixed(2)}</Speed>');
      }
      buffer.writeln('              </TPX>');
      buffer.writeln('            </Extensions>');

      buffer.writeln('          </Trackpoint>');
    }

    buffer.writeln('        </Track>');

    // Lap Extensions für Durchschnittswerte
    if (stats != null) {
      buffer.writeln('        <Extensions>');
      buffer.writeln('          <LX xmlns="http://www.garmin.com/xmlschemas/ActivityExtension/v2">');
      buffer.writeln('            <AvgWatts>${stats.avgPower}</AvgWatts>');
      buffer.writeln('            <MaxWatts>${stats.maxPower}</MaxWatts>');
      if (stats.avgCadence != null) {
        buffer.writeln('            <AvgRunCadence>${stats.avgCadence}</AvgRunCadence>');
      }
      buffer.writeln('          </LX>');
      buffer.writeln('        </Extensions>');
    }

    buffer.writeln('      </Lap>');
    buffer.writeln('    </Activity>');
    buffer.writeln('  </Activities>');

    // Author Info
    buffer.writeln('  <Author xsi:type="Application_t">');
    buffer.writeln('    <Name>VibedKickr</Name>');
    buffer.writeln('    <Build>');
    buffer.writeln('      <Version>');
    buffer.writeln('        <VersionMajor>1</VersionMajor>');
    buffer.writeln('        <VersionMinor>0</VersionMinor>');
    buffer.writeln('      </Version>');
    buffer.writeln('    </Build>');
    buffer.writeln('    <LangID>de</LangID>');
    buffer.writeln('  </Author>');

    buffer.writeln('</TrainingCenterDatabase>');

    return buffer.toString();
  }

  /// Exportiert Session als TCX Datei und gibt den Pfad zurück
  static Future<String> exportToFile(TrainingSession session) async {
    final tcxContent = generateTcx(session);
    final directory = await getTemporaryDirectory();
    final fileName = 'workout_${_formatFileDate(session.startTime)}.tcx';
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(tcxContent);
    return file.path;
  }

  static String _formatDateTime(DateTime dt) {
    return dt.toUtc().toIso8601String();
  }

  static String _formatFileDate(DateTime dt) {
    return '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}_'
        '${dt.hour.toString().padLeft(2, '0')}${dt.minute.toString().padLeft(2, '0')}';
  }

  static double _calcMaxSpeed(TrainingSession session) {
    if (session.dataPoints.isEmpty) return 0;
    final speeds = session.dataPoints
        .where((p) => p.speed != null)
        .map((p) => p.speed! / 3.6); // km/h -> m/s
    if (speeds.isEmpty) return 0;
    return speeds.reduce((a, b) => a > b ? a : b);
  }
}
