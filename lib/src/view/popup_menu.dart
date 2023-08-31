// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../model/menu.dart';

class AdditionalMenu extends StatelessWidget {
  final List<MenuItem> menuItems;
  const AdditionalMenu({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      icon: Icon(MdiIcons.dotsHorizontal),
      color: Theme.of(context).colorScheme.onPrimary,
      padding: const EdgeInsets.all(0),
      onSelected: (MenuItem item) => item.onSelection(),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
        for (var item in menuItems)
          PopupMenuItem<MenuItem>(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              textStyle: Theme.of(context).textTheme.labelMedium,
              value: item,
              child: Row(
                children: [
                  Icon(item.iconData),
                  Flexible(
                      child: Text(
                    item.label,
                    overflow: TextOverflow.fade,
                  )),
                ],
              )),
      ],
    );
  }
}
