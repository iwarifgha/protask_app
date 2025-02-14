import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/projects/controller/state/projects_state_provider.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/features/projects/view/project_details.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/features/tasks/controllers/state/task_state_provider.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/features/tasks/view/task_details.dart';
import 'package:task_app/task_app/utils/functions/date_formatter.dart';
import 'package:task_app/task_app/utils/widgets/forms/task_form.dart';
import 'package:task_app/task_app/utils/widgets/notifiers/normal_notifier.dart';
import 'package:task_app/task_app/utils/widgets/notifiers/success_notifier.dart';

import '../../../utils/widgets/components/buttons/protask_icon_text_button.dart';
import '../../../utils/widgets/components/text/protask_text.dart';

class TasksView extends StatefulWidget {
  static const path = '/project_detials';
  final Project project;

  const TasksView({super.key, required this.project});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTasks();
    });
  }

  _fetchTasks() async {
    context
        .read<TaskStateProvider>()
        .fetchTasks(projectId: widget.project.projectId);
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
            child: Text('Refresh'),
            onTap: () {
              setState(() {
                print('refreshed');
              });
            },
          ),
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
            child: Text('View details'),
            onTap: () {
              context.push(ProjectDetailsView.path, extra: widget.project);
            },
          )
        ]);
  }

  _deleteProject({required BuildContext context, required String projectId}) {
    context.read<ProjectsStateProvider>().deleteProject(projectId);
  }

  void _showAddTaskModal(
    BuildContext context, {
    required String projectId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddTaskForm(
          projectId: projectId,
        );
      },
    );
  }

  _markProjectComplete(String projectId) {
    final projectCompletedStatus =
        context.read<ProjectsStateProvider>().checkIfProjectComplete(projectId);
    if (projectCompletedStatus == true) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: NormalNotifier(message: 'Already completed')));
      return;
    } else {
      context
          .read<ProjectsStateProvider>()
          .markProjectAsComplete(projectId: projectId);
    }
  }

  _markTaskComplete({required String projectId, required String taskId}) {
    final projectCompletedStatus =
        context.read<ProjectsStateProvider>().checkIfProjectComplete(projectId);
    if (projectCompletedStatus == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: NormalNotifier(
              message:
                  'Cannot mark or unmark for a completed project. Create another project instead')));
      return;
    } else {
      context.read<TaskStateProvider>().markTaskAsComplete(
          projectId: widget.project.projectId,
          taskId: taskId,
          onMark: () {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: SuccessNotifier(message: 'Completed')));
          },
          onUnmark: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    NormalNotifier(message: 'You have unmarked this task')));
          });
      //Calculate duration and update after toggling status.
      context.read<TaskStateProvider>().calculateProjectDurationFromTasks(
          projectId: projectId,
          onEmpty: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: SuccessNotifier(message: 'Well done, all tasks completed')));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final color = Color.fromARGB(255, 56, 111, 156);
    final taskProvider = context.watch<TaskStateProvider>();
    final projectId = widget.project.projectId;

    return Scaffold(
        appBar: AppBar(
          title: ProtaskCustomText(
              fontSize: 18,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              text: 'Tasks'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              color: taskProvider.checkIfAllTasksComplete() == true
                  ? Colors.green
                  : Colors.grey,
              onPressed: () {
                taskProvider.checkIfAllTasksComplete() == true
                    ? _markProjectComplete(projectId)
                    : null;
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert_outlined),
              onPressed: _showMenu,
            )
          ],
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Container(
            height: double.infinity,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  spacing: 15,
                  children: [
                    taskProvider.isLoading == true
                        ? SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ))
                        : taskProvider.tasks.isEmpty
                            ? Center(child: Text('No Tasks'))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: taskProvider.tasks.length,
                                itemBuilder: (context, index) {
                                  final task = taskProvider.tasks[index];
                                  return ListTile(
                                      onTap: () {
                                        context.push(TaskDetailsView.path,
                                            extra: task);
                                      },
                                      title: ProtaskCustomText(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          text: task.title),
                                      subtitle: Text(
                                          "${formatDate(DateTime.parse(task.startDate))} - ${formatDate(DateTime.parse(task.endDate))}"),
                                      leading: IconButton(
                                          onPressed: () {
                                            _markTaskComplete(
                                                projectId: projectId,
                                                taskId: task.taskId);
                                          },
                                          icon: Icon(
                                            task.isCompleted == true
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: task.isCompleted == true
                                                ? Colors.green
                                                : Colors.grey,
                                            size: 28,
                                          )));
                                },
                              ),
                  ],
                ),
              ),
            )),
        floatingActionButton: ProtaskIconTextButton(
          icon: Icon(Icons.bolt),
          text: 'Add a task',
          onPressed: () =>
              _showAddTaskModal(context, projectId: widget.project.projectId),
        ));
  }
}

// _showEditDialog(BuildContext context,
//     {required TextEditingController titleController,
//       required TextEditingController durationController}) {
//   final color = Color.fromARGB(255, 1, 141, 255);
//   showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15)),
//             backgroundColor: Colors.white,
//             title: Text('Edit Project'),
//             content: SingleChildScrollView(
//               child: SizedBox(
//                 height: 150,
//                 child: Column(children: [
//                   ProtaskTextField(
//                     label: 'Title',
//                     controller: titleController,
//                     validator: (val) {
//                       val = titleController.text;
//                       return val.isNotEmpty;
//                     },
//                   ),
//                   ProtaskTextField(
//                     label: 'Duration',
//                     controller: durationController,
//                     validator: (val) {
//                       val = durationController.text;
//                       return val.isNotEmpty;
//                     },
//                   ),
//                 ]),
//               ),
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(color: color),
//                   )),
//               TextButton(
//                   onPressed: () {
//                     context.read<ProjectsStateProvider>().editProject(
//                         projectId: widget.project.projectId,
//                         duration: int.tryParse(durationController.text),
//                         title: titleController.text);
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'Save',
//                     style: TextStyle(color: color),
//                   )),
//             ]);
//       });
// }
