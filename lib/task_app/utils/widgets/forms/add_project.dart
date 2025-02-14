import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/projects/controller/state/projects_state_provider.dart';
import '../components/buttons/protask_icon_text_button.dart';
import '../components/text/protask_text_field.dart';
import '../notifiers/error_notifier.dart';

class AddProjectForm extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController goalCtrl;

  const AddProjectForm(
      {super.key, required this.titleCtrl, required this.goalCtrl});

  _addProject(BuildContext context) {
    String title = titleCtrl.text.trim();
    String goal = goalCtrl.text.trim();
    final state = context.read<ProjectsStateProvider>();
    final messenger = ScaffoldMessenger.of(context);
    // int duration = int.tryParse(durationController.text) ?? 0;

    if (title.isNotEmpty && goal.isNotEmpty) {
      state.addProject(
          title: title, goal: goal, timeCreated: DateTime.now().toString());
      Navigator.pop(context);
    } else {
      messenger.showSnackBar(
        SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: ErrorNotifier(message: 'Empty fields')),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProjectsStateProvider>();
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          spacing: 8,
          children: [
            Text("Add Project", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            ProtaskTextField(
              label: 'Title of project',
              controller: titleCtrl,
              validator: (val) {
                val = titleCtrl.text.trim();
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
                  controller: goalCtrl,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
            ProtaskIconTextButton(
              icon: state.isLoading == true
                  ? SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Icon(Icons.add),
              text: 'Add Project',
              onPressed: () {
                _addProject(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
