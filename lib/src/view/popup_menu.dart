// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../model/menu.dart';

class AdditionalMenu extends StatelessWidget {
  final List<MenuItem> menuItems;
  final IconData iconAdditionalMenu;
  const AdditionalMenu({
    super.key,
    required this.menuItems,
    required this.iconAdditionalMenu,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuItem>(
      icon: Icon(iconAdditionalMenu),
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
