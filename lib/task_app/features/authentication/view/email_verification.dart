import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/utils/widgets/protask_icon_button.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';

class EmailVerificationView extends StatelessWidget {
  static const path = '/email_verifcation';
  const EmailVerificationView({super.key});

  /*
  verify
  //check if email is verified
  //if true, sign up with the email
  //then go to sign in screen
  //if false, show show dialog with message 'email not verified'
  //
  */ 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Center(
              child: ProtaskCustomText(
                  text:
                      'An email verification link has been sent to your account. Verify your email and then sign in.'),
            ),
            ProtaskIconButton(
                icon: Icons.arrow_forward,
                onPressed: () => context.go(SignInView.path))
          ],
        ),
      ),
    );
  }
}
