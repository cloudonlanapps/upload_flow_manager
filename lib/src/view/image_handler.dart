// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/candidates/candidates.dart';
import '../model/menu.dart';
import '../provider/candidates.dart';
import 'popup_menu.dart';

class DeviceImageHandler extends ConsumerWidget {
  const DeviceImageHandler({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Candidates uploader = ref.watch(uploadCandidatesNotifierProvider);
    final int uploadCandidates =
        uploader.candidates.where((e) => e.isSelected).length;

    if (uploadCandidates == 0) {
      return Container(
        color: Colors.transparent,
      );
    }
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    '$uploadCandidates files to upload',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize:
                            Theme.of(context).textTheme.bodySmall?.fontSize),
                  ),
                ),
                VerticalDivider(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 2)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface)))),
                      child: Text(
                        "Upload Selected",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.fontSize),
                      ),
                      onPressed: () {},
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: AdditionalMenu(
                    menuItems: [
                      AdditionalMenuItem(
                          label: "Select All", onSelection: () {}),
                      AdditionalMenuItem(
                          label: "Select None", onSelection: () {}),
                    ],
                  ))),
        ],
      ),
    );
  }
}
