import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uploader/uploader.dart';

import '../model/customizer.dart';

import '../provider/customizer.dart';
import '../provider/others.dart';
import 'error.dart';
import 'loading.dart';
import 'uploader_view.dart';

class UploaderLayout extends StatelessWidget {
  final UIViewCustomizer viewCustomizer;
  final UploadConfig uploadConfig;
  const UploaderLayout({
    super.key,
    required this.viewCustomizer,
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
            uiViewCustomizerProvider.overrideWith((ref) => viewCustomizer)
          ],
          child: CLUploader(
            errorBuilder: (err, _) {
              return ErrorView(errorMessage: err.toString());
            },
            loadingBuilder: () => const LoadingView(),
            uploadConfig: uploadConfig,
            builder: () => const UploaderUIView(),
          ),
        );
      },
    );
  }
}

//final UploadConfig cfg = ref.watch(uploadConfigProvider);