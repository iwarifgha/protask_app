import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String projectId;
  final String taskId;

  const TaskDetailsScreen({required this.projectId, required this.taskId, Key? key}) : super(key: key);

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool isEditing = false;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime startTime;
  late DateTime endTime;

  @override
  void initState() {
    super.initState();
    _fetchTaskDetails();
  }

  void _fetchTaskDetails() async {
    DocumentSnapshot taskSnapshot = await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('tasks')
        .doc(widget.taskId)
        .get();

    Map<String, dynamic> taskData = taskSnapshot.data() as Map<String, dynamic>;
    setState(() {
      titleController = TextEditingController(text: taskData['title']);
      descriptionController = TextEditingController(text: taskData['description']);
      startTime = DateTime.parse(taskData['startTime']);
      endTime = DateTime.parse(taskData['endTime']);
    });
  }

  void _updateTask() async {
    await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('tasks')
        .doc(widget.taskId)
        .update({
      'title': titleController.text,
      'description': descriptionController.text,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    });

    setState(() => isEditing = false);
  }


 Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime initialDate = isStart ? startTime : endTime;
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Task Details'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _updateTask();
              } else {
                setState(() => isEditing = true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isEditing
                ? TextField(
                    controller: titleController,
                    autofocus: true,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : Text(
                    titleController.text,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            SizedBox(height: 10),
            isEditing
                ? TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    style: TextStyle(fontSize: 16),
                  )
                : Text(
                    descriptionController.text,
                    style: TextStyle(fontSize: 16),
                  ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: isEditing ? () => _selectDate(context, true) : null,
              child: Text(
                'Start Time: ${startTime.toLocal()}'.split('.')[0],
                style: TextStyle(fontSize: 16, color: isEditing ? Colors.blue : Colors.black),
              ),
            ),
            GestureDetector(
              onTap: isEditing ? () => _selectDate(context, false) : null,
              child: Text(
                'End Time: ${endTime.toLocal()}'.split('.')[0],
                style: TextStyle(fontSize: 16, color: isEditing ? Colors.blue : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
