import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../export/config.dart';
import '../provider/others.dart';
import '../view/uploader.dart';

class UploaderLayout extends StatelessWidget {
  const UploaderLayout({
    super.key,
    required this.config,
  });

  final UploadConfig config;

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
