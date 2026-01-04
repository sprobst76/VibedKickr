import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class PowerGauge extends StatelessWidget {
  final int power;
  final int zone;
  final int targetPower;
  final int ftp;

  const PowerGauge({
    super.key,
    required this.power,
    required this.zone,
    this.targetPower = 0,
    required this.ftp,
  });

  @override
  Widget build(BuildContext context) {
    final zoneColor = ZoneColors.forZone(zone);
    final zoneName = ZoneColors.zoneName(zone);
    final wattsPerKg = ftp > 0 ? (power / ftp * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: zoneColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Zone Name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: zoneColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Zone $zone - $zoneName',
              style: TextStyle(
                color: zoneColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Power Value
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                power.toString(),
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: zoneColor,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'W',
                  style: TextStyle(
                    fontSize: 24,
                    color: zoneColor.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),

          // FTP Percentage
          Text(
            '$wattsPerKg% FTP',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Zone Bar
          _ZoneBar(currentZone: zone),

          // Target Power (wenn gesetzt)
          if (targetPower > 0) ...[
            const SizedBox(height: 16),
            _TargetPowerIndicator(
              currentPower: power,
              targetPower: targetPower,
            ),
          ],
        ],
      ),
    );
  }
}

class _ZoneBar extends StatelessWidget {
  final int currentZone;

  const _ZoneBar({required this.currentZone});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (index) {
        final zone = index + 1;
        final isActive = zone == currentZone;
        final color = ZoneColors.forZone(zone);

        return Expanded(
          child: Container(
            height: isActive ? 8 : 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isActive ? color : color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

class _TargetPowerIndicator extends StatelessWidget {
  final int currentPower;
  final int targetPower;

  const _TargetPowerIndicator({
    required this.currentPower,
    required this.targetPower,
  });

  @override
  Widget build(BuildContext context) {
    final diff = currentPower - targetPower;
    final isOnTarget = diff.abs() <= targetPower * 0.05; // ±5%
    final isTooLow = diff < -targetPower * 0.05;

    final color = isOnTarget
        ? AppColors.success
        : isTooLow
            ? AppColors.warning
            : AppColors.error;

    final icon = isOnTarget
        ? Icons.check_circle
        : isTooLow
            ? Icons.arrow_upward
            : Icons.arrow_downward;

    final message = isOnTarget
        ? 'Ziel erreicht'
        : isTooLow
            ? '${diff.abs()}W mehr'
            : '${diff.abs()}W weniger';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            'Ziel: ${targetPower}W',
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 16,
            color: color.withOpacity(0.3),
          ),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
