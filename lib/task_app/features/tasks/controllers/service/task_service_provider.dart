import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';
import 'package:task_app/task_app/services/api/firebase/firestore/firestore_database_service.dart';
import 'package:uuid/uuid.dart';

class TaskServiceProvider {
  var uuid = Uuid();
  final _fireStoreDatabaseServiceProvider = FirestoreDatabase();

  Future<Task> addTask({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String timeCreated,
    required String taskId,
    required String projectId,
  }) async {
    final task = Task(
        taskId: uuid.v4(),
        title: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        timeCreated: Timestamp.now().toDate().toIso8601String(),
        isCompleted: false
        );
    try {
      await _fireStoreDatabaseServiceProvider.addTask(
          task: task, projectId: projectId);
      return task;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Task>> fetchTasks(String projectId) async {
    try {
      final tasks =
          await _fireStoreDatabaseServiceProvider.fetchTasks(projectId);
      return tasks;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTask(
      {required String taskId, required String projectId}) async {
    try {
      await _fireStoreDatabaseServiceProvider.deleteTask(
          projectId: projectId, taskId: taskId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> editTask(
      {required String projectId,
      required String taskId,
      required Map<String, dynamic> fields}) async {
    try {
       await _fireStoreDatabaseServiceProvider.editTask(
          projectId: projectId, taskId: taskId, fieldsToUpdate: fields);
     } catch (e) {
      throw Exception(e.toString());
    }
  }
}
