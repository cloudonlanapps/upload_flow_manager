// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../upload_flow_manager.dart';
import '../default/uilabels.dart';
import '../model/candidates/candidates.dart';
import '../model/config.dart';
import '../model/menu.dart';
import '../provider/candidates.dart';
import '../provider/config.dart';
import '../provider/others.dart';
import '../provider/queue.dart';
import 'entity_view.dart';
import 'error.dart';
import 'loading.dart';
import 'upload_selector.dart';
import 'menu_view.dart';

class UploaderView extends ConsumerWidget {
  const UploaderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<UploadEntity>> uploadQueueAsync =
        ref.watch(uploadQueueNotifierProvider);
    final Candidates uploader = ref.watch(uploadCandidatesNotifierProvider);
    final selectFiles = ref.watch(onSelectFileProvider);

    return uploadQueueAsync.when(data: (queue) {
      if (selectFiles || queue.isEmpty) {
        return UploadSelector(
          queue: queue,
          onFileSelectionDone: ref.read(onSelectFileProvider.notifier).clear,
          uploader: uploader,
        );
      }
      return _UploaderView(
          queue: queue,
          onSelectFiles: ref.read(onSelectFileProvider.notifier).set);
    }, error: (err, _) {
      return const ErrorView(errorMessage: "DB Access Failed?");
    }, loading: () {
      return const LoadingView();
    });
  }
}

class _UploaderView extends ConsumerWidget {
  final List<UploadEntity> queue;
  final Function() onSelectFiles;
  const _UploaderView({required this.queue, required this.onSelectFiles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UILabelsNonNullable uiLabels =
        ref.watch(uploadConfigProvider.select((value) => value.uiLabels));
    final viewImage = ref.watch(imageSelectionProvider);
    final spaceAvailable = ref.watch(spaceAvailableProvider);
    final UploadConfig cfg = ref.watch(uploadConfigProvider);

    Menu menu = Menu(menuItems: [
      MenuItem(
          iconData: uiLabels.menuRetry.icon,
          label: uiLabels.menuRetry.label,
          onSelection: () {
            ref
                .read(uploadQueueNotifierProvider.notifier)
                .refresh(); // TODO: Change to retry
          }),
      MenuItem(
          iconData: uiLabels.pickerSelectMore.icon,
          label: uiLabels.pickerSelectMore.label,
          onSelection: () async {
            List<String> candidates = await cfg.pickItems(context, ref);
            if (candidates.isNotEmpty) {
              onSelectFiles();
              ref
                  .read(uploadCandidatesNotifierProvider.notifier)
                  .add(candidates);
            }
          }),
    ], additionalMenuItems: [
      if (queue.any((element) => element.uploadStatus.isFinalState) ||
          queue.any((element) => element.uploadStatus == UploadStatus.enqueued))
        MenuItem(
            iconData: uiLabels.menuRemoveAll.icon,
            label: uiLabels.menuRemoveAll.label,
            onSelection: () {
              ref.read(uploadQueueNotifierProvider.notifier).removeAll();
            }),
      if (queue.any((element) => element.uploadStatus.isFinalState))
        MenuItem(
            iconData: uiLabels.menuRemoveCompleted.icon,
            label: uiLabels.menuRemoveCompleted.label,
            onSelection: () {
              ref.read(uploadQueueNotifierProvider.notifier).removeCompleted();
            })
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
                          tag: queue[index].path,
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
                            .onBackground
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
