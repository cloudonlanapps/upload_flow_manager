// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../default/uilabels.dart';
import '../export/config.dart';

class UploadConfig {
  final SliverGridDelegateWithMaxCrossAxisExtent gridDeligate =
      const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 128,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 12);
  final UploadHandler uploadHandler;
  final PickItems pickItems;
  final PreviewGenerator previewGenerator;
  final UILabelsNonNullable uiLabels;
  final Function()? sqlite3LibOverrider;
  UploadConfig({
    required this.uploadHandler,
    required this.pickItems,
    required this.previewGenerator,
    required this.uiLabels,
    this.sqlite3LibOverrider,
  });
}
