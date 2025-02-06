import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/projects/controller/state/projects_state_provider.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/features/tasks/controllers/state/task_state_provider.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/features/tasks/view/date_field.dart';
import 'package:task_app/task_app/features/tasks/view/task_details.dart';
import 'package:task_app/task_app/utils/functions/date_formatter.dart';
import 'package:task_app/task_app/utils/widgets/protask_icon_text_button.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';
import 'package:task_app/task_app/utils/widgets/protask_text_field.dart';
import 'package:uuid/uuid.dart';

class ProjectDetailsView extends StatefulWidget {
  static const path = '/project_detials';
  final Project project;

  const ProjectDetailsView({super.key, required this.project});

  @override
  State<ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<ProjectDetailsView> {
  late final TextEditingController _titleController;
  late final TextEditingController _durationController;
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _durationController =
        TextEditingController(text: widget.project.duration.toString());
  }

  _showMenu() {
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
                  projectId: widget.project.projectId, context: context);
            },
          ),
          PopupMenuItem(
            padding: EdgeInsets.only(left: 25),
            child: Text('Edit'),
            onTap: () {
              _showEditDialog(context,
                  titleController: _titleController,
                  durationController: _durationController);
            },
          )
        ]);
  }

  _deleteProject({required BuildContext context, required String projectId}) {
    context.read<ProjectsStateProvider>().deleteProject(projectId);
  }

  _showEditDialog(BuildContext context,
      {required TextEditingController titleController,
      required TextEditingController durationController}) {
    final color = Color.fromARGB(255, 1, 141, 255);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: Colors.white,
              title: Text('Edit Project'),
              content: SingleChildScrollView(
                child: SizedBox(
                  height: 150,
                  child: Column(children: [
                    ProtaskTextField(
                      label: 'Title',
                      controller: titleController,
                      validator: (val) {
                        val = titleController.text;
                        return val.isNotEmpty;
                      },
                    ),
                    ProtaskTextField(
                      label: 'Duration',
                      controller: durationController,
                      validator: (val) {
                        val = durationController.text;
                        return val.isNotEmpty;
                      },
                    ),
                  ]),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: color),
                    )),
                TextButton(
                    onPressed: () {
                      context.read<ProjectsStateProvider>().editProject(
                          projectId: widget.project.projectId,
                          duration: int.tryParse(durationController.text) ,
                          title: titleController.text);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: color),
                    )),
              ]);
        });
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStart}) async {
    DateTime? initialDate = isStart ? _start : _end;
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        if (isStart) {
          _start = picked;
        } else {
          _end = picked;
        }
      });
    }
  }

  void _showAddTaskModal(
    BuildContext context, {
    required String projectId,
  }) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

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
              ProtaskDateField(
                  onTap: () {
                    _selectDate(context, isStart: true);
                  },
                  date: _start == null ? 'Choose date' : '${_start!.toLocal()}',
                  name: 'Add start date'),
              ProtaskDateField(
                  onTap: () {
                    _selectDate(context, isStart: true);
                  },
                  date: _start == null ? 'Choose date' : '${_start!.toLocal()}',
                  name: 'Add end date'),
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
                              projectId: projectId,
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              startDate: _start!,
                              endDate: _end!,
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
    //final color = Color.fromARGB(255, 56, 111, 156);
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
                onPressed: _showMenu,
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
                                    text: widget.project.title),
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
                                    fontSize: 18, text: widget.project.goal),
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
                                  text:
                                      'Duration:  ${widget.project.duration} days '),
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
            onPressed: () =>
                _showAddTaskModal(context, projectId: widget.project.projectId),
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
