import 'package:flutter/material.dart';

class CLTile extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  const CLTile({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          color: backgroundColor ?? const Color.fromARGB(255, 225, 225, 225),
          // Intentional, don't convert to Border.all
          border:
              Border.all(width: 0.5, color: Theme.of(context).primaryColor)),
      height: 256,
      width: 256,
      child: child,
    );
  }
}
