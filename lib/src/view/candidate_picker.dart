import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/config.dart';
import '../provider/candidates.dart';
import '../provider/config.dart';

class CandidatePicker extends ConsumerWidget {
  final String label;
  final IconData iconData;
  const CandidatePicker(
      {super.key, required this.label, required this.iconData});

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
                List<String> candidates = await cfg.pickItems(context, ref);
                ref
                    .read(uploadCandidatesNotifierProvider.notifier)
                    .add(candidates);
              },
              icon: Icon(iconData),
            ),
          ),
          Text(label),
        ],
      ),
    );
  }
}
