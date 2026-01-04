import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/daos/gpx_route_dao.dart';
import '../../../../core/gpx/gpx_route_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../routing/app_router.dart';

/// Seite mit Liste aller importierten GPX Routen
class RouteListPage extends ConsumerWidget {
  const RouteListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routesAsync = ref.watch(gpxRoutesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _importRoute(context, ref),
            tooltip: 'Route importieren',
          ),
        ],
      ),
      body: routesAsync.when(
        data: (routes) {
          if (routes.isEmpty) {
            return _EmptyState(onImport: () => _importRoute(context, ref));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: routes.length,
            itemBuilder: (context, index) {
              final route = routes[index];
              return _RouteCard(
                route: route,
                onTap: () => context.push(
                  '${AppRoutes.routePlayer}?routeId=${route.id}',
                ),
                onDelete: () => _confirmDelete(context, ref, route),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _importRoute(context, ref),
        icon: const Icon(Icons.file_upload),
        label: const Text('GPX importieren'),
      ),
    );
  }

  Future<void> _importRoute(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['gpx'],
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      if (file.bytes == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fehler beim Lesen der Datei')),
          );
        }
        return;
      }

      final gpxContent = String.fromCharCodes(file.bytes!);
      final service = ref.read(gpxRouteServiceProvider);
      final route = await service.importGpx(gpxContent);

      if (route != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${route.name} importiert '
              '(${route.totalDistanceKm.toStringAsFixed(1)} km, '
              '${route.elevationGain.round()}m Höhenmeter)',
            ),
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ungültige GPX-Datei')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import fehlgeschlagen: $e')),
        );
      }
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, GpxRouteSummary route) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Route löschen?'),
        content: Text('Möchtest du "${route.name}" wirklich löschen?'),
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

    if (confirmed == true) {
      final service = ref.read(gpxRouteServiceProvider);
      await service.deleteRoute(route.id);
    }
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onImport;

  const _EmptyState({required this.onImport});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.terrain,
              size: 80,
              color: AppColors.textMuted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Keine Routen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Importiere eine GPX-Datei um virtuelle '
              'Strecken mit echtem Höhenprofil zu fahren.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onImport,
              icon: const Icon(Icons.file_upload),
              label: const Text('GPX importieren'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final GpxRouteSummary route;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _RouteCard({
    required this.route,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.terrain,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (route.description != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            route.description!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: onDelete,
                    tooltip: 'Löschen',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Stats
              Row(
                children: [
                  _StatChip(
                    icon: Icons.straighten,
                    label: '${route.totalDistanceKm.toStringAsFixed(1)} km',
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    icon: Icons.trending_up,
                    label: '${route.elevationGain.round()} m',
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.play_circle_outline,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
