import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/profile/view/profile_overview.dart';
import 'package:task_app/task_app/features/profile/view/profile_settings.dart';
import 'package:task_app/task_app/utils/widgets/notifiers/success_notifier.dart';

import '../../../../features/authentication/controller/state/auth_state_provider.dart';
import '../../../../features/authentication/view/sign_in.dart';
import '../../../../services/data/pref/user_pref.dart';

class ProtaskAppDrawer extends StatelessWidget {
  const ProtaskAppDrawer({super.key});

  _signOut(BuildContext context) async {
    final state = context.read<AuthStateProvider>();
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final pref = UserPreferences();

    final signedOut = await state.signOut();
    if (signedOut == true) {
      pref.setSignedInState(false); //set local user signed state to false
      messenger.showSnackBar(
        SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: SuccessNotifier(message: 'You are signed out')),
      );
      router.go(SignInView.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthStateProvider>();
    return Drawer(
      backgroundColor: Colors.white,
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
            leading: state.isLoading == true
                ? SizedBox(
                    height: 10, width: 10, child: CircularProgressIndicator())
                : Icon(Icons.logout),
            title: Text("Sign Out"),
            onTap:(){
              _signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
