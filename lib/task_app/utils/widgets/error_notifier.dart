import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorNotifier extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const ErrorNotifier({super.key, required this.message, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        backgroundBlendMode: BlendMode.darken),
      child: Center(
        child: Column(
          children: [
            Text(message),
            ElevatedButton(onPressed: onTap, child: const Text('Retry'))
          ],
        ),
      ),
    );
  }
}
