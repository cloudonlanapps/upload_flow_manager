import 'package:flutter/foundation.dart';

import '../export/entity.dart';
import 'status.dart';

typedef UpdateStatusFn = void Function(int taskId,
    {required UploadStatus status, String? response});
typedef UpdateProgress = void Function(int taskId, double progress);

abstract class UploadHandler {
  late String url;
  late String fileField;
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

  Future<void> scheduleUpload(UploadEntity entity);
}

@immutable
class UploadConfig {
  final String? url;
  final String? fileField;
  final UploadHandler? uploadHandler;
  final Function()? sqlite3LibOverrider;
  const UploadConfig(
      {this.uploadHandler,
      required this.sqlite3LibOverrider,
      this.url,
      this.fileField});
}
