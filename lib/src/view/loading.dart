import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    Key? key,
    this.message,
  }) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: ScalingText(
              message ?? 'Loading ...', //TODO: Part of label !
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ],
      ),
    );
  }
}
