import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';

import '../../../utils/widgets/error_notifier.dart';
import '../../authentication/controller/state/auth_state_provider.dart';
import '../controller/state/projects_state_provider.dart';

class ProjectsView extends StatefulWidget {
  static const path = '/projects';
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
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
            content: SizedBox(
              width: 100,
              height: 80,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text('Unable to sign out')),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectStateProvider = context.watch<ProjectsStateProvider>();
    final projects = projectStateProvider.projects;
    final errorMessage = projectStateProvider.errorMessage;

    return Scaffold(
      appBar: AppBar(title: const Text('Projects'), actions: [
        IconButton(
            onPressed: () => _signOut(),
            icon: loading == true
                ? CircularProgressIndicator()
                : Icon(Icons.logout))
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
                    return ListTile(
                      title: Text(project.title),
                      subtitle: Text(project.goal),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  projectStateProvider.clearError();
                                  _deleteTask(
                                    taskId: project.projectId,
                                  );
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                    );
                  }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_task');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
