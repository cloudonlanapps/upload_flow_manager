import 'package:sqlite3/sqlite3.dart';

import '../export/entity.dart';
import '../export/status.dart';
import '../model/candidates/candiate.dart';

extension EntityDB on UploadEntity {
  static const _tableName = 'upload_entities';
  static UploadEntity entityFromDB(Row row) {
    if (row['id'] == null) throw Exception("id failed");
    if (row['path'] == null) throw Exception("path failed");
    if (row['aux'] == null) throw Exception("aux failed");
    if (row['time'] == null) throw Exception("time failed");
    if (row['uploadStatus'] == null) throw Exception("uploadStatus failed");
    if (row['progress'] == null) throw Exception("progress failed");
    if (row['isScheduled'] == null) throw Exception("isScheduled failed");

    return UploadEntity(
      id: row['id'],
      path: row['path'],
      aux: row['aux'],
      uploadStatus: UploadStatus.values[row['uploadStatus']],
      time: DateTime.fromMillisecondsSinceEpoch(row['time']),
      progress: row['progress'],
      serverResponse: row['serverResponse'],
      isScheduled: row['isScheduled'] == 0 ? false : true,
    );
  }

  dynamic get asRow {
    return [
      path,
      aux,
      time.microsecondsSinceEpoch,
      uploadStatus.index,
      progress,
      serverResponse,
      isScheduled
    ];
  }

  static const String _requiredColumns =
      "path, aux, time, uploadStatus, progress, serverResponse, isScheduled";

  static List<String> get requiredColumns =>
      ['id', ..._requiredColumns.split(', ')];
  static String get rowOrder {
    return '($_requiredColumns) VALUES (${_requiredColumns.split(', ').map((e) => '?').join(", ")})';
  }

  static String get tableSyntax {
    return """(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                path TEXT NOT NULL UNIQUE,
                aux TEXT,
                time INTEGER NOT NULL,
                uploadStatus INTEGER NOT NULL,
                progress FLOAT NOT NULL,
                serverResponse STRING,
                isScheduled BOOL NOT NULL
            )""";
  }

  static void createTable(Database db) {
    try {
      if (!doesTableExist(db)) {
        db.execute('''
            CREATE TABLE IF NOT EXISTS $_tableName ${EntityDB.tableSyntax};
    ''');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static bool doesTableExist(Database db) {
    final result = db.select(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [_tableName]);
    if (result.isEmpty) {
      return false;
    }

    return doesTableHaveColumns(db);
  }

  static bool doesTableHaveColumns(Database db) {
    final result = db.select("PRAGMA table_info($_tableName)");
    final existingColumns =
        result.map((row) => row['name'].toString()).toList();

    final columnsOK =
        EntityDB.requiredColumns.every((col) => existingColumns.contains(col));

    if (!columnsOK) {
      throw Exception("""Some columns are missing, delete table to proceed,
      ${EntityDB.requiredColumns.where((element) => !existingColumns.contains(element)).toList()}
      """);
    }
    if (existingColumns.length != EntityDB.requiredColumns.length) {
      throw Exception("Additional columns found, check version");
    }
    return true;
  }

  static List<UploadEntity> load(Database db) {
    final ResultSet resultSet = db.select('''
      SELECT * FROM $_tableName
      ORDER BY id ASC;
      ''');
    return resultSet.map((e) => EntityDB.entityFromDB(e)).toList();
  }

  static int count(Database db, {UploadStatus? status}) {
    final wh = status == null ? "" : "WHERE status = ${status.index}";
    final result = db.select('SELECT COUNT(*) FROM $_tableName $wh;');
    assert(result.length == 1);

    return result[0].values.first as int;
  }

  static void resetIfEmpty(db) {
    if (count(db) == 0) {
      deleteTable(db);
      createTable(db);
    }
  }

  static void deleteTable(Database db) {
    db.execute("""
        DROP TABLE IF EXISTS $_tableName;
      """);
  }

  static Future<void> addCandidates(
      Database db, List<Candidate> candidates) async {
    resetIfEmpty(db);
    int time = (DateTime.now()).millisecondsSinceEpoch;

    for (var i = 0; i < candidates.length; i++) {
      final file = candidates[i].path;

      final UploadEntity entity = UploadEntity(
          uploadStatus: UploadStatus.enqueued,
          path: file,
          aux: '',
          time: DateTime.fromMillisecondsSinceEpoch(time),
          progress: 0,
          serverResponse: null,
          isScheduled: false);
      final insertStmt =
          db.prepare('INSERT OR IGNORE INTO $_tableName ${EntityDB.rowOrder}');
      insertStmt.execute(entity.asRow);

      insertStmt.dispose();
    }
  }

  static void updateStatus(Database db, int id, UploadStatus status) {
    db.execute('''
      UPDATE $_tableName      
      SET status = ?      
      WHERE id = ?
    ''', [status.index, id]);
  }

  static void removeDownloaded(Database db) {
    final statusToClear = [UploadStatus.complete.index];
    db.execute(
      'DELETE FROM $_tableName WHERE uploadStatus IN (${statusToClear.join(', ')})',
    );
  }

  static void removeAll(Database db) {
    db.execute('''
      DELETE  FROM $_tableName
    ''');
  }

  static markAsScheduled(Database db, UploadEntity entity) {
    db.execute('''
      UPDATE $_tableName      
      SET isScheduled = ?
      WHERE id = ?
    ''', [true, entity.id]);
  }

  static updateStatusByID(Database db, int taskId,
      {required UploadStatus status, String? response}) {
    if (response == null) {
      db.execute('''
      UPDATE $_tableName      
      SET uploadStatus = ?
      
      WHERE id = ?
    ''', [status.index, taskId]);
    } else {
      db.execute('''
      UPDATE $_tableName      
      SET uploadStatus = ?,
      serverResponse = ?
      WHERE id = ?
    ''', [status.index, response, taskId]);
    }
  }

  static updateProgressByID(Database db, int id, double progress) {
    db.execute('''
      UPDATE $_tableName      
      SET progress = ?
      WHERE id = ?
    ''', [progress, id]);
  }
}
