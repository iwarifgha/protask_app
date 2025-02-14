import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/controller/state/auth_state_provider.dart';
import 'package:task_app/task_app/features/profile/controller/state/user_profile_state.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/services/data/pref/user_pref.dart';

import '../../../utils/widgets/components/text/protask_text.dart';
import '../model/user_model.dart';

class ProfileOverview extends StatelessWidget {
  static const path = '/profile';

  const ProfileOverview({super.key});


  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserProfileState>();
    final userProfile = state.userProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(MyProjectsView.path);
          },
        ),
        title: ProtaskCustomText(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          text: 'Profile',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: state.errorMessage != null
            ? Text("Error: ${state.errorMessage}") // Show error message if any
            : userProfile == null
            ? const CircularProgressIndicator() // Show loading if profile is null
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 35),

            // Profile Picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  //backgroundImage:
                  // userProfile.imageUrl != null
                  //     ? NetworkImage(userProfile.imageUrl!)
                  //     :
                  //AssetImage("assets/default_avatar.png")

                ),
                Positioned(
                  top: 80,
                  left: 70,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_rounded, size: 30),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Username Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: ProtaskCustomText(
                  fontSize: 15,
                  text: 'Username',
                  fontWeight: FontWeight.w800,
                ),
                subtitle: ProtaskCustomText(
                  fontSize: 14,
                  text: userProfile.displayName,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Email Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: ProtaskCustomText(
                  fontSize: 15,
                  text: 'Email',
                  fontWeight: FontWeight.w800,
                ),
                subtitle: ProtaskCustomText(
                  fontSize: 14,
                  text: userProfile.email,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
