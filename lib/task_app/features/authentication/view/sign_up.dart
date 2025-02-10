import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/controller/state/auth_state_provider.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/utils/functions/validators.dart';
import 'package:task_app/task_app/utils/widgets/error_notifier.dart';
import 'package:task_app/task_app/utils/widgets/loading_widget.dart';
import 'package:task_app/task_app/utils/widgets/protask_icon_button.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';
import 'package:task_app/task_app/utils/widgets/protask_text_field.dart';

class SignUpView extends StatefulWidget {
  static const path = '/sign_up';
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();

  _signUp() async {
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
      try {
        final signedUp = await state.signUp(
            email: _emailController.text,
            password: _passwordController.text,
            displayName: _displayNameController.text);

        if (signedUp == true) {
          messenger.showSnackBar(
            SnackBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                content: ErrorNotifier(message: 'Sign up succesful')),
          );
          router.go(SignInView.path);
        }
        return;
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              content: ErrorNotifier(
                  message: state.errorMessage ?? 'Somethin went wrong')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthStateProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up for a free account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
          child: Column(
            spacing: 18,
            children: [
              ProtaskTextField(
                label: 'Username',
                controller: _displayNameController,
                validator: (val) {
                  val = _displayNameController.text;
                  return val.isNotEmpty;
                },
              ),
              ProtaskTextField(
                label: 'Email',
                controller: _emailController,
                validator: (email) {
                  email = _emailController.text;
                  return passwordValidator(email);
                },
              ),
              ProtaskTextField(
                label: 'Password',
                controller: _passwordController,
                hideText: true,
                validator: (pass) {
                  pass = _passwordController.text;
                  return passwordValidator(pass);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        context.go(SignInView.path);
                      },
                      child: ProtaskCustomText(fontSize: 17, text: 'Sign In')),
                  ProtaskIconButton(
                      icon: Icons.arrow_forward, onPressed: () => _signUp())
                ],
              ),
              if (state.isLoading == true) ProtaskLoader(),
            ],
          ),
        ),
      ),
    );
  }
}
