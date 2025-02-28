import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_app/task_app/features/projects/controller/services/projects_service_provider.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/services/data/pref/user_pref.dart';
import 'package:task_app/task_app/utils/exceptions/exceptions.dart';
import 'package:task_app/task_app/utils/functions/error_handler.dart';
import 'package:uuid/uuid.dart';

class ProjectsStateProvider with ChangeNotifier {
  var uuid = Uuid();
  final pref = UserPreferences();

  ProjectsStateProvider() {
    _listenForProjects();
  }

  List<Project> _projects = [];

  List<Project> get projects => _projects;
  final _projectServiceProvider = ProjectsServiceProvider();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isEditing = false;

  bool get isEditing => _isEditing;

  double scrollOffset = 0.0;
  int highlightedProjectIndex = 0;

  StreamSubscription<List<Project>>? _projectsSubcription;

  _listenForProjects() async {
    final userId = await pref.getUserId();
    _projectsSubcription = _projectServiceProvider
        .getProjectsStream(userId)
        .listen((projectsFromStream) {
      _projects = projectsFromStream;
      _clearError();
    },
        onError: (error) {
          _errorMessage = 'Error fetching projects: $error';
          notifyListeners();
        }
    );
  }



  setEditingStatus(bool value) {
    _isEditing = value;
    notifyListeners();
  }

  _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> addProject(
      {required String title,
      required String goal,
      required String timeCreated}) async {
    try {
      _setLoading(true);
      _clearError();
      final userId = await pref.getUserId();
      final project = Project(
          projectId: uuid.v4(),
          userId: userId,
          title: title,
          goal: goal,
          duration: 0,
          allTasksCompleted: false,
          timeCreated: timeCreated);
      await Future.delayed(Duration(milliseconds: 500), () async {
        final newProject =
            await _projectServiceProvider.addProject(project: project);
        _projects.add(newProject);
      });
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchProjects() async {
    _setLoading(true);
    _clearError();
     try {
      await Future.delayed(Duration(milliseconds: 500));
      _projects = await _projectServiceProvider.fetchProjects();
      notifyListeners();
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteProject(String projectId) async {
    _setLoading(true);
    _clearError();
    try {
      await Future.delayed(Duration(milliseconds: 1000));
      await _projectServiceProvider.deleteProject(projectId);
      _projects.removeWhere((project) => project.projectId == projectId);
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> editProject(
      {required String projectId,
      String? title,
      String? goal,
      bool? completed,
      int? duration}) async {
    _setLoading(true);
    _clearError();
    try {
      final projectIndex =
          _projects.indexWhere((project) => project.projectId == projectId);
      if (projectIndex == -1) return;
      await Future.delayed(Duration(milliseconds: 1000));
      final newProject = await _projectServiceProvider.editProject(
          projectId: projectId,
          duration: duration,
          title: title,
          goal: goal,
          completed: completed);
      _projects[projectIndex] = newProject;
      setEditingStatus(false);
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }



  @override
  void dispose() {
    _projectsSubcription?.cancel();
    super.dispose();
  }

  Future<void> markProjectAsComplete({
    required String projectId,
  }) async {
    _clearError(); //Check if the task is in the local list
    try {
      final projectIndex = _projects
          .indexWhere((projectVal) => projectVal.projectId == projectId);
      if (projectIndex == -1) {
        throw GeneralErrorException(message: 'No project found');
      }

      //get the specific project
      Project project = _projects[projectIndex];
      //mark it as complete
      final completedProject =
          await _projectServiceProvider.markAsCompleteProject(project: project);
      //re-assign the project now with completed value
      print ('check if project is truly completed: ${completedProject.allTasksCompleted}');
      project = completedProject;
      print ('check if project is truly completed: ${project.allTasksCompleted}');

    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }

  bool checkIfProjectComplete(String projectId){
    final projectIndex = _projects.indexWhere((project) => project.projectId == projectId);
    final project = _projects[projectIndex];

    if (project.allTasksCompleted == true){
      return true;
    }
    return false;
  }
}
