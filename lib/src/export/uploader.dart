import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/others.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight >= 150 && constraints.maxWidth >= 200) {
          return UploaderMain(cfg: config);
        } else {
          return ProviderScope(
            overrides: [spaceAvailableProvider.overrideWith((ref) => false)],
            child: UploaderMain(cfg: config),
          );
        }
      },
    );
  }
}
