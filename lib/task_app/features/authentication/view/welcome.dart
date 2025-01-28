import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/controller/state/auth_state_provider.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';

class WelcomeView extends StatelessWidget {
  static const path = '/welcome';
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthStateProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task App'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: const Text('Welcome, Please click below to get started'),
            ),
            ElevatedButton(
                onPressed: () {
                  state.setOnboardedState();
                  context.go(SignInView.path);
                },
                child: const Text(' Get Started ')),
          ],
        ),
      ),
    );
  }
}
