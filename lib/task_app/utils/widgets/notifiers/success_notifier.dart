
import 'package:flutter/material.dart';
import '../components/text/protask_text.dart';

class SuccessNotifier extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;

  const SuccessNotifier({super.key, required this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 80,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: const Color(0xff5ec84f), borderRadius: BorderRadius.circular(12)),
          child: Center(child: ProtaskCustomText(text: message))),
    );
  }
}