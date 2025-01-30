import 'package:flutter/material.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';

class ProtaskIconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const ProtaskIconTextButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.black,
      ),
      label: ProtaskCustomText(text: text),
    );
  }
}
