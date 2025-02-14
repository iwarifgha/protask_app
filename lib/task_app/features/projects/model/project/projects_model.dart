import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/task_app/features/tasks/model/task/task_model.dart';

//Abstract class
abstract class ProjectsModel {
  final String projectId;
  final String userId;
  final String title;
  final String goal;
  final int duration;
  final String timeCreated;
  final bool allTasksCompleted;

  ProjectsModel(
      {required this.timeCreated,
      required this.projectId,
      required this.userId,
      required this.title,
      required this.goal,
      required this.duration,
      required this.allTasksCompleted});
}

//Project model
class Project extends ProjectsModel {
  Project(
      {required super.projectId,
      required super.userId,
      required super.title,
      required super.goal,
      required super.duration,
      required super.timeCreated,
      required super.allTasksCompleted});

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'userId': userId,
      'title': title,
      'goal': goal,
      'duration': duration,
      'createdAt': timeCreated
    };
  }

  factory Project.fromMap(Map<String, dynamic> json) {
    return Project(
        projectId: json['projectId'] ?? '',
        userId: json['userId'] ?? '',
        title: json['title'] ?? '',
        goal: json['goal'] ?? '',
        duration: json['duration'] ?? 0,
        timeCreated: json['createdAt'] ?? '',
        allTasksCompleted: json['allTasksCompleted'] ?? false);
  }

  Project copyWith(
      {bool? allTasksCompleted, int? duration, String? goal, String? title}) {
    return Project(
      title: title ?? this.title,
      duration: duration ?? this.duration,
      goal: goal ?? this.goal,
      allTasksCompleted: allTasksCompleted ?? this.allTasksCompleted,
      projectId: projectId,
      timeCreated: timeCreated,
      userId: userId,
    );
  }
}
