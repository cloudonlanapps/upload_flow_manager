import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:uploader/uploader.dart';

import '../default/generate_preview.dart';

import '../default/pick_items.dart';
import '../default/uilabels.dart';
import '../model/candidates.dart';
import '../provider/customizer.dart';
import '../provider/others.dart';
import '../view/error.dart';
import '../view/loading.dart';

import '../model/customizer.dart';
import '../view/uploader.dart';
import '../view/uploader_view.dart';
import 'config.dart';

class MediaUploader extends StatelessWidget {
  final String? url;
  final String? fileField;

  final PickItems? pickItems;
  final PreviewGenerator? previewGenerator;
  final UILabels? uiLabels;
  final Function()? sqlite3LibOverrider;

  MediaUploader({
    super.key,
    this.url,
    this.fileField,
    this.pickItems,
    this.previewGenerator,
    this.uiLabels,
    this.sqlite3LibOverrider,
  }) {
    if (url == null) {
      throw Exception("Provide either 'url' or uploadHandler");
    }
  }

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
            uiViewCustomizerProvider.overrideWith((ref) => UIViewCustomizer(
                  pickItems: pickItems ?? defaultPickItems,
                  previewGenerator: previewGenerator ?? defaultGeneratePreview,
                  uiLabels: UILabelsNonNullable.fromUILabels(uiLabels),
                ))
          ],
          child: CLUploader(
            errorBuilder: (err, _) {
              return ErrorView(errorMessage: err.toString());
            },
            loadingBuilder: () => const LoadingView(),
            uploadConfig: UploadConfig(
                url: url!,
                fileField: fileField!,
                sqlite3LibOverrider: sqlite3LibOverrider),
            builder: (
                    {required Candidates candidates,
                    required List<UploadEntity> queue,
                    required void Function() onRetry,
                    required void Function() onRemoveAll,
                    required void Function() onRemoveCompleted}) =>
                UploaderUIView(
              candidates: candidates,
              queue: queue,
              onRetry: onRetry,
              onRemoveAll: onRemoveAll,
              onRemoveCompleted: onRemoveCompleted,
            ),
          ),
        );
      },
    );
  }
}
