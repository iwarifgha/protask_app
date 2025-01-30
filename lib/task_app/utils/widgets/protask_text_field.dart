import 'package:flutter/material.dart';

class ProtaskTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool Function(String)? validator;
  final bool hideText;

  const ProtaskTextField(
      {super.key,
      required this.label,
      required this.controller,
      this.validator,
      this.hideText = false});

  @override
  ProtaskTextFieldState createState() => ProtaskTextFieldState();
}

class ProtaskTextFieldState extends State<ProtaskTextField> {
  Color borderColor = Colors.grey;

  void _validateInput(String value) {
    setState(() {
      borderColor = widget.validator!(value) ? Colors.blue : Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.hideText,
      controller: widget.controller,
      onChanged: _validateInput,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 2.0),
        ),
      ),
    );
  }
}
