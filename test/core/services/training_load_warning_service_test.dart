import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/services/training_load_warning_service.dart';
import 'package:kickr_trainer/domain/entities/health_warning.dart';
import 'package:kickr_trainer/domain/entities/tss_threshold_settings.dart';

void main() {
  late TrainingLoadWarningService service;

  setUp(() {
    service = TrainingLoadWarningService();
  });

  group('TrainingLoadWarningService', () {
    group('default CTL-based mode (CTL=0)', () {
      // With CTL=0, warning = clamp(0*1.5, 300, 800) = 300
      // critical = clamp(0*2.0, 400, 1000) = 400

      test('returns no warnings when weeklyTss is below warning threshold', () {
        final warnings = service.generateWarnings(299);

        expect(warnings, isEmpty);
      });

      test('returns warning when weeklyTss equals warning threshold', () {
        final warnings = service.generateWarnings(300);

        expect(warnings, hasLength(1));
        expect(warnings.first.type, HealthWarningType.highWeeklyTss);
        expect(warnings.first.severity, HealthWarningSeverity.warning);
      });

      test('returns warning when weeklyTss is between warning and critical', () {
        final warnings = service.generateWarnings(350);

        expect(warnings, hasLength(1));
        expect(warnings.first.type, HealthWarningType.highWeeklyTss);
        expect(warnings.first.severity, HealthWarningSeverity.warning);
      });

      test('returns critical when weeklyTss equals critical threshold', () {
        final warnings = service.generateWarnings(400);

        expect(warnings, hasLength(1));
        expect(warnings.first.type, HealthWarningType.excessiveWeeklyTss);
        expect(warnings.first.severity, HealthWarningSeverity.critical);
      });

      test('returns critical when weeklyTss exceeds critical threshold', () {
        final warnings = service.generateWarnings(600);

        expect(warnings, hasLength(1));
        expect(warnings.first.type, HealthWarningType.excessiveWeeklyTss);
        expect(warnings.first.severity, HealthWarningSeverity.critical);
      });
    });

    group('manual mode', () {
      final manualSettings = const TssThresholdSettings(
        useCtlBased: false,
        manualWarningThreshold: 400,
        manualCriticalThreshold: 500,
      );

      test('returns no warnings when below manual warning threshold', () {
        final warnings = service.generateWarnings(
          399,
          settings: manualSettings,
        );

        expect(warnings, isEmpty);
      });

      test('returns warning at exact manual warning threshold', () {
        final warnings = service.generateWarnings(
          400,
          settings: manualSettings,
        );

        expect(warnings, hasLength(1));
        expect(warnings.first.type, HealthWarningType.highWeeklyTss);
        expect(warnings.first.severity, HealthWarningSeverity.warning);
      });

      test('returns critical at exact manual critical threshold', () {
        final warnings = service.generateWarnings(
          500,
          settings: manualSettings,
        );

        expect(warnings, hasLength(1));
        expect(warnings.first.type, HealthWarningType.excessiveWeeklyTss);
        expect(warnings.first.severity, HealthWarningSeverity.critical);
      });
    });

    group('CTL-based mode with specific CTL values', () {
      test('with CTL=300, warning at 450, critical at 600', () {
        // warning = (300 * 1.5).round().clamp(300, 800) = 450
        // critical = (300 * 2.0).round().clamp(400, 1000) = 600

        // Below warning
        expect(service.generateWarnings(449, ctl: 300.0), isEmpty);

        // At warning threshold
        final warningResult = service.generateWarnings(450, ctl: 300.0);
        expect(warningResult, hasLength(1));
        expect(warningResult.first.type, HealthWarningType.highWeeklyTss);
        expect(warningResult.first.severity, HealthWarningSeverity.warning);

        // At critical threshold
        final criticalResult = service.generateWarnings(600, ctl: 300.0);
        expect(criticalResult, hasLength(1));
        expect(criticalResult.first.type, HealthWarningType.excessiveWeeklyTss);
        expect(criticalResult.first.severity, HealthWarningSeverity.critical);
      });

      test('low CTL clamps to minimum thresholds', () {
        // CTL=10: warning = (10 * 1.5).round().clamp(300, 800) = 300
        // CTL=10: critical = (10 * 2.0).round().clamp(400, 1000) = 400

        expect(service.generateWarnings(299, ctl: 10.0), isEmpty);

        final warningResult = service.generateWarnings(300, ctl: 10.0);
        expect(warningResult, hasLength(1));
        expect(warningResult.first.severity, HealthWarningSeverity.warning);

        final criticalResult = service.generateWarnings(400, ctl: 10.0);
        expect(criticalResult, hasLength(1));
        expect(criticalResult.first.severity, HealthWarningSeverity.critical);
      });

      test('high CTL clamps to maximum thresholds', () {
        // CTL=1000: warning = (1000 * 1.5).round().clamp(300, 800) = 800
        // CTL=1000: critical = (1000 * 2.0).round().clamp(400, 1000) = 1000

        expect(service.generateWarnings(799, ctl: 1000.0), isEmpty);

        final warningResult = service.generateWarnings(800, ctl: 1000.0);
        expect(warningResult, hasLength(1));
        expect(warningResult.first.severity, HealthWarningSeverity.warning);

        final criticalResult = service.generateWarnings(1000, ctl: 1000.0);
        expect(criticalResult, hasLength(1));
        expect(criticalResult.first.severity, HealthWarningSeverity.critical);
      });
    });

    test('returns at most 1 warning', () {
      // Even with very high TSS, only one warning is returned
      final warnings = service.generateWarnings(9999);

      expect(warnings.length, lessThanOrEqualTo(1));
    });

    test('warning contains expected fields', () {
      final warnings = service.generateWarnings(300);

      expect(warnings, hasLength(1));
      final warning = warnings.first;
      expect(warning.title, isNotEmpty);
      expect(warning.message, isNotEmpty);
      expect(warning.actionLabel, isNotNull);
      expect(warning.createdAt, isNotNull);
    });
  });
}
