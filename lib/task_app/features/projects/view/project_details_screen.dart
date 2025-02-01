import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/projects/controller/state/projects_state_provider.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/features/tasks/controllers/state/task_state_provider.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/features/tasks/view/task_details.dart';
import 'package:task_app/task_app/utils/functions/date_formatter.dart';
import 'package:task_app/task_app/utils/widgets/protask_icon_text_button.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';
import 'package:uuid/uuid.dart';

class ProjectDetailsView extends StatelessWidget {
  static const path = '/project_detials';
  final Project project;

  const ProjectDetailsView({super.key, required this.project});

  _deleteProject({required BuildContext context, required String projectId}) {
    context.read<ProjectsStateProvider>().deleteProject(projectId);
  }

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
              Text("Add Task",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Task Title")),
              TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Description")),
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
              ProtaskIconTextButton(
                  icon: Icons.bolt,
                  text: 'Add task',
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        startTime != null &&
                        endTime != null) {
                      Provider.of<TaskStateProvider>(context, listen: false)
                          .addTask(
                              taskId: uuid.v4(),
                              projectId: projectId,
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              startDate: startTime!,
                              endDate: endTime!,
                              timeCreated: DateTime.now().toIso8601String());
                      Navigator.pop(context);
                    }
                  }),
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
          appBar: AppBar(
            title: ProtaskCustomText(
                fontSize: 18,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                text: 'Project Overview'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.go(MyProjectsView.path);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert_outlined),
                onPressed: () {
                  showMenu(
                      context: context,
                      position: RelativeRect.fromDirectional(
                          textDirection: TextDirection.rtl,
                          start: 0,
                          top: 0,
                          end: 20,
                          bottom: 0),
                      items: [
                        PopupMenuItem(
                          padding: EdgeInsets.only(left: 25),
                          child: Text('Delete'),
                          onTap: () {
                            _deleteProject(
                                projectId: project.projectId, context: context);
                          },
                        )
                      ]);
                },
              )
            ],
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: Consumer<TaskStateProvider>(
            builder: (context, taskProvider, child) {
              if (taskProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return Container(
                  height: double.infinity,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 9),
                        color: Color(0xFFE6E5EA),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 15,
                            children: [
                              Icon(Icons.work_outline),
                              Flexible(
                                child: ProtaskCustomText(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w100,
                                    text: project.title),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 15,
                            children: [
                              Icon(Icons.bolt_rounded),
                              Flexible(
                                child: ProtaskCustomText(
                                    fontSize: 18, text: project.goal),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 15,
                            children: [
                              Icon(Icons.timelapse),
                              ProtaskCustomText(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  text: 'Duration:  ${project.duration} days '),
                            ],
                          ),
                          Row(
                            spacing: 15,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.task),
                              ProtaskCustomText(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  text: 'Tasks: '),
                            ],
                          ),
                          taskProvider.tasks.isEmpty
                              ? const Center(
                                  child: Text('No Tasks'),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: taskProvider.tasks.length,
                                  itemBuilder: (context, index) {
                                    final task = taskProvider.tasks[index];
                                    return ListTile(
                                        onTap: () {
                                          context.go(TaskDetailsView.path,
                                              extra: task);
                                        },
                                        title: ProtaskCustomText(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            text: task.title),
                                        subtitle: Text(
                                            "${formatDate(task.startDate)} - ${formatDate(task.endDate)}"),
                                        leading: Checkbox(
                                            shape: CircleBorder(),
                                            value: false,
                                            onChanged: (value) {}));
                                  },
                                ),
                        ],
                      ),
                    ),
                  ));
            },
          ),
          floatingActionButton: ProtaskIconTextButton(
            icon: Icons.bolt,
            text: 'Add a task',
            onPressed: () => showAddTaskModal(context, project.projectId),
          )),
    );
  }
}

// List<Task> mockTasks = [
//   Task(
//       timeCreated: DateTime.now().toIso8601String(),
//       title: 'Design the Ui prototypes',
//       description:
//           'This involves using figma to create the first wirframes of how the app should look like',
//       taskId: 'taskId',
//       startDate: DateTime.now(),
//       endDate: DateTime.parse("20250201"),
//       isCompleted: false,
//       projectId: ''),
//   Task(
//       timeCreated: DateTime.now().toIso8601String(),
//       title: 'Implement core app features',
//       description:
//           'This involves using figma to create the first wirframes of how the app should look like',
//       taskId: 'taskId',
//       startDate: DateTime.now(),
//       endDate: DateTime.parse("20250225"),
//       isCompleted: false,
//       projectId: ''),
//   Task(
//       timeCreated: DateTime.now().toIso8601String(),
//       title: 'Test and Debug App for quality',
//       description:
//           'We will write unit, integration and widget test to ensure that all components work well',
//       taskId: 'taskId',
//       startDate: DateTime.now(),
//       endDate: DateTime.parse("20250201"),
//       isCompleted: false,
//       projectId: ''),
//   Task(
//       timeCreated: DateTime.now().toIso8601String(),
//       title: 'Implement core app features',
//       description:
//           'This involves using figma to create the first wirframes of how the app should look like',
//       taskId: 'taskId',
//       startDate: DateTime.now(),
//       endDate: DateTime.parse("20250225"),
//       isCompleted: false,
//       projectId: ''),
// ];
