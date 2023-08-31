import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Text(
          errorMessage,
          maxLines: 5,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
