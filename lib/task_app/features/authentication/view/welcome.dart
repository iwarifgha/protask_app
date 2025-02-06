import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/controller/state/auth_state_provider.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/services/data/pref/user_pref.dart';
import 'package:task_app/task_app/utils/widgets/protask_main_button.dart';

class WelcomeView extends StatelessWidget {
  static const path = '/welcome';
  WelcomeView({super.key});
  final pref = UserPreferences();

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthStateProvider>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            RichText(
              text: TextSpan(
                  text: 'Welcome ',
                  style: TextStyle(
                      fontFamily: 'EB Garamond',
                      color: Colors.lightBlue,
                      fontSize: 35,
                      fontWeight: FontWeight.bold)),
            ),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Your number ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 25)),
              TextSpan(
                  text: ' ONE ',
                  style: TextStyle(
                      fontFamily: 'Noto Sans Mongolian',
                      color: Colors.lightBlue,
                      fontSize: 25)),
              TextSpan(
                  text: ' productivity companion ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 25)),
            ])),
            SizedBox(
              height: 21,
            ),
            ProtaskButton(
              text: ' Get Started ',
              onTap: () {
                pref.setOnboardedState();
                // state.setOnboardedState();
                context.go(SignInView.path);
              },
            )
          ],
        ),
      ),
    );
  }
}
