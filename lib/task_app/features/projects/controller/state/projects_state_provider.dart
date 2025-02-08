import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_app/task_app/features/projects/controller/services/projects_service_provider.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/services/data/pref/user_pref.dart';
import 'package:task_app/task_app/utils/functions/error_handler.dart';
import 'package:uuid/uuid.dart';

class ProjectsStateProvider with ChangeNotifier {
  var uuid = Uuid();
  final pref = UserPreferences();

  List<Project> _projects = [];
  List<Project> get projects => _projects;
  final _projectServiceProvider = ProjectsServiceProvider();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addProject(
      {required String title,
      required String goal,
      required String timeCreated}) async {
    try {
      _setLoading(true);
      final userId = await pref.getUserId();
      final project = Project(
          projectId: uuid.v4(),
          userId: userId,
          title: title,
          goal: goal,
          duration: 0,
          allTasksCompleted: false,
          timeCreated: timeCreated);
      final newProject =
          await _projectServiceProvider.addProject(project: project);
      _projects.add(newProject);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchProjects() async {
    try {
      _projects = await _projectServiceProvider.fetchProjects();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
      notifyListeners();
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _projectServiceProvider.deleteProject(projectId);
      _projects.removeWhere((project) => project.projectId == projectId);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      notifyListeners();
    }
  }

  Future<void> editProject(
      {required String projectId,
      String? title,
      int? duration,
      bool? completed}) async {
    try {
      final projectIndex =
          _projects.indexWhere((project) => project.projectId == projectId);
      if (projectIndex == -1) return;

      final newProject = await _projectServiceProvider.editProject(
          projectId: projectId,
          title: title,
          duration: duration?.toInt(),
          completed: completed);
      _projects[projectIndex] = newProject;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      notifyListeners();
    }
  }

  Future<void> markProjectAsComplete({
    required String projectId,
  }) async {
    //Check if the task is in the local list
    try {
      final projectIndex = _projects
          .indexWhere((projectVal) => projectVal.projectId == projectId);
      if (projectIndex == -1) {
        throw Exception();
      }

      //get the specific project
      Project project = _projects[projectIndex];
      //mark it as complete
      final completedProject =
          await _projectServiceProvider.markAsCompleteProject(project: project);
      //re-assign the project now with completed value
      project = completedProject;
    } catch (e) {
      throw Exception();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
