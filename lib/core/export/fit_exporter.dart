import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../../domain/entities/training_session.dart';

/// Exportiert Training Sessions im FIT Format (Flexible and Interoperable Data Transfer)
/// Implementiert einen minimalen FIT-Encoder für Cycling Activities
class FitExporter {
  // FIT Protocol Constants
  static const int _fitProtocolVersion = 0x20; // 2.0
  static const int _fitProfileVersion = 0x0814; // 20.84

  // Message Types (Global Message Numbers)
  static const int _mesgFileId = 0;
  static const int _mesgSession = 18;
  static const int _mesgLap = 19;
  static const int _mesgRecord = 20;
  static const int _mesgEvent = 21;
  static const int _mesgActivity = 34;

  // Field Definition Numbers
  static const int _fieldTimestamp = 253;
  static const int _fieldHeartRate = 3;
  static const int _fieldCadence = 4;
  static const int _fieldDistance = 5;
  static const int _fieldSpeed = 6;
  static const int _fieldPower = 7;

  /// Exportiert Session als FIT Datei und gibt den Pfad zurück
  static Future<String> exportToFile(TrainingSession session) async {
    final fitData = _generateFit(session);
    final directory = await getTemporaryDirectory();
    final fileName = 'workout_${_formatFileDate(session.startTime)}.fit';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(fitData);
    return file.path;
  }

  static Uint8List _generateFit(TrainingSession session) {
    final builder = _FitBuilder();

    // File Header
    builder.writeFileHeader();

    // File ID Message (required)
    builder.writeFileIdMessage(session);

    // Event Message (Start)
    builder.writeEventMessage(session.startTime, isStart: true);

    // Record Messages (data points)
    for (final point in session.dataPoints) {
      final pointTime = session.startTime.add(Duration(milliseconds: point.timestamp));
      builder.writeRecordMessage(pointTime, point);
    }

    // Event Message (Stop)
    final endTime = session.endTime ?? session.startTime;
    builder.writeEventMessage(endTime, isStart: false);

    // Lap Message
    builder.writeLapMessage(session);

    // Session Message
    builder.writeSessionMessage(session);

    // Activity Message
    builder.writeActivityMessage(session);

    // Finalize with CRC
    return builder.finalize();
  }

