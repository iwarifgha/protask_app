import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TaskModel {
  final String timeCreated;
  String title, description;
  final DateTime startDate, endDate;
  final String taskId;
  final String projectId;
  final bool isCompleted;

  TaskModel({required this.projectId, 
        required this.timeCreated,
      required this.title,
      required this.description,
      required this.taskId,
      required this.startDate,
      required this.endDate,
      required this.isCompleted});
}

class Task extends TaskModel {
  Task({required super.projectId, 
      required super.timeCreated,
      required super.title,
      required super.description,
      required super.taskId,
      required super.startDate,
      required super.endDate,
      required super.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'createdAt': timeCreated,
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'taskId': taskId,
      'isCompleted': isCompleted,
      'projectId': projectId
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      projectId:map['projectId'] ,
        taskId: map['taskId'],
        timeCreated: map['createdAt'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        startDate: (map['startDate'] as Timestamp).toDate(),
        endDate: (map['endDate'] as Timestamp).toDate(),
        isCompleted: map['isCompleted'] ?? false);
  }
}
