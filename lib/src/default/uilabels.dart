import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../export/config.dart';

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
