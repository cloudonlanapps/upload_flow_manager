// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uploader/uploader.dart';

import '../model/candidates.dart';
import '../model/customizer.dart';

import '../model/menu.dart';

import '../provider/customizer.dart';
import '../provider/others.dart';

import 'cl_tile.dart';
import 'uploader.dart';
import 'uploader_candidate.dart';
import 'candidate_picker.dart';
import 'menu_view.dart';

class UploadSelector extends ConsumerWidget {
  final List<UploadEntity> queue;
  final Function() onFileSelectionDone;
  final Candidates candidates;
  const UploadSelector({
    super.key,
    required this.queue,
    required this.candidates,
    required this.onFileSelectionDone,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UIViewCustomizer cfg = ref.watch(uiViewCustomizerProvider);
    final uploadCandidates =
        candidates.candidates.where((e) => e.isSelected).toList();
    final spaceAvailable = ref.watch(spaceAvailableProvider);
    final int uploadCandidatesCount =
        candidates.candidates.where((e) => e.isSelected).length;
    final int totalCandidatesCount = candidates.candidates.length;

    Menu menu = Menu(menuItems: [
      if (uploadCandidatesCount > 0)
        MenuItem(
            iconData: cfg.uiLabels.menuUpload.icon,
            label: cfg.uiLabels.menuUpload.label,
            onSelection: () {
              final allUploaded = CLUploader.onUpload(ref, uploadCandidates);
              if (allUploaded) {
                onFileSelectionDone();
              }
            })
    ], additionalMenuItems: [
      if (uploadCandidatesCount < totalCandidatesCount)
        MenuItem(
            iconData: cfg.uiLabels.menuSelectAll.icon,
            label: cfg.uiLabels.menuSelectAll.label,
            onSelection: () {
              CLUploader.onSelectAll(ref);
            }),
      if (uploadCandidatesCount > 0)
        MenuItem(
            iconData: cfg.uiLabels.menuSelectNone.icon,
            label: cfg.uiLabels.menuSelectNone.label,
            onSelection: () {
              CLUploader.onClearSelection(ref);
            })
    ]);

    return Column(
      children: [
        if (queue.isNotEmpty && spaceAvailable)
          Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: onFileSelectionDone,
                  icon: Icon(cfg.uiLabels.close.icon))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (candidates.candidates.isEmpty)
                  CandidatePicker(
                    label: cfg.uiLabels.pickerSelect.label,
                    iconData: cfg.uiLabels.pickerSelect.icon,
                  )
                else
                  CandidatesView(
                    candidates: candidates,
                  ),
                if (candidates.candidates.isNotEmpty && spaceAvailable)
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: MenuView(menu: menu)),
              ],
            ),
          ),
        ),
        if (totalCandidatesCount > 0)
          Row(
            children: [
              Flexible(
                child: SizedBox(
                  height: 32,
                  child: Center(
                      child: Text(
                    "$uploadCandidatesCount of $totalCandidatesCount Selected to upload", //TODO: Part of label !
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        overflow: TextOverflow.ellipsis),
                  )),
                ),
              ),
              if (candidates.candidates.isNotEmpty && !spaceAvailable)
                MenuView(
                    menu: Menu(menuItems: [], additionalMenuItems: [
                  ...menu.menuItems,
                  if (menu.additionalMenuItems?.isNotEmpty ?? false)
                    ...menu.additionalMenuItems!,
                  MenuItem(
                      label: cfg.uiLabels.close.label,
                      iconData: cfg.uiLabels.close.icon,
                      onSelection: onFileSelectionDone)
                ]))
            ],
          )
      ],
    );
  }
}

class CandidatesView extends ConsumerWidget {
  const CandidatesView({super.key, required this.candidates});
  final Candidates candidates;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UIViewCustomizer cfg = ref.watch(uiViewCustomizerProvider);

    //uploader.candidates.length + (candiatePicker != null ? 1 : 0,);
    return GridView.builder(
        gridDelegate: cfg.gridDeligate,
        itemCount: candidates.candidates.length + 1,
        itemBuilder: (BuildContext ctx, index) {
          if (index == candidates.candidates.length) {
            return CLTile(
                child: CandidatePicker(
              label: cfg.uiLabels.pickerSelectMore.label,
              iconData: cfg.uiLabels.pickerSelectMore.icon,
            ));
          }
          final candidate = candidates.candidates[index];
          return UploadCandidateView(
            candidate: candidate,
          );
        });
  }
}
