import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../export/config.dart';
import '../provider/candidates.dart';
import '../provider/queue.dart';

class CandidatePicker extends ConsumerWidget {
  const CandidatePicker({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UploadConfig cfg = ref.watch(uploadConfigProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: IconButton(
              onPressed: () async {
                List<String> candidates = await cfg.picker(context, ref);
                ref
                    .read(uploadCandidatesNotifierProvider.notifier)
                    .add(candidates);
              },
              icon: Icon(cfg.pickerIconData),
            ),
          ),
          Text(cfg.pickerLabel),
        ],
      ),
    );
  }
}
