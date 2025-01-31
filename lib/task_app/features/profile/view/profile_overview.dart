import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';

class ProfileOverview extends StatelessWidget {
  static const path = '/profile';
  const ProfileOverview({super.key});

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
          text: 'Profile',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          spacing: 15,
          children: [
            SizedBox(
              height: 35,
            ),
            Stack(children: [
              CircleAvatar(
                radius: 60,
              ),
              Positioned(
                  top: 80,
                  left: 70,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        size: 30,
                      )))
            ]),
            ProtaskCustomText(
              fontSize: 20,
              text: 'Username',
              fontWeight: FontWeight.w800,
            ),
            ProtaskCustomText(
              fontSize: 20,
              text: 'Usernameemail@email.com',
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
