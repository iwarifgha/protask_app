import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/controller/state/auth_state_provider.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/features/authentication/view/welcome.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';

class Splash extends StatefulWidget {
  static const path = '/splash';
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _startDelay();
    });
  }

  Future<void> _startDelay() async {
    await Future.delayed(const Duration(seconds: 5));
    await _getOnboardInfo();
  }

  Future<void> _getOnboardInfo() async {
    final state = context.read<AuthStateProvider>();
    final hasOnboarded = state.hasOnboarded;
    final isSignedIn = state.isSignedIn;
    hasOnboarded == false
        ? context.go(WelcomeView.path)
        : hasOnboarded == true && isSignedIn == false
            ? context.go(SignInView.path)
            : context.go(ProjectsView.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.lightBlue,
      child: Center(
        child: Text('ProTask'),
      ),
    ));
  }
}
