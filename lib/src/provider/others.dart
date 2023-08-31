import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnSelectFileNotifier extends StateNotifier<bool> {
  OnSelectFileNotifier() : super(false);
  toggle() {
    state = !state;
  }

  set() => state = true;
  clear() => state = false;
}

final onSelectFileProvider =
    StateNotifierProvider<OnSelectFileNotifier, bool>((ref) {
  return OnSelectFileNotifier();
});

final spaceAvailableProvider = StateProvider<bool>((ref) {
  return true;
});
