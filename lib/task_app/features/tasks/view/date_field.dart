import 'package:flutter/material.dart';

class ProtaskDateField extends StatelessWidget {
  final String date;
  final String name;
  final VoidCallback onTap;

  const ProtaskDateField(
      {super.key, required this.onTap, required this.date, required this.name});
  @override
  Widget build(Object context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Icon(Icons.calendar_month_outlined),
          Column(
            spacing: 8,
            children: [
              Text(name),
              Text(date),
            ],
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.edit))
        ],
      ),
    );
  }
}
