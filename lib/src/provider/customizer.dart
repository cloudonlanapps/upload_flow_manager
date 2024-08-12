import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/customizer.dart';

final uiViewCustomizerProvider = StateProvider<UIViewCustomizer>((ref) {
  throw Exception("Can only be accessed inside uploader context");
});