  static String _formatFileDate(DateTime dt) {
    return '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}_'
        '${dt.hour.toString().padLeft(2, '0')}${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _FitBuilder {
  final BytesBuilder _data = BytesBuilder();
  final Map<int, List<_FieldDef>> _definitions = {};
  int _localMessageType = 0;

  // FIT Epoch: 1989-12-31 00:00:00 UTC
  static final DateTime _fitEpoch = DateTime.utc(1989, 12, 31);

  void writeFileHeader() {
    // Header size (14 bytes for newer FIT files)
    _data.addByte(14);
    // Protocol version
    _data.addByte(FitExporter._fitProtocolVersion);
    // Profile version (little endian)
    _data.addByte(FitExporter._fitProfileVersion & 0xFF);
    _data.addByte((FitExporter._fitProfileVersion >> 8) & 0xFF);
    // Data size placeholder (will be updated in finalize)
    _data.addByte(0);
    _data.addByte(0);
    _data.addByte(0);
    _data.addByte(0);
    // ".FIT" signature
    _data.addByte(0x2E); // .
    _data.addByte(0x46); // F
    _data.addByte(0x49); // I
    _data.addByte(0x54); // T
    // CRC placeholder (2 bytes)
    _data.addByte(0);
    _data.addByte(0);
  }

  void writeFileIdMessage(TrainingSession session) {
    final fields = [
      _FieldDef(0, 1, 0), // type: activity (4)
      _FieldDef(1, 2, 132), // manufacturer: development (255)
      _FieldDef(2, 2, 132), // product
      _FieldDef(3, 4, 134), // serial_number
      _FieldDef(4, 4, 134), // time_created
    ];

    _writeDefinition(FitExporter._mesgFileId, fields);

    // Data
    _data.addByte(_localMessageType); // Record header
    _data.addByte(4); // type: activity
    _writeUint16(255); // manufacturer: development
    _writeUint16(1); // product
    _writeUint32(12345); // serial_number
    _writeUint32(_toFitTimestamp(session.startTime)); // time_created
  }

  void writeEventMessage(DateTime time, {required bool isStart}) {
    final fields = [
      _FieldDef(FitExporter._fieldTimestamp, 4, 134), // timestamp
      _FieldDef(0, 1, 0), // event
      _FieldDef(1, 1, 0), // event_type
    ];

    _writeDefinition(FitExporter._mesgEvent, fields);

    _data.addByte(_localMessageType);
    _writeUint32(_toFitTimestamp(time));
    _data.addByte(0); // event: timer
    _data.addByte(isStart ? 0 : 4); // event_type: start/stop
  }

  void writeRecordMessage(DateTime time, DataPoint point) {
    final fields = [
      _FieldDef(FitExporter._fieldTimestamp, 4, 134), // timestamp
      _FieldDef(FitExporter._fieldHeartRate, 1, 2), // heart_rate
      _FieldDef(FitExporter._fieldCadence, 1, 2), // cadence
      _FieldDef(FitExporter._fieldDistance, 4, 134), // distance (in cm)
      _FieldDef(FitExporter._fieldSpeed, 2, 132), // speed (mm/s)
      _FieldDef(FitExporter._fieldPower, 2, 132), // power
    ];

    _writeDefinition(FitExporter._mesgRecord, fields);

    _data.addByte(_localMessageType);
    _writeUint32(_toFitTimestamp(time));
    _data.addByte(point.heartRate ?? 0xFF); // 0xFF = invalid
    _data.addByte(point.cadence ?? 0xFF);
    _writeUint32(point.distance != null ? (point.distance! * 100).round() : 0xFFFFFFFF);
    _writeUint16(point.speed != null ? (point.speed! * 1000 / 3.6).round() : 0xFFFF);
    _writeUint16(point.power);
  }

  void writeLapMessage(TrainingSession session) {
    final stats = session.stats;
    final fields = [
      _FieldDef(FitExporter._fieldTimestamp, 4, 134), // timestamp
      _FieldDef(0, 4, 134), // start_time
      _FieldDef(7, 4, 134), // total_elapsed_time (ms)
      _FieldDef(8, 4, 134), // total_timer_time (ms)
      _FieldDef(9, 4, 134), // total_distance (cm)
      _FieldDef(13, 2, 132), // avg_speed (mm/s)
      _FieldDef(14, 2, 132), // max_speed (mm/s)
      _FieldDef(15, 1, 2), // avg_heart_rate
      _FieldDef(16, 1, 2), // max_heart_rate
      _FieldDef(17, 1, 2), // avg_cadence
      _FieldDef(18, 1, 2), // max_cadence
      _FieldDef(19, 2, 132), // avg_power
      _FieldDef(20, 2, 132), // max_power
      _FieldDef(24, 0, 0), // lap_trigger (manual)
      _FieldDef(25, 1, 0), // sport
    ];

    _writeDefinition(FitExporter._mesgLap, fields);

    final endTime = session.endTime ?? session.startTime;
    final durationMs = stats?.duration.inMilliseconds ?? 0;
    final distanceCm = ((stats?.distance ?? 0) * 100000).round();

    _data.addByte(_localMessageType);
    _writeUint32(_toFitTimestamp(endTime));
    _writeUint32(_toFitTimestamp(session.startTime));
    _writeUint32(durationMs);
    _writeUint32(durationMs);
    _writeUint32(distanceCm);
    _writeUint16(0); // avg_speed
    _writeUint16(0); // max_speed
    _data.addByte(stats?.avgHeartRate ?? 0xFF);
    _data.addByte(stats?.maxHeartRate ?? 0xFF);
    _data.addByte(stats?.avgCadence ?? 0xFF);
    _data.addByte(stats?.maxCadence ?? 0xFF);
    _writeUint16(stats?.avgPower ?? 0);
    _writeUint16(stats?.maxPower ?? 0);
    _data.addByte(0); // lap_trigger: manual
    _data.addByte(2); // sport: cycling
  }

  void writeSessionMessage(TrainingSession session) {
    final stats = session.stats;
    final fields = [
      _FieldDef(FitExporter._fieldTimestamp, 4, 134),
      _FieldDef(0, 4, 134), // start_time
      _FieldDef(7, 4, 134), // total_elapsed_time
      _FieldDef(8, 4, 134), // total_timer_time
      _FieldDef(5, 1, 0), // sport
      _FieldDef(6, 1, 0), // sub_sport
      _FieldDef(9, 4, 134), // total_distance
      _FieldDef(11, 2, 132), // total_calories
      _FieldDef(20, 2, 132), // avg_power
      _FieldDef(21, 2, 132), // max_power
      _FieldDef(34, 2, 132), // normalized_power
      _FieldDef(35, 2, 132), // training_stress_score
    ];

    _writeDefinition(FitExporter._mesgSession, fields);

    final endTime = session.endTime ?? session.startTime;
    final durationMs = stats?.duration.inMilliseconds ?? 0;

    _data.addByte(_localMessageType);
    _writeUint32(_toFitTimestamp(endTime));
    _writeUint32(_toFitTimestamp(session.startTime));
    _writeUint32(durationMs);
    _writeUint32(durationMs);
    _data.addByte(2); // sport: cycling
    _data.addByte(6); // sub_sport: indoor_cycling
    _writeUint32(((stats?.distance ?? 0) * 100000).round());
    _writeUint16(stats?.calories ?? 0);
    _writeUint16(stats?.avgPower ?? 0);
    _writeUint16(stats?.maxPower ?? 0);
    _writeUint16(stats?.normalizedPower ?? 0);
    _writeUint16((stats?.tss ?? 0) * 10); // TSS in 0.1 scale
  }

  void writeActivityMessage(TrainingSession session) {
    final fields = [
      _FieldDef(FitExporter._fieldTimestamp, 4, 134),
      _FieldDef(0, 4, 134), // total_timer_time
      _FieldDef(1, 2, 132), // num_sessions
      _FieldDef(2, 1, 0), // type
      _FieldDef(3, 1, 0), // event
      _FieldDef(4, 1, 0), // event_type
    ];

    _writeDefinition(FitExporter._mesgActivity, fields);

    final endTime = session.endTime ?? session.startTime;
    final durationMs = session.stats?.duration.inMilliseconds ?? 0;

    _data.addByte(_localMessageType);
    _writeUint32(_toFitTimestamp(endTime));
    _writeUint32(durationMs);
    _writeUint16(1); // num_sessions
    _data.addByte(0); // type: manual
    _data.addByte(26); // event: activity
    _data.addByte(1); // event_type: stop
  }

  void _writeDefinition(int globalMesgNum, List<_FieldDef> fields) {
    // Check if we need to write a new definition
    final existing = _definitions[globalMesgNum];
    if (existing != null && _fieldsEqual(existing, fields)) {
      return;
    }

    _definitions[globalMesgNum] = fields;
    _localMessageType = globalMesgNum & 0x0F;

    // Definition message header (0x40 = definition)
    _data.addByte(0x40 | _localMessageType);
    _data.addByte(0); // Reserved
    _data.addByte(0); // Architecture (0 = little endian)
    _writeUint16(globalMesgNum); // Global message number
    _data.addByte(fields.length); // Number of fields

    for (final field in fields) {
      _data.addByte(field.fieldDefNum);
      _data.addByte(field.size);
      _data.addByte(field.baseType);
    }
  }

  bool _fieldsEqual(List<_FieldDef> a, List<_FieldDef> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].fieldDefNum != b[i].fieldDefNum) return false;
    }
    return true;
  }

  void _writeUint16(int value) {
    _data.addByte(value & 0xFF);
    _data.addByte((value >> 8) & 0xFF);
  }

  void _writeUint32(int value) {
    _data.addByte(value & 0xFF);
    _data.addByte((value >> 8) & 0xFF);
    _data.addByte((value >> 16) & 0xFF);
    _data.addByte((value >> 24) & 0xFF);
  }

  int _toFitTimestamp(DateTime dt) {
    return dt.toUtc().difference(_fitEpoch).inSeconds;
  }

  Uint8List finalize() {
    final bytes = _data.toBytes();
    final dataSize = bytes.length - 14; // Subtract header size

    // Update data size in header (bytes 4-7)
    bytes[4] = dataSize & 0xFF;
    bytes[5] = (dataSize >> 8) & 0xFF;
    bytes[6] = (dataSize >> 16) & 0xFF;
    bytes[7] = (dataSize >> 24) & 0xFF;

    // Calculate header CRC (bytes 0-11)
    final headerCrc = _calculateCrc(bytes.sublist(0, 12));
    bytes[12] = headerCrc & 0xFF;
    bytes[13] = (headerCrc >> 8) & 0xFF;

    // Calculate file CRC (entire file including header)
    final fileCrc = _calculateCrc(bytes);

    // Append file CRC
    final result = BytesBuilder();
    result.add(bytes);
    result.addByte(fileCrc & 0xFF);
    result.addByte((fileCrc >> 8) & 0xFF);

    return result.toBytes();
  }

  int _calculateCrc(List<int> data) {
    const crcTable = [
      0x0000, 0xCC01, 0xD801, 0x1400, 0xF001, 0x3C00, 0x2800, 0xE401,
      0xA001, 0x6C00, 0x7800, 0xB401, 0x5000, 0x9C01, 0x8801, 0x4400,
    ];

    int crc = 0;
    for (final byte in data) {
      int tmp = crcTable[crc & 0xF];
      crc = (crc >> 4) & 0x0FFF;
      crc = crc ^ tmp ^ crcTable[byte & 0xF];

      tmp = crcTable[crc & 0xF];
      crc = (crc >> 4) & 0x0FFF;
      crc = crc ^ tmp ^ crcTable[(byte >> 4) & 0xF];
    }
    return crc;
  }
}

class _FieldDef {
  final int fieldDefNum;
  final int size;
  final int baseType;

  _FieldDef(this.fieldDefNum, this.size, this.baseType);
}
