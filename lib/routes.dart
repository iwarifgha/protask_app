import 'package:go_router/go_router.dart';
import 'package:task_app/task_app/features/authentication/view/sign_in.dart';
import 'package:task_app/task_app/features/authentication/view/sign_up.dart';
import 'package:task_app/task_app/features/authentication/view/splash.dart';
import 'package:task_app/task_app/features/authentication/view/welcome.dart';
import 'package:task_app/task_app/features/profile/view/profile_overview.dart';
import 'package:task_app/task_app/features/profile/view/profile_settings.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/features/projects/view/project_details.dart';
import 'package:task_app/task_app/features/tasks/view/tasks_view.dart';
import 'package:task_app/task_app/features/projects/view/projects_view.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/features/tasks/view/task_details.dart';

final GoRouter appRoutes = GoRouter(
  initialLocation: SplashView.path,
  routes: [
    GoRoute(path: SplashView.path, builder: (context, state) => SplashView()),
    GoRoute(path: WelcomeView.path, builder: (context, state) => WelcomeView()),
    GoRoute(path: SignInView.path, builder: (context, state) => SignInView()),
    GoRoute(path: SignUpView.path, builder: (context, state) => SignUpView()),
    GoRoute(
        path: MyProjectsView.path,
        builder: (context, state) => MyProjectsView()),
    GoRoute(
        path: ProjectDetailsView.path,
        builder: (context, state) => ProjectDetailsView(
              project: state.extra as Project,
            )),
    GoRoute(
        path: ProfileOverview.path,
        builder: (context, state) => ProfileOverview()),
    GoRoute(
        path: ProfileSettingsView.path,
        builder: (context, state) => ProfileSettingsView()),
    GoRoute(
        path: TasksView.path,
        builder: (context, state) => TasksView(
              project: state.extra as Project,
            )),
    GoRoute(
        path: TaskDetailsView.path,
        builder: (context, state) => TaskDetailsView(
              task: state.extra as Task,
            )),
  ],
);
