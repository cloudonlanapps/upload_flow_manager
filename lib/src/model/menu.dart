import 'package:flutter/material.dart';

class MenuItem {
  final IconData iconData;
  final Function() onSelection;

  MenuItem({required this.iconData, required this.onSelection});
}

class AdditionalMenuItem {
  String label;
  Function() onSelection;
  AdditionalMenuItem({
    required this.label,
    required this.onSelection,
  });
}

class Menu {
  List<MenuItem> menuItems;
  final List<AdditionalMenuItem>? additionalMenuItems;
  Menu({
    required this.menuItems,
    this.additionalMenuItems,
  });
}
