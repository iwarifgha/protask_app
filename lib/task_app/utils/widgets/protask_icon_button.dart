// Custom Buttons
import 'package:flutter/material.dart';

class ProtaskIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const ProtaskIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
