import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/features/tasks/controllers/state/task_state_provider.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/utils/functions/date_formatter.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';
import 'package:task_app/task_app/utils/widgets/task_detail_widget.dart';

class TaskDetailsView extends StatefulWidget {
  static const path = '/task_details';
  final Task task;

  const TaskDetailsView({super.key, required this.task});

  @override
  State<TaskDetailsView> createState() => _TaskDetailsViewState();
}

class _TaskDetailsViewState extends State<TaskDetailsView> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
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
            onTap: () {},
          ),
          PopupMenuItem(
              padding: EdgeInsets.only(left: 25),
              child: Text('Edit'),
              onTap: () {})
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
    final task = widget.task;
    final state = context.watch<TaskStateProvider>();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go(MyProjectsView.path);
            },
          ),
          title: ProtaskCustomText(
              fontSize: 18, fontWeight: FontWeight.w100, text: 'Task Overview'),
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
                        ? state.setEditingStatus(false)
                        : _showMenu();
              },
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
                  spacing: 12,
                  children: [
                    TaskDetailWidget(
                      icon: Icons.title_outlined,
                      isEditing: state.isEditing,
                      controller: _titleController,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      onDoubleTap: () => state.setEditingStatus(true),
                    ),
                    TaskDetailWidget(
                      icon: Icons.description_outlined,
                      isEditing: state.isEditing,
                      controller: _descriptionController,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      onDoubleTap: () {},
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
                              text: 'Will end on:  ${formatDate(task.endDate)} '),
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
            )));
  }
}
