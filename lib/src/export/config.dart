// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'entity.dart';
import 'status.dart';

class LabeledIcon {
  String label;
  IconData icon;
  LabeledIcon({
    required this.label,
    required this.icon,
  });
}

class UILabels {
  final LabeledIcon? pickerSelect;
  final LabeledIcon? pickerSelectMore;

  final LabeledIcon? uploadStatusComplete;
  final LabeledIcon? uploadUploadStatusError;

  final LabeledIcon? menuSelectAll;
  final LabeledIcon? menuSelectNone;
  final LabeledIcon? menuRetry;
  final LabeledIcon? menuRemoveAll;
  final LabeledIcon? menuRemoveCompleted;
  final LabeledIcon? itemIsSelected;
  final LabeledIcon? itemIsNotSelected;
  final LabeledIcon? close;

  final LabeledIcon? additionalMenu;

  final LabeledIcon? menuUpload;

  UILabels({
    this.pickerSelect,
    this.pickerSelectMore,
    this.uploadStatusComplete,
    this.uploadUploadStatusError,
    this.menuSelectAll,
    this.menuSelectNone,
    this.menuRetry,
    this.menuRemoveAll,
    this.menuRemoveCompleted,
    this.itemIsSelected,
    this.itemIsNotSelected,
    this.close,
    this.additionalMenu,
    this.menuUpload,
  });
}

typedef UpdateStatusFn = void Function(int taskId,
    {required UploadStatus status, String? response});
typedef UpdateProgress = void Function(int taskId, double progress);

typedef PickItems = Future<List<String>> Function(
  BuildContext context,
  WidgetRef ref,
);

typedef PreviewGenerator = Widget Function(
    BuildContext context, WidgetRef ref, String filepath);

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
