import 'package:flutter/material.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';

class TaskDetailWidget extends StatelessWidget {
  final IconData icon;
  final bool isEditing;
  final TextEditingController controller;
  final double fontSize;
  final FontWeight fontWeight;
  final VoidCallback onDoubleTap;

  const TaskDetailWidget(
      {super.key,
      required this.icon,
      required this.isEditing,
      required this.controller,
      required this.fontSize,
      required this.onDoubleTap,
      required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Icon(icon),
        Flexible(
          child: isEditing
              ? TextField(
                  maxLines: null,
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(border: InputBorder.none),
                  style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
                  keyboardType: TextInputType.multiline,
                )
              : GestureDetector(
                  onDoubleTap: onDoubleTap,
                  child: ProtaskCustomText(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      text: controller.text),
                ),
        ),
      ],
    );
  }
}
