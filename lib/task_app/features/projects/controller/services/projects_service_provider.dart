import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/services/api/firebase/auth/firebase_auth_service.dart';
import 'package:task_app/task_app/services/api/firebase/firestore/firestore_database_service.dart';
import 'package:task_app/task_app/services/data/pref/user_pref.dart';
import 'package:task_app/task_app/utils/exceptions/exception_catcher.dart';
import 'package:uuid/uuid.dart';

class ProjectsServiceProvider {
  final _firebaseAuthProvider = FirebaseAuthService();
  var uuid = Uuid();
  final pref = UserPreferences();
  final _fireStoreDatabaseServiceProvider = FirestoreDatabase();

  Future<Project> addProject({required Project project}) async {
    return exceptionCatcher(() async {
      final newProject =
          await _fireStoreDatabaseServiceProvider.addProject(project: project);
      return newProject;
    });
  }

  Future<List<Project>> fetchProjects() async {
    return exceptionCatcher(() async {
      final user = await _firebaseAuthProvider.getAuthState();
      if (user == null) {
        throw Exception('User not logged in');
      }
      final projects =
          await _fireStoreDatabaseServiceProvider.fetchProjects(user.uid);
      return projects;
    });
  }

  Stream<List<Project>> getProjectsStream(String userId) {
    return exceptionCatcher( (){
      return _fireStoreDatabaseServiceProvider.getProjectsStream(userId);
    });
  }

  Future<void> deleteProject(String projectId) async {
    return exceptionCatcher(() async {
      await _fireStoreDatabaseServiceProvider.deleteProject(projectId);
    });
  }

  Future<Project> editProject(
      {required String projectId,
        int? duration,
      String? title,
      String? goal,
      bool? completed}) async {
    return exceptionCatcher(() async {
      final project = await _fireStoreDatabaseServiceProvider.updateProject(
          projectId: projectId,
          duration: duration,
          title: title,
          projectGoal: goal,
          completed: completed);
      return project;
    });
  }

  Future<Project> markAsCompleteProject({required Project project}) async {
    return exceptionCatcher(() async {
      return await _fireStoreDatabaseServiceProvider.markProjectAsComplete(
          projectId: project.projectId);
    });
  }
}
