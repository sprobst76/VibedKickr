import 'package:flutter_test/flutter_test.dart';
import 'package:kickr_trainer/core/services/ftp_test_reminder_service.dart';
import 'package:kickr_trainer/domain/entities/health_warning.dart';

void main() {
  late FtpTestReminderService service;

  setUp(() {
    service = FtpTestReminderService();
  });

  group('FtpTestReminderService', () {
    test('returns empty list when ftpTestDate is null', () {
      final warnings = service.generateWarnings(null);

      expect(warnings, isEmpty);
    });

    test('returns empty list for recent test (7 days ago)', () {
      final recentDate = DateTime.now().subtract(const Duration(days: 7));
      final warnings = service.generateWarnings(recentDate);

      expect(warnings, isEmpty);
    });

    test('returns empty list for test just under 28 days', () {
      final date = DateTime.now().subtract(const Duration(days: 27));
      final warnings = service.generateWarnings(date);

      expect(warnings, isEmpty);
    });

    test('returns info warning (ftpTestReminder) at 28 days', () {
      final date = DateTime.now().subtract(const Duration(days: 28));
      final warnings = service.generateWarnings(date);

      expect(warnings, hasLength(1));
      expect(warnings.first.type, HealthWarningType.ftpTestReminder);
      expect(warnings.first.severity, HealthWarningSeverity.info);
    });

    test('returns info warning for 35 days (between 28 and 42)', () {
      final date = DateTime.now().subtract(const Duration(days: 35));
      final warnings = service.generateWarnings(date);

      expect(warnings, hasLength(1));
      expect(warnings.first.type, HealthWarningType.ftpTestReminder);
      expect(warnings.first.severity, HealthWarningSeverity.info);
    });

    test('returns warning (ftpTestOverdue) at 42 days', () {
      final date = DateTime.now().subtract(const Duration(days: 42));
      final warnings = service.generateWarnings(date);

      expect(warnings, hasLength(1));
      expect(warnings.first.type, HealthWarningType.ftpTestOverdue);
      expect(warnings.first.severity, HealthWarningSeverity.warning);
    });

    test('returns warning for 50 days (between 42 and 56)', () {
      final date = DateTime.now().subtract(const Duration(days: 50));
      final warnings = service.generateWarnings(date);

      expect(warnings, hasLength(1));
      expect(warnings.first.type, HealthWarningType.ftpTestOverdue);
      expect(warnings.first.severity, HealthWarningSeverity.warning);
    });

    test('returns critical warning (ftpTestCritical) at 56 days', () {
      final date = DateTime.now().subtract(const Duration(days: 56));
      final warnings = service.generateWarnings(date);

      expect(warnings, hasLength(1));
      expect(warnings.first.type, HealthWarningType.ftpTestCritical);
      expect(warnings.first.severity, HealthWarningSeverity.critical);
    });

    test('returns critical warning for 100 days', () {
      final date = DateTime.now().subtract(const Duration(days: 100));
      final warnings = service.generateWarnings(date);

      expect(warnings, hasLength(1));
      expect(warnings.first.type, HealthWarningType.ftpTestCritical);
      expect(warnings.first.severity, HealthWarningSeverity.critical);
    });

    test('returns exactly 1 warning when applicable', () {
      final date = DateTime.now().subtract(const Duration(days: 56));
      final warnings = service.generateWarnings(date);

      expect(warnings, hasLength(1));
    });

    test('warning contains expected fields', () {
      final date = DateTime.now().subtract(const Duration(days: 28));
      final warnings = service.generateWarnings(date);

      expect(warnings, hasLength(1));
      final warning = warnings.first;
      expect(warning.title, isNotEmpty);
      expect(warning.message, isNotEmpty);
      expect(warning.actionLabel, isNotNull);
      expect(warning.createdAt, isNotNull);
    });
  });
}
