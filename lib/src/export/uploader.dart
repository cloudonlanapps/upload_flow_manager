import 'package:flutter/material.dart';

import '../default/generate_preview.dart';
import '../default/http_uploader.dart';
import '../default/pick_items.dart';
import '../view/uploader_layout.dart';
import '../model/config.dart';
import 'upload_flow_callbacks.dart';

class Uploader extends StatelessWidget {
  final String? url;
  final String? fileField;
  final UploadHandler? uploadHandler;
  final PickItems? pickItems;
  final GeneratePreview? generatePreview;
  final UILabels? uiLabels;

  Uploader({
    super.key,
    this.url,
    this.fileField,
    this.uploadHandler,
    this.pickItems,
    this.generatePreview,
    this.uiLabels,
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
          previewGenerator: generatePreview ?? defaultGeneratePreview,
          uiLabels: UILabelsNonNullable.fromUILabels(uiLabels)),
    );
  }
}
