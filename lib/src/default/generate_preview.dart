import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget defaultGeneratePreview(
    BuildContext context, WidgetRef ref, String filepath) {
  return Image.file(File(filepath));
}
