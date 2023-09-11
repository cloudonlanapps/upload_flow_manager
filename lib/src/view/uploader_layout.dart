import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/config.dart';
import '../provider/config.dart';
import '../provider/others.dart';
import '../view/uploader.dart';

class UploaderLayout extends StatelessWidget {
  final UploadConfig uploadConfig;
  const UploaderLayout({
    super.key,
    required this.uploadConfig,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ProviderScope(
          overrides: [
            spaceAvailableProvider.overrideWith((ref) =>
                (constraints.maxHeight >= 150 && constraints.maxWidth >= 200)
                    ? true
                    : false),
            uploadConfigProvider.overrideWith((ref) => uploadConfig)
          ],
          child: const UploaderMain(),
        );
      },
    );
  }
}
