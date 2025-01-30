import 'package:go_router/go_router.dart';
import 'package:task_app/task_app/features/authentication/view/email_verification.dart';
import 'package:task_app/task_app/features/authentication/view/forgot_password.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/features/authentication/view/sign_up.dart';
import 'package:task_app/task_app/features/authentication/view/splash.dart';
import 'package:task_app/task_app/features/authentication/view/welcome.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';

final GoRouter appRoutes = GoRouter(
  initialLocation: MyProjectsView.path,
  routes: [
    GoRoute(path: SplashView.path, builder: (context, state) => SplashView()),
    GoRoute(path: WelcomeView.path, builder: (context, state) => WelcomeView()),
    GoRoute(path: SignInView.path, builder: (context, state) => SignInView()),
    GoRoute(path: SignUpView.path, builder: (context, state) => SignUpView()),
    GoRoute(
        path: MyProjectsView.path,
        builder: (context, state) => MyProjectsView()),
    GoRoute(
        path: ForgotPasswordView.path,
        builder: (context, state) => ForgotPasswordView()),
    GoRoute(
        path: EmailVerificationView.path,
        builder: (context, state) => EmailVerificationView()),
  ],
);
