import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class UploadFlowFilePicker {
  Future<List<String>> pickItems(
    BuildContext context,
    WidgetRef ref,
  );
}
