import 'package:flutter/material.dart';

class MenuItem {
  String label;
  final IconData iconData;
  Function() onSelection;
  MenuItem({
    required this.label,
    required this.iconData,
    required this.onSelection,
  });
}

class Menu {
  List<MenuItem> menuItems;
  final List<MenuItem>? additionalMenuItems;
  Menu({
    required this.menuItems,
    this.additionalMenuItems,
  });
}
