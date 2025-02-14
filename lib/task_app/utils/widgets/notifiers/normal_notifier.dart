import 'package:flutter/material.dart';
import '../components/text/protask_text.dart';

class NormalNotifier extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;

  const NormalNotifier({super.key, required this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 80,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: const Color(0xff4b9ad8),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline),
              Expanded(child: Center(child: ProtaskCustomText(text: message))),
            ],
          )),
    );
  }
}
