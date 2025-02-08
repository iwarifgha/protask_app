import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/features/projects/view/project_details_screen.dart';
import 'package:task_app/task_app/services/data/pref/user_pref.dart';
import 'package:task_app/task_app/utils/functions/error_handler.dart';
import 'package:task_app/task_app/utils/widgets/project_tile.dart';
import 'package:task_app/task_app/utils/widgets/protask_drawer.dart';
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
  final pref = UserPreferences();

  @override
  void initState() {
    _fetchProjects();
    setState(() {});
    super.initState();
  }

  _fetchProjects() async {
    context.read<ProjectsStateProvider>().fetchProjects();
  }

  _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: ErrorNotifier(message: message)),
    );
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
        pref.setSignedInState(false);
        // await state.setSignedInStateAsFalse();
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
    final goalController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.60,
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 8,
              children: [
                Text("Add Project",
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 10),
                ProtaskTextField(
                  label: 'Title of project',
                  controller: titleController,
                  validator: (val) {
                    val = titleController.text;
                    return val.isNotEmpty;
                  },
                ),
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
                    // int duration = int.tryParse(durationController.text) ?? 0;

                    if (title.isNotEmpty && goal.isNotEmpty) {
                      try {
                        context.read<ProjectsStateProvider>().addProject(
                            title: title,
                            goal: goal,
                            timeCreated: DateTime.now().toString());
                        Navigator.pop(context);
                      } on Exception catch (e) {
                        final mesg = handleError(e);
                        _showErrorSnackbar(mesg);
                      }
                    }
                  },
                )
              ],
            ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Projects'),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(Icons.menu_outlined,));
            })
          ]),
      endDrawer: ProtaskAppDrawer(),
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
        child: projects.isEmpty
            ? Center(
                child: Text('You have no projects yet'),
              )
            : errorMessage != null
                ? ErrorNotifier(message: errorMessage)
                : ListView.builder(
                    itemCount: projects.length,
                    //projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return ProjectTile(
                        project: project,
                        onTap: () =>
                            context.go(ProjectDetailsView.path, extra: project),
                      );
                    }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ProtaskIconButton(
          icon: Icons.add,
          onPressed: _showProjectSheet,
        ),
      ),
    );
  }
}

// List<Project> mockProject = [
//   Project(
//       projectId: 'projectId',
//       userId: 'userId',
//       title: 'Mobile App Development',
//       goal:
//           'The goal of this project is to finish build ing  a mobile app in sixdays using AI',
//       duration: 6,
//       tasks: [],
//       timeCreated: DateTime.now().toIso8601String(),
//       allTasksCompleted: false),
//   Project(
//       projectId: 'projectId',
//       userId: 'userId',
//       title: 'List Creation',
//       goal:
//           'The aim of this project is to have a list of all top influencers in the mobile phone industry on Linkedin.'
//           'This will be used for cold outreach purposes',
//       duration: 30,
//       tasks: [],
//       timeCreated: DateTime.now().toIso8601String(),
//       allTasksCompleted: false),
// ];
