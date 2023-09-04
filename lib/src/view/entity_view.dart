import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../default/uilabels.dart';
import '../model/config.dart';

import '../export/entity.dart';
import '../export/status.dart';
import '../provider/config.dart';
import 'cl_tile.dart';

class UploadEntityView extends ConsumerWidget {
  final UploadEntity entity;

  const UploadEntityView({
    super.key,
    required this.entity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /* previewGenerator: CLImageView(clImage: candidate.image)*/
    final UploadConfig cfg = ref.watch(uploadConfigProvider);
    return InkWell(
      onTap: () {
        ref.read(imageSelectionProvider.notifier).onTapImage(entity.path);
      },
      child: CLTile(
        //backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 2, left: 2, right: 2, bottom: 2),
                    child: cfg.previewGenerator(context, ref, entity.path))),
            Positioned(
              right: 0,
              bottom: 0,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: UploadProgress(entity: entity),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UploadProgress extends ConsumerWidget {
  final UploadEntity entity;
  const UploadProgress({
    super.key,
    required this.entity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UploadConfig cfg = ref.watch(uploadConfigProvider);
    return Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)
            //more than 50% of width makes circle
            ),
        child: getWidget(context, cfg.uiLabels));
  }

  Widget getWidget(BuildContext context, UILabelsNonNullable uiLabels) {
    return GestureDetector(
      onTap: () async {
        if (entity.serverResponse != null) {
          {
            await showOkAlertDialog(
              context: context,
              message: entity.serverResponse,
            );
          }
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: switch (entity.uploadStatus) {
          UploadStatus.enqueued => JumpingDotsProgressIndicator(
              fontSize: 20.0, color: Theme.of(context).colorScheme.primary),
          UploadStatus.running => CircularPercentIndicator(
              radius: 12.0,
              lineWidth: 4.0,
              animation: true,
              percent: entity.progress,
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Theme.of(context).colorScheme.primary,
            ),
          UploadStatus.complete => Icon(uiLabels.uploadStatusComplete.icon,
              color: Theme.of(context).colorScheme.primary),

          // Error scenarios
          UploadStatus.notFound => Icon(uiLabels.uploadUploadStatusError.icon,
              color: Theme.of(context).colorScheme.error),
          UploadStatus.failed => Icon(uiLabels.uploadUploadStatusError.icon,
              color: Theme.of(context).colorScheme.error),
          UploadStatus.canceled => Icon(uiLabels.uploadUploadStatusError.icon,
              color: Theme.of(context)
                  .colorScheme
                  .error), // Currently not supported
          UploadStatus.waitingToRetry => Icon(
              uiLabels.uploadUploadStatusError.icon,
              color: Theme.of(context).colorScheme.error),
          UploadStatus.paused => Icon(uiLabels.uploadUploadStatusError.icon,
              color: Theme.of(context).colorScheme.error),
        },
      ),
    );
  }
}

class ImageSelectionNotifier extends StateNotifier<String?> {
  ImageSelectionNotifier() : super(null);

  onTapImage(String path) {
    state = path;
  }

  onCancelImage() {
    state = null;
  }
}

final imageSelectionProvider =
    StateNotifierProvider<ImageSelectionNotifier, String?>((ref) {
  return ImageSelectionNotifier();
});
