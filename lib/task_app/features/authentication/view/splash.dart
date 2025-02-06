import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/controller/state/auth_state_provider.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/features/authentication/view/welcome.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/services/data/pref/user_pref.dart';
import 'package:task_app/task_app/utils/widgets/loading_widget.dart';

class SplashView extends StatefulWidget {
  static const path = '/splash';
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final pref = UserPreferences();

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
    // final state = context.read<AuthStateProvider>();
    final router = GoRouter.of(context);
    final hasOnboarded = await pref.getOnboardState();
    final isSignedIn = await pref.getSignedInState();
    hasOnboarded == false
        ? router.go(WelcomeView.path)
        : hasOnboarded == true && isSignedIn == false
            ? router.go(SignInView.path)
            : router.go(MyProjectsView.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Center(child: ProtaskLoader()),
    ));
  }
}
