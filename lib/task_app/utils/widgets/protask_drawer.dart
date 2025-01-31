import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/task_app/features/profile/view/profile_overview.dart';
import 'package:task_app/task_app/features/profile/view/profile_settings.dart';
import 'package:task_app/task_app/utils/widgets/protask_icon_button.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';

class ProtaskAppDrawer extends StatelessWidget {
  const ProtaskAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shape: Border(),
      width: MediaQuery.of(context).size.width * 0.60,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            spacing: 100,
            children: [
              IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  size: 35,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Divider(),
          ListTile(
            trailing: Icon(Icons.person),
            title: Text("My Account"),
            onTap: () {
              context.go(ProfileOverview.path);
            },
          ),
          ListTile(
            trailing: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              context.go(ProfileSettingsView.path);
            },
          ),
          ListTile(
            trailing: Icon(Icons.check_circle),
            title: Text("Completed Projects"),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sign Out"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
