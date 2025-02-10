import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/services/api/firebase/firestore/firestore_database_service.dart';
import 'package:task_app/task_app/utils/exceptions/exception_handler.dart';
import 'package:uuid/uuid.dart';

class TaskServiceProvider {
  final _fireStoreDatabaseServiceProvider = FirestoreDatabase();

  Future<Task> addTask({
    required String title,
    required String description,
    required String startDate,
    required String endDate,
    required String timeCreated,
    required String taskId,
    required String projectId,
  }) async {
    return handleExceptionSync(() async {
      final task = Task(
          projectId: projectId,
          taskId: taskId,
          title: title,
          description: description,
          startDate: startDate,
          endDate: endDate,
          timeCreated: Timestamp.now().toDate().toIso8601String(),
          isCompleted: false);
      await _fireStoreDatabaseServiceProvider.addTask(task: task);
      return task;
    });
  }

  Future<List<Task>> fetchTasks(String projectId) async {
    return handleExceptionSync(() async {
      final tasks =
          await _fireStoreDatabaseServiceProvider.fetchTasks(projectId);
      return tasks;
    });
  }

  Future<void> deleteTask({
    required String taskId,
    required String projectId,
  }) async {
    return handleExceptionSync(() async {
      await _fireStoreDatabaseServiceProvider.deleteTask(
        projectId: projectId,
        taskId: taskId,
      );
    });
  }

  Future<Task> editTask(
      {required String projectId,
      required String taskId,
      String? title,
      String? description,
      bool? isCompleted}) async {
    return handleExceptionSync(() async {
      return await _fireStoreDatabaseServiceProvider.editTask(
          projectId: projectId,
          taskId: taskId,
          title: title,
          description: description,
          isComplete: isCompleted);
    });
  }

  Future<Task> markAsComplete({required Task task}) async {
    return handleExceptionSync(() async {
      return await _fireStoreDatabaseServiceProvider.markTaskComplete(
          taskId: task.taskId, projectId: task.projectId);
    });
  }

  Future<int> autoCalculateDurationFromTaskDates(
      {required String projectId}) async {
    return handleExceptionSync(() async {
      return await _fireStoreDatabaseServiceProvider
          .calculateProjectDuration(projectId);
    });
  }

  Future<bool> checkForAllTaskInProjectComplete(
      {required String projectId}) async {
    return handleExceptionSync(() async {
      return await _fireStoreDatabaseServiceProvider
          .checkIfAllTasksInAProjectComplete(projectId: projectId);
    });
  }
}
