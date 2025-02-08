import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/tasks/controllers/state/task_state_provider.dart';
import 'package:task_app/task_app/utils/widgets/protask_icon_text_button.dart';
import 'package:uuid/uuid.dart';

class AddTaskForm extends StatefulWidget {
  final String projectId;
  const AddTaskForm({super.key, required this.projectId});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? _start;
  DateTime? _end;
  var uuid = Uuid();

  Future<void> _pickDate(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime initialDate = _start ?? DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _start = pickedDate;
          print(_start);
          // Reset end date if it's before the new start date
          if (_end != null && _end!.isBefore(_start!)) {
            _end = null;
          }
        } else {
          _end = pickedDate;
        }
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime initialDate = _start ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _start) {
      setState(() {
        _start = picked;
        // Reset end date if it's before the new start date
        if (_end != null && _end!.isBefore(_start!)) {
          _end = null;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    if (_start == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a start date first.')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _start!,
      firstDate: _start!,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _end) {
      setState(() {
        _end = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Add Task",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Task Title")),
          TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description")),
          SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            onTap: () => _selectStartDate(context),
            decoration: InputDecoration(
              //labelText: "Start Date",
              hintText: _start != null
                  ? "${_start!.toLocal()}".split(' ')[0]
                  : "Select Start Date",
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            onTap: () => _selectEndDate(context),
            decoration: InputDecoration(
              //labelText: "End Date",
              hintText: _end != null
                  ? "${_end!.toLocal()}".split(' ')[0]
                  : "Select End Date",
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ProtaskIconTextButton(
              icon: Icons.bolt,
              text: 'Add task',
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    _start != null &&
                    _end != null) {
                  Provider.of<TaskStateProvider>(context, listen: false)
                      .addTask(
                          taskId: uuid.v4(),
                          projectId: widget.projectId,
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          startDate: _start!.toLocal().toString(),
                          endDate: _end!.toLocal().toString(),
                          timeCreated: DateTime.now().toIso8601String());
                  Navigator.pop(context);
                }
              }),
        ],
      ),
    );
  }
}
