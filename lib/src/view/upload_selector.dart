// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../export/config.dart';
import '../export/entity.dart';
import '../model/candidates/candidates.dart';
import '../model/menu.dart';
import '../provider/candidates.dart';
import '../provider/queue.dart';
import 'cl_tile.dart';
import 'uploader_candidate.dart';
import 'candidate_picker.dart';
import 'menu_view.dart';

class UploadSelector extends ConsumerWidget {
  final List<UploadEntity> queue;
  final Function() onFileSelectionDone;
  final Candidates uploader;
  const UploadSelector({
    super.key,
    required this.queue,
    required this.uploader,
    required this.onFileSelectionDone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadCandidates =
        uploader.candidates.where((e) => e.isSelected).toList();

    final int uploadCandidatesCount =
        uploader.candidates.where((e) => e.isSelected).length;
    final int totalCandidatesCount = uploader.candidates.length;

    Menu menu = Menu(menuItems: [
      if (uploadCandidatesCount > 0)
        MenuItem(
            iconData: MdiIcons.upload,
            onSelection: () {
              ref
                  .read(uploadQueueNotifierProvider.notifier)
                  .addCandidates(uploadCandidates);
              final allUploaded = ref
                  .read(uploadCandidatesNotifierProvider.notifier)
                  .removeSelected();
              if (allUploaded) {
                onFileSelectionDone();
              }
            })
    ], additionalMenuItems: [
      if (uploadCandidatesCount < totalCandidatesCount)
        AdditionalMenuItem(
            label: "Select All",
            onSelection: () {
              ref.read(uploadCandidatesNotifierProvider.notifier).selectAll();
            }),
      if (uploadCandidatesCount > 0)
        AdditionalMenuItem(
            label: "Select None",
            onSelection: () {
              ref.read(uploadCandidatesNotifierProvider.notifier).selectNone();
            })
    ]);

    return Column(
      children: [
        if (queue.isNotEmpty)
          Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: onFileSelectionDone, icon: Icon(MdiIcons.close))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              elevation: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (uploader.candidates.isEmpty)
                    const CandidatePicker()
                  else
                    const CandidatesView(),
                  if (uploader.candidates.isNotEmpty)
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: MenuView(menu: menu)),
                ],
              ),
            ),
          ),
        ),
        if (totalCandidatesCount > 0)
          Container(
            height: 32,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.secondary),
            child: Center(
                child: Text(
              "$uploadCandidatesCount of $totalCandidatesCount Selected to upload",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            )),
          )
      ],
    );
  }
}

class CandidatesView extends ConsumerWidget {
  const CandidatesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UploadConfig cfg = ref.watch(uploadConfigProvider);
    final Candidates uploader = ref.watch(uploadCandidatesNotifierProvider);
    //uploader.candidates.length + (candiatePicker != null ? 1 : 0,);
    return GridView.builder(
        gridDelegate: cfg.gridDeligate,
        itemCount: uploader.candidates.length + 1,
        itemBuilder: (BuildContext ctx, index) {
          if (index == uploader.candidates.length) {
            return const CLTile(child: CandidatePicker());
          }
          final candidate = uploader.candidates[index];
          return UploadCandidateView(
            candidate: candidate,
          );
        });
  }
}
