import 'package:flutter/material.dart';

import '../default/generate_preview.dart';
import '../default/http_uploader.dart';
import '../default/pick_items.dart';
import '../default/uilabels.dart';
import '../view/uploader_layout.dart';
import '../model/config.dart';
import 'config.dart';

class Uploader extends StatelessWidget {
  final String? url;
  final String? fileField;
  final UploadHandler? uploadHandler;
  final PickItems? pickItems;
  final PreviewGenerator? previewGenerator;
  final UILabels? uiLabels;
  final Function()? sqlite3LibOverrider;

  Uploader({
    super.key,
    this.url,
    this.fileField,
    this.uploadHandler,
    this.pickItems,
    this.previewGenerator,
    this.uiLabels,
    this.sqlite3LibOverrider,
  }) {
    if (url == null && uploadHandler == null) {
      throw Exception("Provide either 'url' or uploadHandler");
    }
  }

  @override
  Widget build(BuildContext context) {
    return UploaderLayout(
      uploadConfig: UploadConfig(
          uploadHandler: uploadHandler ??
              UploadManagerUsingHttp(url: url, fileField: fileField),
          pickItems: pickItems ?? defaultPickItems,
          previewGenerator: previewGenerator ?? defaultGeneratePreview,
          uiLabels: UILabelsNonNullable.fromUILabels(uiLabels),
          sqlite3LibOverrider: sqlite3LibOverrider),
    );
  }
}
