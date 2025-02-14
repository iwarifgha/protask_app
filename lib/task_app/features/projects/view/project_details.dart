import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/projects/controller/state/projects_state_provider.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/features/tasks/controllers/state/task_state_provider.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/utils/functions/date_formatter.dart';

import '../../../utils/widgets/components/text/protask_text.dart';
import '../../../utils/widgets/components/utility/task_detail_widget.dart';
import '../model/project/projects_model.dart';

class ProjectDetailsView extends StatefulWidget {
  static const path = '/project_details';
  final Project project;

  const ProjectDetailsView({super.key, required this.project});

  @override
  State<ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<ProjectDetailsView> {
  late final TextEditingController _titleController;
  late final TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _goalController = TextEditingController(text: widget.project.goal);
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
            onTap: () {},
          ),
          PopupMenuItem(
              padding: EdgeInsets.only(left: 25),
              child: Text('Delete'),
              onTap: () {
                context
                    .read<ProjectsStateProvider>()
                    .deleteProject(widget.project.projectId);
              })
        ]);
  }

  Widget _indicator() {
    return SizedBox(
      height: 15,
      width: 15,
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final state = context.watch<ProjectsStateProvider>();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          title: ProtaskCustomText(
              fontSize: 18, fontWeight: FontWeight.w100, text: 'Project Overview'),
          actions: [
            IconButton(
              icon: state.isLoading
                  ? _indicator()
                  : state.isEditing
                      ? Icon(Icons.check)
                      : Icon(Icons.more_vert_outlined),
              onPressed: () {
                state.isLoading == true
                    ? null
                    : state.isEditing == true
                        ? state.editProject(
                            projectId: project.projectId,
                            title: _titleController.text,
                            goal: _goalController.text)
                        : _showMenu();
              },
            )
          ],
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  TaskDetailWidget(
                    icon: Icons.title_outlined,
                    isEditing: state.isEditing,
                    controller: _titleController,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    onDoubleTap: () => state.setEditingStatus(true),
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
                  TaskDetailWidget(
                    icon: Icons.description_outlined,
                    isEditing: state.isEditing,
                    controller: _goalController,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    onDoubleTap: () {},
                  ),

                  // Row(
                  //   spacing: 15,
                  //   children: [
                  //     Icon(Icons.done_outline),
                  //     Flexible(
                  //       child: ProtaskCustomText(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.normal,
                  //           text:
                  //               'Status:  ${project.isCompleted ? 'Done' : 'Pending'} '),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
