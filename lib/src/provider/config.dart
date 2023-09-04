import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/config.dart';

final uploadConfigProvider = StateProvider<UploadConfig>((ref) {
  throw Exception("Can only be accessed inside uploader context");
});
