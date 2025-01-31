import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/features/tasks/controllers/state/task_state_provider.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/utils/functions/date_formatter.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';

class TaskDetailsView extends StatelessWidget {
  static const path = '/task_details';
  final Task task;

  const TaskDetailsView({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskStateProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go(MyProjectsView.path);
            },
          ),
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
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProtaskCustomText(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  text: task.title),
                              Icon(Icons.more_horiz_outlined)
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 15,
                          children: [
                            Icon(Icons.description_outlined),
                            Flexible(
                              child: ProtaskCustomText(
                                  fontSize: 18, text: task.description),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 15,
                          children: [
                            Icon(Icons.timelapse),
                            Flexible(
                              child: ProtaskCustomText(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  text:
                                      'Starting on:  ${formatDate(task.startDate)} '),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 15,
                          children: [
                            Icon(Icons.timelapse),
                            Flexible(
                              child: ProtaskCustomText(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  text:
                                      'Ending on:  ${formatDate(task.endDate)} '),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 15,
                          children: [
                            Icon(Icons.done_outline),
                            Flexible(
                              child: ProtaskCustomText(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  text:
                                      'Status:  ${task.isCompleted ? 'Done' : 'Pending'} '),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ));
          },
        ),
      ),
    );
  }
}
