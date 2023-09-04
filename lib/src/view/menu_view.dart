// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../default/uilabels.dart';
import '../model/menu.dart';
import '../provider/config.dart';
import 'popup_menu.dart';

class MenuView extends ConsumerWidget {
  final Menu menu;
  const MenuView({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UILabelsNonNullable uiLabels =
        ref.watch(uploadConfigProvider.select((value) => value.uiLabels));

    return Center(
      child: Container(
        margin:
            menu.menuItems.isNotEmpty ? const EdgeInsets.only(bottom: 4) : null,
        padding:
            menu.menuItems.isNotEmpty ? const EdgeInsets.only(bottom: 4) : null,
        height: 32,
        decoration: menu.menuItems.isNotEmpty
            ? ShapeDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(200),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.primary)))
            : BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(200),
              ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var item in menu.menuItems)
              IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: item.onSelection,
                  icon: Icon(
                    item.iconData,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
            if (menu.additionalMenuItems != null &&
                menu.additionalMenuItems!.isNotEmpty)
              AdditionalMenu(
                iconAdditionalMenu: uiLabels.additionalMenu.icon,
                menuItems: menu.additionalMenuItems!,
              )
          ],
        ),
      ),
    );
  }
}
