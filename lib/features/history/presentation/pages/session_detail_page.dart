import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/export/session_exporter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../../../domain/entities/training_session.dart';
import '../../../../providers/providers.dart';

/// Provider für einzelne Session
final sessionDetailProvider =
    FutureProvider.family<TrainingSession?, String>((ref, id) async {
  final repository = ref.watch(sessionRepositoryProvider);
  return repository.getSessionById(id);
});

class SessionDetailPage extends ConsumerWidget {
  final String sessionId;

  const SessionDetailPage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionDetailProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Details'),
        actions: [
          sessionAsync.maybeWhen(
            data: (session) => session != null
                ? IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => _showExportDialog(context, session),
                    tooltip: 'Exportieren',
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
            tooltip: 'Löschen',
          ),
        ],
      ),
      body: sessionAsync.when(
        data: (session) {
          if (session == null) {
            return const Center(child: Text('Session nicht gefunden'));
          }
          return _SessionDetailContent(session: session);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Fehler: $error')),
      ),
    );
  }

  void _showExportDialog(BuildContext context, TrainingSession session) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Exportieren als',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('FIT'),
              subtitle: const Text('Garmin FIT Format'),
              onTap: () {
                Navigator.pop(context);
                _exportSession(context, session, ExportFormat.fit);
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('TCX'),
              subtitle: const Text('Training Center XML'),
              onTap: () {
                Navigator.pop(context);
                _exportSession(context, session, ExportFormat.tcx);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _exportSession(
    BuildContext context,
    TrainingSession session,
    ExportFormat format,
  ) async {
    try {
      await SessionExporter.exportAndShare(session, format);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export fehlgeschlagen: $e')),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Training löschen?'),
        content: const Text(
          'Dieses Training wird unwiderruflich gelöscht.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final repository = ref.read(sessionRepositoryProvider);
      await repository.deleteSession(sessionId);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}

class _SessionDetailContent extends StatelessWidget {
  final TrainingSession session;

  const _SessionDetailContent({required this.session});

  @override
  Widget build(BuildContext context) {
    final stats = session.stats;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          _HeaderCard(session: session),
          const SizedBox(height: 16),

          // Stats Grid
          if (stats != null) ...[
            _StatsGrid(stats: stats),
            const SizedBox(height: 16),
          ],

          // Power Chart
          if (session.dataPoints.isNotEmpty) ...[
            _PowerChart(dataPoints: session.dataPoints),
            const SizedBox(height: 16),
          ],

          // HR Chart (if available)
          if (session.dataPoints.any((p) => p.heartRate != null)) ...[
            _HeartRateChart(dataPoints: session.dataPoints),
            const SizedBox(height: 16),
          ],

          // Cadence Chart (if available)
          if (session.dataPoints.any((p) => p.cadence != null)) ...[
            _CadenceChart(dataPoints: session.dataPoints),
          ],
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final TrainingSession session;

  const _HeaderCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final typeInfo = _getTypeInfo(session.type);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: typeInfo.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(typeInfo.icon, color: typeInfo.color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typeInfo.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(session.startTime),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    final months = [
      'Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun',
      'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'
    ];
    return '${weekdays[dt.weekday - 1]}, ${dt.day}. ${months[dt.month - 1]} ${dt.year} · '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} Uhr';
  }

  ({IconData icon, Color color, String name}) _getTypeInfo(SessionType type) {
    return switch (type) {
      SessionType.workout => (
          icon: Icons.fitness_center,
          color: ZoneColors.z4Threshold,
          name: 'Workout',
        ),
      SessionType.freeRide => (
          icon: Icons.explore,
          color: AppColors.primary,
          name: 'Free Ride',
        ),
      SessionType.ftpTest => (
          icon: Icons.assessment,
          color: ZoneColors.z5Vo2Max,
          name: 'FTP Test',
        ),
      SessionType.gpxRoute => (
          icon: Icons.terrain,
          color: ZoneColors.z3Tempo,
          name: 'GPX Route',
        ),
    };
  }
}

class _StatsGrid extends StatelessWidget {
  final SessionStats stats;

  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistiken',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.timer,
                    label: 'Dauer',
                    value: stats.duration.toDisplayString(),
                  ),
                ),
                Expanded(
                  child: _StatTile(
                    icon: Icons.local_fire_department,
                    label: 'TSS',
                    value: '${stats.tss}',
                    valueColor: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _StatTile(
                    icon: Icons.bolt,
                    label: 'Arbeit',
                    value: '${stats.totalWork} kJ',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            const Text(
              'Leistung',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.show_chart,
                    label: 'Durchschnitt',
                    value: '${stats.avgPower} W',
                  ),
                ),
                Expanded(
                  child: _StatTile(
                    icon: Icons.auto_graph,
                    label: 'Normalized',
                    value: '${stats.normalizedPower} W',
                  ),
                ),
                Expanded(
                  child: _StatTile(
                    icon: Icons.arrow_upward,
                    label: 'Maximum',
                    value: '${stats.maxPower} W',
                  ),
                ),
              ],
            ),
            if (stats.avgCadence != null || stats.avgHeartRate != null) ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (stats.avgCadence != null)
                    Expanded(
                      child: _StatTile(
                        icon: Icons.sync,
                        label: 'Kadenz',
                        value: '${stats.avgCadence} rpm',
                      ),
                    ),
                  if (stats.avgHeartRate != null)
                    Expanded(
                      child: _StatTile(
                        icon: Icons.favorite,
                        label: 'Herzfrequenz',
                        value: '${stats.avgHeartRate} bpm',
                        valueColor: Colors.red,
                      ),
                    ),
                  if (stats.distance != null)
                    Expanded(
                      child: _StatTile(
                        icon: Icons.route,
                        label: 'Distanz',
                        value: '${stats.distance!.toStringAsFixed(1)} km',
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.textMuted),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _PowerChart extends StatelessWidget {
  final List<DataPoint> dataPoints;

  const _PowerChart({required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: 'Leistung',
      chart: _buildChart(),
    );
  }

  Widget _buildChart() {
    final spots = dataPoints
        .asMap()
        .entries
        .where((e) => e.key % 5 == 0) // Sample every 5 points
        .map((e) => FlSpot(
              e.value.timestamp / 1000 / 60, // Minutes
              e.value.power.toDouble(),
            ))
        .toList();

    if (spots.isEmpty) return const SizedBox.shrink();

    final maxPower = dataPoints.map((p) => p.power).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.surfaceLight,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 100,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}m',
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: (maxPower * 1.1).roundToDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartRateChart extends StatelessWidget {
  final List<DataPoint> dataPoints;

  const _HeartRateChart({required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: 'Herzfrequenz',
      chart: _buildChart(),
    );
  }

  Widget _buildChart() {
    final spots = dataPoints
        .asMap()
        .entries
        .where((e) => e.key % 5 == 0 && e.value.heartRate != null)
        .map((e) => FlSpot(
              e.value.timestamp / 1000 / 60,
              e.value.heartRate!.toDouble(),
            ))
        .toList();

    if (spots.isEmpty) return const SizedBox.shrink();

    final hrs = dataPoints.where((p) => p.heartRate != null).map((p) => p.heartRate!);
    final maxHr = hrs.reduce((a, b) => a > b ? a : b);
    final minHr = hrs.reduce((a, b) => a < b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.surfaceLight,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}m',
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minY: (minHr - 10).toDouble(),
        maxY: (maxHr + 10).toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.red,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _CadenceChart extends StatelessWidget {
  final List<DataPoint> dataPoints;

  const _CadenceChart({required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return _ChartCard(
      title: 'Kadenz',
      chart: _buildChart(),
    );
  }

  Widget _buildChart() {
    final spots = dataPoints
        .asMap()
        .entries
        .where((e) => e.key % 5 == 0 && e.value.cadence != null)
        .map((e) => FlSpot(
              e.value.timestamp / 1000 / 60,
              e.value.cadence!.toDouble(),
            ))
        .toList();

    if (spots.isEmpty) return const SizedBox.shrink();

    final cadences = dataPoints.where((p) => p.cadence != null).map((p) => p.cadence!);
    final maxCadence = cadences.reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.surfaceLight,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}m',
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: (maxCadence * 1.1).toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.orange,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orange.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget chart;

  const _ChartCard({required this.title, required this.chart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }
}
