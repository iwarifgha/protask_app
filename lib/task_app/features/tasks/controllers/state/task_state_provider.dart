import 'package:flutter/foundation.dart';
import 'package:task_app/task_app/features/tasks/controllers/service/task_service_provider.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/utils/functions/error_handler.dart';

class TaskStateProvider extends ChangeNotifier {
  final _taskServiceProvider = TaskServiceProvider();

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  bool _isAllTasksComplete = false;
  bool get isAllTasksComplete => _isAllTasksComplete;

  int _projectDuration = 0;
  int get projectDuration => _projectDuration;

  _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  setEditingStatus(bool value) {
    _isEditing = value;
    print(_isEditing);
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String startDate,
    required String endDate,
    required String timeCreated,
    required String taskId,
    required String projectId,
  }) async {
    try {
      final task = await _taskServiceProvider.addTask(
          title: title,
          description: description,
          startDate: startDate,
          endDate: endDate,
          timeCreated: timeCreated,
          taskId: taskId,
          projectId: projectId);

      _tasks.add(task);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTasks({required String projectId}) async {
    try {
      _tasks = await _taskServiceProvider.fetchTasks(projectId);
      print(_tasks);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTask(
      {required String projectId, required String taskId}) async {
    try {
      await _taskServiceProvider.deleteTask(
          projectId: projectId, taskId: taskId);
      _tasks.removeWhere((task) => task.taskId == taskId);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      notifyListeners();
    }
  }

  Future<void> editTask(
      {required String taskId,
      required String projectId,
      String? title,
      String? description,
      bool? isCompleted}) async {
    try {
      //Check if the task is in the local list
      final taskIndex = _tasks.indexWhere((task) => task.taskId == taskId);
      if (taskIndex == -1) return;
      //fields to update

      final editedTask = await _taskServiceProvider.editTask(
          projectId: projectId,
          taskId: taskId,
          title: title,
          description: description,
          isCompleted: isCompleted);
      _tasks[taskIndex] = editedTask;

      setEditingStatus(false);
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

  Future<void> markTaskAsComplete({
    required String projectId,
    required String taskId,
  }) async {
    //Check if the task is in the local list
    try {
      final taskIndex = _tasks.indexWhere((task) => task.taskId == taskId);
      if (taskIndex == -1) {
        throw Exception();
      }

      //get the specific task
      Task taskToBeMarked = _tasks[taskIndex];
      //mark it as complete
      final completedTask =
          await _taskServiceProvider.markAsComplete(task: taskToBeMarked);
      //re-calculate duration
      await _autoCalculateProjectDurationFromTaskDates(projectId: projectId);
      await _checkForAllTaskInProjectComplete(projectId: projectId);
      //re-assign the task now with compledvalue
      taskToBeMarked = completedTask;
    } catch (e) {
      throw Exception();
    }
  }

  Future<int> _autoCalculateProjectDurationFromTaskDates(
      {required String projectId}) async {
    try {
      final duration = await _taskServiceProvider
          .autoCalculateDurationFromTaskDates(projectId: projectId);
      _projectDuration = duration;
      return _projectDuration;
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> _checkForAllTaskInProjectComplete(
      {required String projectId}) async {
    try {
      final status = await _taskServiceProvider
          .checkForAllTaskInProjectComplete(projectId: projectId);
      _isAllTasksComplete = status;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
