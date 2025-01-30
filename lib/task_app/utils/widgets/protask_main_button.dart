import 'package:flutter/material.dart';

class ProtaskButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ProtaskButton({super.key, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final appColor = Colors.lightBlueAccent;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          color: appColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}
