// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqlite3/sqlite3.dart';

import '../models/entity.dart';
import '../models/entity_db.dart';
import '../models/status.dart';
import '../models/upload_manager.dart';
import '../models/uploadable_item.dart';

class UploadQueueNotifier
    extends StateNotifier<AsyncValue<List<UploadEntity>>> {
  final UploadManager uploadManager;
  late final Database database;
  UploadQueueNotifier({required this.uploadManager, required this.database})
      : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    EntityDB.createTable(database);
    await refresh();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final uploadEntities = EntityDB.load(database);
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

  Future<void> addCandidates(List<UploadableItem> candidates) async {
    state = const AsyncValue.loading();
    await EntityDB.addCandidates(database, candidates);
    final uploadEntities = EntityDB.load(database);
    for (final element in uploadEntities) {
      if (!element.isScheduled) {
        await uploadManager.scheduleUpload(element);
        EntityDB.markAsScheduled(database, element);
      }
    }
    await refresh();
  }

  void updateStatus(
    int taskId, {
    required UploadStatus status,
    String? response,
  }) {
    EntityDB.updateStatusByID(
      database,
      taskId,
      status: status,
      response: response,
    );
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
    'Upload Queue Provider is available only under Uploader Context',
  );
});
