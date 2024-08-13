import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../impl/http_uploader.dart';
import '../models/upload_manager.dart';
import '../models/uploader_config.dart';

class UploaderNotifier extends StateNotifier<UploadManager> {
  UploaderNotifier(UploadConfig config)
      : super(UploadManagerUsingHttp(config: config));
}

final uploaderProvider =
    StateNotifierProvider.family<UploaderNotifier, UploadManager, UploadConfig>(
        (ref, config) {
  return UploaderNotifier(config);
});
