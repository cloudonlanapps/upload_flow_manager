import 'package:flutter/foundation.dart';

import 'entity.dart';
import 'status.dart';
import 'uploader_config.dart';

typedef UpdateStatusFn = void Function(
  int taskId, {
  required UploadStatus status,
  String? response,
});
typedef UpdateProgress = void Function(int taskId, double progress);

abstract class UploadManager {
  UploadManager({required this.config});
  UploadConfig config;
  UpdateStatusFn? updateStatus;
  UpdateProgress? updateProgress;

  void onSubscribe({
    UpdateStatusFn? updateStatus,
    UpdateProgress? updateProgress,
  }) {
    this.updateStatus = updateStatus;
    this.updateProgress = updateProgress;
  }

  void onCancelSubscribe() {
    updateStatus = null;
    updateProgress = null;
  }

  @mustCallSuper
  void dispose() {
    onCancelSubscribe();
  }

  Future<void> scheduleUpload(UploadEntity entity);
}
