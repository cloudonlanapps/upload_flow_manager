import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

Future<List<String>> defaultPickItems(
  BuildContext context,
  WidgetRef ref,
) async {
  try {
    final picker = ImagePicker();

    final pickedFileList = await picker.pickMultiImage();

    return pickedFileList.map((e) => e.path).toList();
  } catch (e) {
    // I don't know if this will ever occur.
    // Will it come here when use cancels?
    // if so, we can simply ignore this.
    throw Exception("gPickImage Unexpected Failure");
  }
}
