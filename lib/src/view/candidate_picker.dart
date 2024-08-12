import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uploader/uploader.dart';

import '../model/customizer.dart';

import '../provider/customizer.dart';

class CandidatePicker extends ConsumerWidget {
  final String label;
  final IconData iconData;
  const CandidatePicker(
      {super.key, required this.label, required this.iconData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UIViewCustomizer cfg = ref.watch(uiViewCustomizerProvider);

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
