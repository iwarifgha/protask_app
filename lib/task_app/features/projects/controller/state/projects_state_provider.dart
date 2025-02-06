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
      required int duration,
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
          duration: duration,
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
      {required String projectId, String? title, int? duration}) async {
    try {
      final projectIndex =
          _projects.indexWhere((project) => project.projectId == projectId);
      if (projectIndex == -1) return;

      final newProject = await _projectServiceProvider.editProject(
          projectId: projectId, title: title, duration: duration?.toInt());
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
