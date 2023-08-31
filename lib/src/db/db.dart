import 'dart:ffi';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3/open.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PrivateDB {
  static Future<String> get databaseFileName async {
    final appDir = await getApplicationDocumentsDirectory();
    return p.join(appDir.path, 'upload_flow_manager.db');
  }

  static DynamicLibrary _openOnLinux() {
    //final scriptDir = File(Platform.script.toFilePath()).parent;
    final libraryNextToScript =
        File(join('/lib/x86_64-linux-gnu/', 'libsqlite3.so.0'));
    return DynamicLibrary.open(libraryNextToScript.path);
  }

  static Future<Database> getDB() async {
    open.overrideFor(OperatingSystem.linux, PrivateDB._openOnLinux);
    final Database db;
    try {
      db = sqlite3.open(await PrivateDB.databaseFileName);
    } catch (e) {
      throw Exception("Failed to open DB");
    }

    return db;
  }
}

final dbProvider = FutureProvider<Database>((ref) async {
  final db = await PrivateDB.getDB();
  ref.onDispose(() {
    db.dispose();
  });
  return db;
});
