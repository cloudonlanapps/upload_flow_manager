import 'package:flutter/foundation.dart';

@immutable
class UploadConfig {
  const UploadConfig({
    required this.url,
    required this.fileField,
    this.sqlite3LibOverrider,
  });
  final String url;
  final String fileField;
  final void Function()? sqlite3LibOverrider;
}
