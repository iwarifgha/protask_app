import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/controller/state/auth_state_provider.dart';
import 'package:task_app/task_app/features/authentication/view/sign_up.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/services/data/pref/user_pref.dart';
import 'package:task_app/task_app/utils/functions/validators.dart';
import 'package:task_app/task_app/utils/widgets/notifiers/error_notifier.dart';
import 'package:task_app/task_app/utils/widgets/components/loaders/loading_widget.dart';
import 'package:task_app/task_app/utils/widgets/notifiers/success_notifier.dart';

import '../../../utils/widgets/components/buttons/protask_icon_button.dart';
import '../../../utils/widgets/components/dialogs/email_verify_dialog.dart';
import '../../../utils/widgets/components/dialogs/forgot_password_dialog.dart';
import '../../../utils/widgets/components/text/protask_text.dart';
import '../../../utils/widgets/components/text/protask_text_field.dart';

class SignInView extends StatefulWidget {
  static String path = '/sign_in';

  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final pref = UserPreferences();

// bool isEmailVerified = false;

//   _sendEmailVerification() {
//         final messenger = ScaffoldMessenger.of(context);

//     context.read<AuthStateProvider>().verifyEmail();
//     messenger.showSnackBar(
//         SnackBar(
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             content: ErrorNotifier(message: 'Empty fields')),
//       );
//   }

  _resetPassword() {
    showDialog(
        context: context,
        builder: (context) {
          return ForgotPasswordDialog();
        });
  }

  _showVerifyDialog({required String email}) {
    showDialog(
        context: context,
        builder: (context) {
          return EmailVerifyDialog(
            email: email,
          );
        });
  }

  _signIn() async {
    final state = context.read<AuthStateProvider>();
    final router = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      messenger.showSnackBar(
        SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: ErrorNotifier(message: 'Empty fields')),
      );
      return;
    } else {
      final user = await state.signIn(
          email: _emailController.text.trim(), password: _passwordController.text.trim());

      if (user != null) {
        final verified = user.isEmailVerified;

        if (verified == false) {
          _showVerifyDialog(email: user.email);
        } else {
          pref.setUserId(user.userId);
          pref.setSignedInState(true);
          messenger.showSnackBar(
            SnackBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: SuccessNotifier(message: 'Sign in Successful!')),
          );
          router.go(MyProjectsView.path);

        }
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthStateProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign into your account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 25,
            children: [
              Container(
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            'assets/images/Pro_Hadid-removebg-preview.png'))),
              ),
              ProtaskTextField(
                label: 'Email',
                controller: _emailController,
                validator: (email) {
                  email = _emailController.text.trim();
                  return  EmailValidator.validate(email);
                },
              ),
              Column(
                spacing: 8,
                children: [
                  ProtaskTextField(
                    label: 'Password',
                    controller: _passwordController,
                    hideText: true,
                    validator: (pass) {
                      pass = _passwordController.text.trim();
                      return passwordValidator(pass);
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: _resetPassword,
                      child: ProtaskCustomText(
                        color: Colors.grey,
                        text: 'Forgot Password',
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        context.go(SignUpView.path);
                      },
                      child: ProtaskCustomText(fontSize: 17, text: 'Sign Up')),
                  state.isLoading == true
                      ? ProtaskLoader()
                      : ProtaskIconButton(
                      icon: Icons.arrow_forward, onPressed: () => _signIn())
                ],
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(
                  height: 10,
                ),
                Text(
                  state.errorMessage!,
                  style: TextStyle(color: Colors.red),
                )
              ]            ],
          ),
        ),
      ),
    );
  }
}
