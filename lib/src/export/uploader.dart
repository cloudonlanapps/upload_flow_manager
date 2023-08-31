import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../default/default_picker.dart';
import '../view/uploader_layout.dart';
import 'config.dart';
import 'picker.dart';

class Uploader extends StatelessWidget {
  final UploadConfig config;
  final UploadFlowFilePicker? picker;
  const Uploader({
    super.key,
    required this.config,
    this.picker,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(overrides: [
      if (picker != null)
        uploadFlowFilePickerProvider.overrideWith((ref) => picker!)
    ], child: UploaderLayout(config: config));
  }
}

final uploadFlowFilePickerProvider = StateProvider<UploadFlowFilePicker>((ref) {
  return UploadFlowFilePickerDefaut();
});
