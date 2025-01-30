import 'package:flutter/foundation.dart';
import 'package:task_app/task_app/features/tasks/controllers/service/task_service_provider.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/utils/functions/error_handler.dart';

class TaskStateProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;
  final _taskServiceProvider = TaskServiceProvider();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
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

  Future<void> editTask({
    required String taskId,
    required String projectId,
    String? title,
    String? description,
  }) async {
    try {
      //Check if the task is in the local list
      final taskIndex = _tasks.indexWhere((task) => task.taskId == taskId);
      if (taskIndex == -1) return;
      //fields to update
      Map<String, dynamic> fields = {
        'description': description,
        'title': title
      };
      await _taskServiceProvider.editTask(
          projectId: projectId, taskId: taskId, fields: fields);
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
