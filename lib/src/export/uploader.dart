import 'package:flutter/material.dart';

import '../view/uploader.dart';
import 'config.dart';

class Uploader extends StatelessWidget {
  final UploadConfig config;
  const Uploader({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return UploaderMain(
      cfg: config,
    );
  }
}
