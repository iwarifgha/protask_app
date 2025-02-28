import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/tasks/view/tasks_view.dart';
import 'package:task_app/task_app/utils/widgets/forms/add_project.dart';
import 'package:task_app/task_app/utils/widgets/components/loaders/loading_widget.dart';
import 'package:task_app/task_app/utils/widgets/components/utility/project_tile.dart';
import 'package:task_app/task_app/utils/widgets/components/utility/protask_drawer.dart';

import '../../../utils/widgets/components/buttons/protask_icon_button.dart';
import '../controller/state/projects_state_provider.dart';

class MyProjectsView extends StatefulWidget {
  static const path = '/projects';

  const MyProjectsView({super.key});

  @override
  State<MyProjectsView> createState() => _MyProjectsViewState();
}

class _MyProjectsViewState extends State<MyProjectsView> {

  @override
  void initState() {
    super.initState();
  }



  void _showAddProjectForm() {
    final titleController = TextEditingController();
    final goalController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddProjectForm(
            titleCtrl: titleController, goalCtrl: goalController);
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
          scrolledUnderElevation: 0,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: const Text('Projects'),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(
                    Icons.menu_outlined,
                  ));
            })
          ]),
      endDrawer: ProtaskAppDrawer(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
            BoxShadow(
              offset: Offset(-2, -2),
              color: Color(0xFFE6E5EA),
              blurRadius: 1,
            ),
          ],
        ),
        child: projectStateProvider.isLoading
            ? ProtaskLoader()
            : projects.isEmpty
                ? Center(
                    child: Text('You have no projects yet'),
                  )
                : errorMessage != null
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : ListView.builder(
                        itemCount: projects.length + 1,
                        //projects.length,
                        itemBuilder: (context, index) {
                          // Add extra space at the bottom
                          if (index == projects.length) {
                            return const SizedBox(
                                height: 500); // Extra padding at the bottom
                          }
                          bool isHighlighted = index ==
                              projectStateProvider.highlightedProjectIndex;
                          final project = projects[index];
                          return ProjectTile(
                            isHighlighted: isHighlighted,
                            project: project,
                            onTap: () =>
                                context.push(TasksView.path, extra: project),
                          );
                        }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ProtaskIconButton(
            icon: Icons.add,
            onPressed: () {
              _showAddProjectForm();
            }),
      ),
    );
  }
}
