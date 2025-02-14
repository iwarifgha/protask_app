import 'package:flutter/material.dart';

import '../text/protask_text.dart';

class ProtaskIconTextButton extends StatelessWidget {
  final Widget icon;
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
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xff008fff)),
          iconColor: WidgetStateProperty.all(Colors.white),
          textStyle: WidgetStatePropertyAll(TextStyle(color: Colors.white))),
      onPressed: onPressed,
      icon: icon,
      label: ProtaskCustomText(text: text, color: Colors.white),
    );
  }
}
