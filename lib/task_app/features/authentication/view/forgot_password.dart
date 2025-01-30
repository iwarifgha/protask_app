import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_app/task_app/features/authentication/view/email_verification.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/utils/functions/validators.dart';
import 'package:task_app/task_app/utils/widgets/protask_icon_button.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';
import 'package:task_app/task_app/utils/widgets/protask_text_field.dart';

class ForgotPasswordView extends StatefulWidget {
  static const path = '/forgot_password';
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.go(SignInView.path);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProtaskCustomText(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                text: 'Forgot Password'),
            ProtaskCustomText(
                fontSize: 15,
                text: 'Please type the email you used to register an account'),
            ProtaskTextField(
                label: 'Email',
                controller: _emailController,
                validator: (email) {
                  email = _emailController.text;
                  return emailValidator(email);
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProtaskIconButton(
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        context.go(EmailVerificationView.path);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
