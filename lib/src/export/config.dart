// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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

class UILabelsNonNullable {
  final LabeledIcon pickerSelect;
  final LabeledIcon pickerSelectMore;

  final LabeledIcon uploadStatusComplete;
  final LabeledIcon uploadUploadStatusError;

  final LabeledIcon menuSelectAll;
  final LabeledIcon menuSelectNone;
  final LabeledIcon menuRetry;
  final LabeledIcon menuRemoveAll;
  final LabeledIcon menuRemoveCompleted;
  final LabeledIcon itemIsSelected;
  final LabeledIcon itemIsNotSelected;
  final LabeledIcon close;

  final LabeledIcon additionalMenu;

  final LabeledIcon menuUpload;

  UILabelsNonNullable({
    required this.pickerSelect,
    required this.pickerSelectMore,
    required this.uploadStatusComplete,
    required this.uploadUploadStatusError,
    required this.menuSelectAll,
    required this.menuSelectNone,
    required this.menuRetry,
    required this.menuRemoveAll,
    required this.menuRemoveCompleted,
    required this.itemIsSelected,
    required this.itemIsNotSelected,
    required this.close,
    required this.additionalMenu,
    required this.menuUpload,
  });
  factory UILabelsNonNullable.fromUILabels(UILabels? uiLabels) {
    uiLabels ??= UILabels();
    final LabeledIcon pickerSelect =
        LabeledIcon(label: "Select", icon: MdiIcons.plus);
    final LabeledIcon pickerSelectMore =
        LabeledIcon(label: "Select More", icon: MdiIcons.plus);

    final LabeledIcon uploadStatusComplete =
        LabeledIcon(label: "Completed", icon: MdiIcons.checkCircleOutline);
    final LabeledIcon uploadUploadStatusError =
        LabeledIcon(label: "Failed", icon: MdiIcons.alertCircleOutline);

    final LabeledIcon menuSelectAll =
        LabeledIcon(label: "Select All", icon: MdiIcons.selectMultipleMarker);
    final LabeledIcon menuSelectNone =
        LabeledIcon(label: "Select None", icon: MdiIcons.selectionRemove);
    final LabeledIcon menuRetry =
        LabeledIcon(label: "Retry All", icon: MdiIcons.restart);
    final LabeledIcon menuRemoveAll =
        LabeledIcon(label: "Remove All", icon: MdiIcons.selectionRemove);
    final LabeledIcon menuRemoveCompleted = LabeledIcon(
        label: "Remove Completed", icon: MdiIcons.selectionEllipseRemove);
    final LabeledIcon itemIsSelected =
        LabeledIcon(label: "Selected", icon: MdiIcons.checkboxMarkedOutline);
    final LabeledIcon itemIsNotSelected =
        LabeledIcon(label: "Deselected", icon: MdiIcons.checkboxBlankOutline);
    final LabeledIcon close = LabeledIcon(label: "Close", icon: MdiIcons.close);

    final LabeledIcon additionalMenu =
        LabeledIcon(label: "Additional Menu", icon: MdiIcons.dotsHorizontal);

    final LabeledIcon menuUpload =
        LabeledIcon(label: "Upload Selected", icon: MdiIcons.upload);

    return UILabelsNonNullable(
      pickerSelect: uiLabels.pickerSelect ?? pickerSelect,
      pickerSelectMore: uiLabels.pickerSelectMore ?? pickerSelectMore,
      uploadStatusComplete:
          uiLabels.uploadStatusComplete ?? uploadStatusComplete,
      uploadUploadStatusError:
          uiLabels.uploadUploadStatusError ?? uploadUploadStatusError,
      menuSelectAll: uiLabels.menuSelectAll ?? menuSelectAll,
      menuSelectNone: uiLabels.menuSelectNone ?? menuSelectNone,
      menuRetry: uiLabels.menuRetry ?? menuRetry,
      menuRemoveAll: uiLabels.menuRemoveAll ?? menuRemoveAll,
      menuRemoveCompleted: uiLabels.menuRemoveCompleted ?? menuRemoveCompleted,
      itemIsSelected: uiLabels.itemIsSelected ?? itemIsSelected,
      itemIsNotSelected: uiLabels.itemIsNotSelected ?? itemIsNotSelected,
      close: uiLabels.close ?? close,
      additionalMenu: uiLabels.additionalMenu ?? additionalMenu,
      menuUpload: uiLabels.menuUpload ?? menuUpload,
    );
  }
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
