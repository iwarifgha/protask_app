import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/utils/widgets/project_tile.dart';
import 'package:task_app/task_app/utils/widgets/protask_icon_button.dart';
import 'package:task_app/task_app/utils/widgets/protask_icon_text_button.dart';
import 'package:task_app/task_app/utils/widgets/protask_text_field.dart';

import '../../../utils/widgets/error_notifier.dart';
import '../../authentication/controller/state/auth_state_provider.dart';
import '../controller/state/projects_state_provider.dart';

class MyProjectsView extends StatefulWidget {
  static const path = '/projects';
  const MyProjectsView({super.key});

  @override
  State<MyProjectsView> createState() => _MyProjectsViewState();
}

class _MyProjectsViewState extends State<MyProjectsView> {
  bool loading = false;

  @override
  void initState() {
    setState(() {
      context.read<ProjectsStateProvider>().fetchProjects();
    });
    super.initState();
  }

  _deleteTask({required String taskId}) {
    context.read<ProjectsStateProvider>().deleteProject(taskId);
  }

  _signOut() async {
    final state = context.read<AuthStateProvider>();
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      loading = true;
    });
    try {
      final signedOut = await state.signOut();
      if (signedOut == true) {
        await state.setSignedInStateAsFalse();
        setState(() {
          loading = false;
        });
        router.go(SignInView.path);
      }
    } on Exception {
      messenger.showSnackBar(
        SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: ErrorNotifier(message: state.errorMessage!)),
      );
    }
  }

  void _showProjectSheet() {
    final titleController = TextEditingController();
    final durationController = TextEditingController();
    final goalController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.80,
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            children: [
              Text("Add Project",
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 10),
              ProtaskTextField(
                  label: 'Title of project', controller: titleController),
              ProtaskTextField(
                  label: 'Estimated duration (in days)',
                  controller: durationController),
              SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: null,
                    controller: goalController,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
              ProtaskIconTextButton(
                icon: Icons.add,
                text: 'Add Project',
                onPressed: () {
                  String title = titleController.text.trim();
                  String goal = goalController.text.trim();
                  int duration = int.tryParse(durationController.text) ?? 0;

                  if (title.isNotEmpty && goal.isNotEmpty) {
                    context.read<ProjectsStateProvider>().addProject(
                        title: title,
                        duration: duration,
                        goal: goal,
                        timeCreated: DateTime.now().toString());
                    Navigator.pop(context); // Close the modal
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectStateProvider = context.watch<ProjectsStateProvider>();
    final projects = projectStateProvider.projects;
    final errorMessage = projectStateProvider.errorMessage;

    return Scaffold(
      appBar: AppBar(title: const Text('Projects'), actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.menu_open_rounded))
      ]),
      body: errorMessage != null
          ? ErrorNotifier(
              message: errorMessage,
              onTap: () {
                projectStateProvider.clearError();
                projectStateProvider.fetchProjects();
              })
          : projects.isEmpty
              ? const Center(
                  child: Text('No Tasks'),
                )
              : ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return ProjectTile(
                      project: project,
                    );
                  }),
      floatingActionButton: ProtaskIconButton(
        icon: Icons.add,
        onPressed: _showProjectSheet,
      ),
    );
  }
}
