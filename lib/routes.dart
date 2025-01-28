import 'package:go_router/go_router.dart'; 
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/features/authentication/view/sign_up.dart';
import 'package:task_app/task_app/features/authentication/view/splash.dart';
import 'package:task_app/task_app/features/authentication/view/welcome.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';


final GoRouter appRoutes = GoRouter(
  initialLocation: Splash.path,
  routes: [
    GoRoute(path: Splash.path, builder: (context, state) => Splash()),
    GoRoute(path: WelcomeView.path, builder: (context, state) => WelcomeView()),
    GoRoute(path: SignInView.path, builder: (context, state) => SignInView()),
    GoRoute(path: SignUpView.path, builder: (context, state) => SignUpView()),
    GoRoute(
        path: ProjectsView.path, builder: (context, state) => ProjectsView()),
  ],
);
