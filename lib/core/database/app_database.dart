import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/training_session_table.dart';
import 'tables/data_point_table.dart';
import 'daos/session_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TrainingSessions, DataPoints])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Für Tests
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  // DAO Zugriff (lazy initialized)
  late final SessionDao sessionDao = SessionDao(this);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Zukünftige Migrationen hier
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'vibed_kickr.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
