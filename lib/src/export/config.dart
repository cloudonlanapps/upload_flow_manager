import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'entity.dart';
import 'status.dart';

typedef UpdateStatusFn = void Function(int taskId,
    {required UploadStatus status, String? response});
typedef UpdateProgress = void Function(int taskId, double progress);

abstract class UploadHandler {
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

class UploadConfig {
  final Widget Function(String filepath) previewGenerator;
  final String pickerLabelMoreFiles;
  final String pickerLabel;
  final IconData pickerIconData;

  final SliverGridDelegateWithMaxCrossAxisExtent gridDeligate =
      const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 128,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 12);
  UploadHandler uploadManager;

  UploadConfig({
    required this.previewGenerator,
    String? pickerLabel,
    String? pickerLabelMoreFiles,
    IconData? pickerIconData,
    required this.uploadManager,
  })  : pickerLabel = pickerLabel ?? "Select",
        pickerLabelMoreFiles = pickerLabelMoreFiles ?? "Select More",
        pickerIconData = pickerIconData ?? MdiIcons.plus;
}
