import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../default/uilabels.dart';
import '../model/candidates/candiate.dart';
import '../model/config.dart';
import '../provider/candidates.dart';
import '../provider/config.dart';
import 'cl_tile.dart';

class UploadCandidateView extends ConsumerWidget {
  final Candidate candidate;

  const UploadCandidateView({
    super.key,
    required this.candidate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UploadConfig cfg = ref.watch(uploadConfigProvider);
    final UILabelsNonNullable uiLabels = cfg.uiLabels;
    return InkWell(
      onTap: () {
        ref
            .read(uploadCandidatesNotifierProvider.notifier)
            .toggleSelection(candidate);
      },
      child: CLTile(
        backgroundColor:
            candidate.isSelected ? Colors.lightGreen.shade100 : null,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 2, left: 2, right: 2, bottom: 2),
                    child: cfg.previewGenerator(context, ref, candidate.path))),
            Positioned(
              bottom: 2,
              right: 8,
              child: Icon(
                candidate.isSelected
                    ? uiLabels.itemIsSelected.icon
                    : uiLabels.itemIsNotSelected.icon,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          ],
        ),
      ),
    );
  }
}

/* 
Dismissible(
      key: ValueKey(child),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 4),
        margin: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 2,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final result = await showOkCancelAlertDialog(
          context: context,
          message: 'Are you sure that you want to delete this story?',
          okLabel: 'Yes',
          cancelLabel: 'No',
        );
        return result == OkCancelResult.ok;
      },
      onDismissed: isConnected ? onDismissed : null,
      child: child,
    )
*/