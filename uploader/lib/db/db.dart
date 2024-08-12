import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PrivateDB {
  static Future<String> get databaseFileName async {
    final appDir = await getApplicationDocumentsDirectory();
    return p.join(appDir.path, 'upload_flow_manager.db');
  }

  static Future<Database> getDB(Function()? sqlite3LibOverrider) async {
    sqlite3LibOverrider?.call();
    final Database db;
    try {
      db = sqlite3.open(await PrivateDB.databaseFileName);
    } catch (e) {
      throw Exception("Failed to open DB");
    }

    return db;
  }
}

final dbProvider = FutureProvider.family<Database, Function()?>(
    (ref, sqlite3LibOverrider) async {
  final db = await PrivateDB.getDB(sqlite3LibOverrider);
  ref.onDispose(() {
    db.dispose();
  });
  return db;
});
