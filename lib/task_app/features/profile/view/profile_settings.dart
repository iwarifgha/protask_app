import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';

class ProfileSettingsView extends StatelessWidget {
  static const path = '/profile_settings';
  const ProfileSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(MyProjectsView.path);
          },
        ),
        title: ProtaskCustomText(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          text: 'Settings',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              SizedBox(
                height: 35,
              ),
              Row(
                children: [
                  ProtaskCustomText(
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                    text: 'Theme',
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  ProtaskCustomText(
                    fontSize: 15,
                    //fontWeight: FontWeight.bold,
                    text: 'Sign out',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
