// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upload_flow_manager/src/view/candidate_picker.dart';
import 'package:uploader/uploader.dart';

import '../default/uilabels.dart';

import '../model/candidates.dart';
import '../model/customizer.dart';
import '../model/menu.dart';

import '../provider/customizer.dart';
import '../provider/others.dart';

import 'entity_view.dart';

import 'upload_selector.dart';
import 'menu_view.dart';
import 'uploader.dart';

class UploaderUIView extends ConsumerWidget {
  const UploaderUIView(
      {super.key,
      required this.candidates,
      required this.queue,
      required this.onRetry,
      required this.onRemoveAll,
      required this.onRemoveCompleted});
  final Candidates candidates;
  final List<UploadEntity> queue;
  final void Function() onRetry;
  final void Function() onRemoveAll;
  final void Function() onRemoveCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectFiles = ref.watch(onSelectFileProvider);
    if (selectFiles || queue.isEmpty) {
      return UploadSelector(
        queue: queue,
        onFileSelectionDone: ref.read(onSelectFileProvider.notifier).clear,
        candidates: candidates,
      );
    }
    return _UploaderView(
        queue: queue,
        onRetry: onRetry,
        onRemoveAll: onRemoveAll,
        onRemoveCompleted: onRemoveCompleted,
        onSelectFiles: ref.read(onSelectFileProvider.notifier).set);
  }
}

class _UploaderView extends ConsumerWidget {
  final List<UploadEntity> queue;
  final Function() onSelectFiles;
  final void Function() onRetry;
  final void Function() onRemoveAll;
  final void Function() onRemoveCompleted;
  const _UploaderView(
      {required this.queue,
      required this.onSelectFiles,
      required this.onRetry,
      required this.onRemoveAll,
      required this.onRemoveCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UILabelsNonNullable uiLabels =
        ref.watch(uiViewCustomizerProvider.select((value) => value.uiLabels));
    final viewImage = ref.watch(imageSelectionProvider);
    final spaceAvailable = ref.watch(spaceAvailableProvider);
    final UIViewCustomizer cfg = ref.watch(uiViewCustomizerProvider);

    Menu menu = Menu(menuItems: [
      MenuItem(
          iconData: uiLabels.menuRetry.icon,
          label: uiLabels.menuRetry.label,
          onSelection: onRetry),
      MenuItem(
          iconData: uiLabels.pickerSelectMore.icon,
          label: uiLabels.pickerSelectMore.label,
          onSelection: () async {
            List<MediaItem> candidates = (await cfg.pickItems(context, ref))
                .map((e) => MediaItem(e))
                .toList();
            if (candidates.isNotEmpty) {
              onSelectFiles();
              CLUploader.addCandidates(ref, candidates);
            }
          }),
    ], additionalMenuItems: [
      if (queue.any((element) => element.uploadStatus.isFinalState) ||
          queue.any((element) => element.uploadStatus == UploadStatus.enqueued))
        MenuItem(
            iconData: uiLabels.menuRemoveAll.icon,
            label: uiLabels.menuRemoveAll.label,
            onSelection: onRemoveAll),
      if (queue.any((element) => element.uploadStatus.isFinalState))
        MenuItem(
            iconData: uiLabels.menuRemoveCompleted.icon,
            label: uiLabels.menuRemoveCompleted.label,
            onSelection: onRemoveCompleted)
    ]);

    return Column(
      children: [
        Flexible(
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: GridView.builder(
                      gridDelegate: cfg.gridDeligate,
                      itemCount: queue.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return Hero(
                          tag: queue[index].itemJson,
                          child: UploadEntityView(
                            entity: queue[index],
                          ),
                        );
                      })),
              if (spaceAvailable)
                Positioned(
                    bottom: 0, left: 0, right: 0, child: MenuView(menu: menu)),
              if (viewImage != null)
                GestureDetector(
                  onTap: () {
                    ref.read(imageSelectionProvider.notifier).onCancelImage();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(128)),
                    child: Center(
                      child: Hero(
                        tag: viewImage,
                        child: AspectRatio(
                            aspectRatio: 1.0,
                            child:
                                cfg.previewGenerator(context, ref, viewImage)),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        if (!spaceAvailable)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: MenuView(
                      menu: Menu(menuItems: [], additionalMenuItems: [
                    ...menu.menuItems,
                    if (menu.additionalMenuItems?.isNotEmpty ?? false)
                      ...menu.additionalMenuItems!
                  ]))),
            ],
          ),
      ],
    );
  }
}
