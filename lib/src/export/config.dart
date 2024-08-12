// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

typedef PickItems = Future<List<String>> Function(
  BuildContext context,
  WidgetRef ref,
);

typedef PreviewGenerator = Widget Function(
    BuildContext context, WidgetRef ref, String filepath);
