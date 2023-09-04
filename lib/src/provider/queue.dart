// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3/sqlite3.dart';

import '../db/entity_db.dart';
import '../export/entity.dart';
import '../export/status.dart';
import '../export/config.dart';
import '../model/candidates/candiate.dart';

class UploadQueueNotifier
    extends StateNotifier<AsyncValue<List<UploadEntity>>> {
  final UploadHandler uploadManager;
  late final Database database;
  UploadQueueNotifier({required this.uploadManager, required this.database})
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    EntityDB.createTable(database);
    refresh();
  }

  void refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final List<UploadEntity> uploadEntities = EntityDB.load(database);
      return uploadEntities;
    });
  }

  void removeAll() {
    EntityDB.removeAll(database);
    refresh();
  }

  void removeCompleted() {
    EntityDB.removeDownloaded(database);
    refresh();
  }

  void addCandidates(List<Candidate> candidates) async {
    state = const AsyncValue.loading();
    EntityDB.addCandidates(database, candidates);
    final List<UploadEntity> uploadEntities = EntityDB.load(database);
    for (var element in uploadEntities) {
      if (!element.isScheduled) {
        await uploadManager.scheduleUpload(element);
        EntityDB.markAsScheduled(database, element);
      }
    }
    refresh();
  }

  void updateStatus(int taskId,
      {required UploadStatus status, String? response}) {
    EntityDB.updateStatusByID(database, taskId,
        status: status, response: response);
    refresh();
  }

  void updateProgress(int id, double progress) {
    EntityDB.updateProgressByID(database, id, progress);
    refresh();
  }
}

final uploadQueueNotifierProvider =
    StateNotifierProvider<UploadQueueNotifier, AsyncValue<List<UploadEntity>>>((
  ref,
) {
  throw Exception(
      "Upload Queue Provider is available only under Uploader Context");
});
