import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';

class ErrorNotifier extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;

  const ErrorNotifier({super.key, required this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 80,
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(12)),
          child: Center(child: ProtaskCustomText(text: message))),
    );
  }
}
