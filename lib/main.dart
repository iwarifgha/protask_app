import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/routes.dart';
import 'package:task_app/task_app/features/authentication/controller/state/auth_state_provider.dart';
import 'package:task_app/task_app/features/profile/controller/state/user_profile_state.dart';
import 'package:task_app/task_app/features/projects/controller/state/projects_state_provider.dart';
import 'package:task_app/task_app/features/tasks/controllers/state/task_state_provider.dart';
import 'package:task_app/task_app/services/data/pref/user_pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final pref = UserPreferences();
  await pref.getOnboardState();
  await pref.getSignedInState();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProjectsStateProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileState()),
        ChangeNotifierProvider(
          create: (context) => TaskStateProvider(),
        ),
        ChangeNotifierProvider(create: (context) => AuthStateProvider()),
      ],
      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: appRoutes,
        );
      }));
}
