import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/features/tasks/controllers/state/task_state_provider.dart';
import 'package:uuid/uuid.dart'; 

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailsScreen({super.key, required this.project});

void showAddTaskModal(BuildContext context, String projectId) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? startTime;
  DateTime? endTime;
  var uuid = Uuid();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
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
            Text("Add Task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Task Title")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  startTime = pickedDate;
                }
              },
              child: Text("Pick Start Date"),
            ),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  endTime = pickedDate;
                }
              },
              child: Text("Pick End Date"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && startTime != null && endTime != null) {
                  Provider.of<TaskStateProvider>(context, listen: false).addTask(
                    taskId: uuid.v4() ,
                    projectId: projectId,
                    title:  titleController.text.trim(),
                    description:  descriptionController.text.trim(),
                    startDate:  startTime!,
                    endDate: endTime!,
                    timeCreated: DateTime.now().toIso8601String()
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Add Task"),
            ),
          ],
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskStateProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text(project.title)),
        body: Consumer<TaskStateProvider>(
          builder: (context, taskProvider, child) {
            if (taskProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];

                return ListTile(
                  title: Text(task.title),
                  subtitle: Text("${task.startDate} - ${task.endDate}"),
                  trailing:  Checkbox(value: false, onChanged: (value){})
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showAddTaskModal(context, project.projectId),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
