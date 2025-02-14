import 'package:flutter/foundation.dart';
import 'package:task_app/task_app/features/tasks/controllers/service/task_service_provider.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/utils/exceptions/exceptions.dart';
import 'package:task_app/task_app/utils/functions/error_handler.dart';

import '../../../projects/controller/services/projects_service_provider.dart';

class TaskStateProvider extends ChangeNotifier {
  final _taskServiceProvider = TaskServiceProvider();
  final _projectServiceProvider = ProjectsServiceProvider();

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

  _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  setEditingStatus(bool value) {
    _isEditing = value;
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
    _setLoading(true);
    _clearError();
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
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTasks({required String projectId}) async {
    _setLoading(true);
    _clearError();
    try {
      Future.delayed(Duration(milliseconds: 600));
      _tasks = await _taskServiceProvider.fetchTasks(projectId);
      _tasks.sort((a, b) {
        if (a.isCompleted && !b.isCompleted) return -1;
        if (!a.isCompleted && b.isCompleted) return 1;
        return a.startDate.compareTo(b.startDate);
      });
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTask(
      {required String projectId, required String taskId}) async {
    _setLoading(true);
    _clearError();
    try {
      Future.delayed(Duration(milliseconds: 600));
      await _taskServiceProvider.deleteTask(
          projectId: projectId, taskId: taskId);
      _tasks.removeWhere((task) => task.taskId == taskId);
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> editTask(
      {required String taskId,
      required String projectId,
      String? title,
      String? description,
      bool? isCompleted}) async {
    _setLoading(true);
    _clearError();
    try {
      //Check if the task is in the local list
      final taskIndex = _tasks.indexWhere((task) => task.taskId == taskId);
      if (taskIndex == -1) {
        throw GeneralErrorException(message: 'Task not found!');
      }
      //fields to update

      final editedTask = await _taskServiceProvider.editTask(
          projectId: projectId,
          taskId: taskId,
          title: title,
          description: description,
          isCompleted: isCompleted);
      _tasks[taskIndex] = editedTask;

      setEditingStatus(false);
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> markTaskAsComplete(
      {required String projectId,
      required String taskId,
      required Function onMark,
        required Function onUnmark}) async {
    _clearError();
    //Check if the task is in the local list
    try {
      final taskIndex = _tasks.indexWhere((task) => task.taskId == taskId);
      if (taskIndex == -1) {
        throw GeneralErrorException(message: 'Task not found!');
      }
      //get the specific task
      _tasks[taskIndex] = _tasks[taskIndex]
          .copyWith(isCompleted: !_tasks[taskIndex].isCompleted);
      notifyListeners();

      if(_tasks[taskIndex].isCompleted){
        onMark();
      } else {
        onUnmark();
      }
      //mark it as complete in firestore
      await _taskServiceProvider.toggleTaskStatus(task: _tasks[taskIndex]);

    } catch (e) {
      final taskIndex = _tasks.indexWhere((task) => task.taskId == taskId);
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
          isCompleted:
              !_tasks[taskIndex].isCompleted); //reverse the value on error
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> calculateProjectDurationFromTasks(
      {required String projectId, required Function onEmpty}) async {
    try {
      //Get uncompleted tasks
      List<Task> incompleteTasks =
          _tasks.where((task) => task.isCompleted == false).toList();
      if (incompleteTasks.isEmpty) {
        // No active tasks, duration is zero
        await _projectServiceProvider.editProject(
            projectId: projectId, duration: 0);
        onEmpty();
        notifyListeners();
        return;
      }

      List<DateTime> startDates = incompleteTasks
          .map((task) => DateTime.parse(task.startDate))
          .toList();
      List<DateTime> endDates =
          incompleteTasks.map((task) => DateTime.parse(task.endDate)).toList();

      DateTime minStart = startDates.reduce((a, b) => a.isBefore(b) ? a : b);
      DateTime maxEnd = endDates.reduce((a, b) => a.isAfter(b) ? a : b);
      final duration = maxEnd.difference(minStart).inDays + 1;
      await _projectServiceProvider.editProject(
          projectId: projectId, duration: duration);
    } catch (e) {
      final errorMsg = handleError(e);
      _errorMessage = errorMsg;
    } finally {
      _setLoading(false);
    }
  }



  bool checkIfAllTasksComplete() {
    List<Task> incompleteTasks =
        _tasks.where((task) => task.isCompleted == false).toList();
    if (incompleteTasks.isEmpty) {
      // No active tasks, project is complete
      return true;
    }
    return false;
  }
}
