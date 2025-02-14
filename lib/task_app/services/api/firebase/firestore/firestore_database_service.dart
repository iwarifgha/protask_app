import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/utils/exceptions/exception_catcher.dart';
import 'package:task_app/task_app/utils/exceptions/exceptions.dart';

import '../../../../features/tasks/model/task/task_model.dart';

class FirestoreDatabase {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  //----------------USER PROFILE METHODS-------------------//

//CREATE USER PROFILE
  Future<void> createUserProfile({required UserProfile user}) async {
    DocumentReference userDoc = _fireStore.collection('users').doc(user.userId);
    return exceptionCatcher(() async {
      // Check if user document already exists
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Add user data to Firestore
        await userDoc.set(user.toMap());
      }
    });
  }

//GET USER PROFILE
  Future<UserProfile> getUserProfile({required String userId}) async {
    return exceptionCatcher(() async {
      final snapshot = await _fireStore.collection('users').doc(userId).get();
      final user = snapshot.data();
      if (user != null) {
        return UserProfile.fromMap(user);
      }
      throw GeneralErrorException(message: 'User not found');
    });
  }

//UPDATE USER PROFILE DETAILS
  Future<void> updateUserDetails({
    required String uid,
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    return exceptionCatcher(() async {
      User? user = _auth.currentUser;

      if (user == null) {
        throw UserNotFoundException();
      }

      // First: Update Firebase Auth
      if (displayName != null || photoUrl != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoUrl);
      }

      if (email != null && email != user.email) {
        await user.verifyBeforeUpdateEmail(email);
      }

      // Then: Update Firestore
      Map<String, dynamic> updatedData = {
        if (displayName != null) 'displayName': displayName,
        if (email != null) 'email': email,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await _fireStore.collection('users').doc(uid).update(updatedData);
      // Optionally: Reload Firebase Auth User
      await user.reload();
    });
  }

//DELETE USER PROFILE
  Future<void> deleteUserProfile(userId) async {
    return exceptionCatcher(() async {
      final userInAuth = _auth.currentUser;
      final userInFirestore = _fireStore.collection('users').doc(userId);

      if (userInAuth == null) {
        throw Exception('No user logged in');
      }

      //Delete from firebase Auth
      await userInAuth.delete();

      //delete from firestore
      await userInFirestore.delete();
    });
  }

//----------------TASKS METHODS-------------------//

  Future<Task> addTask({required Task task}) async {
    return exceptionCatcher(() async {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(task.taskId)
          .set(task.toMap());

      final singleTask =
          await getSingleTask(projectId: task.projectId, taskId: task.taskId);
      return singleTask;
    });
  }

  Future<Task> getSingleTask({
    required String projectId,
    required String taskId,
  }) async {
    return exceptionCatcher(() async {
      final snapshot = await _fireStore
          .collection('tasks')
          .where('projectId', isEqualTo: projectId)
          .where('taskId', isEqualTo: taskId)
          .limit(1)
          .get();
      final queryDoc = snapshot.docs.first;
      final data = queryDoc.data();
      return Task.fromMap(
        data,
      );
    });
  }

  Future<List<Task>> fetchTasks(String projectId) async {
    return exceptionCatcher(() async {
      final snapshot = await _fireStore
          .collection('tasks')
          .where('projectId', isEqualTo: projectId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Task.fromMap(
          data,
        );
      }).toList();
    });
  }

  Future<Task> editTask(
      {required String projectId,
      required String taskId,
      String? title,
      String? description,
      bool? isComplete}) async {
    return exceptionCatcher(() async {
      Map<String, dynamic> fields = {
        if (description != null) 'description': description,
        if (title != null) 'title': title,
        if (isComplete != null) 'isCompleted': isComplete
      };
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update(fields);
      final task = await getSingleTask(projectId: projectId, taskId: taskId);
      return task;
    });
  }

  Future<void> deleteTask(
      {required String projectId, required String taskId}) async {
    return exceptionCatcher(() async {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    });
  }

  Future<Task> toggleTaskStatus(
      {required String taskId, required String projectId}) async {
    return exceptionCatcher(() async {
      final task = await getSingleTask(projectId: projectId, taskId: taskId);
      final newTask = await editTask(
          projectId: projectId, taskId: taskId, isComplete: !task.isCompleted);
      return newTask;
    });
  }

//----------------PROJECTS METHODS-------------------//

  Future<Project> addProject({required Project project}) async {
    return exceptionCatcher(() async {
      await _fireStore
          .collection('projects')
          .doc(project.projectId)
          .set(project.toMap());
      final newProject = getSingleProject(projectId: project.projectId);
      return newProject;
    });
  }

  Future<List<Project>> fetchProjects(String userId) async {
    return exceptionCatcher(() async {
      final snapshot = await _fireStore
          .collection('projects')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Project.fromMap(data);
      }).toList();
    });
  }
//Does not need the exception catcher since this is a stream
  Stream<List<Project>> getProjectsStream(String userId) {
    return _fireStore
        .collection('projects')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Project.fromMap(doc.data());
      }).toList();
    });
  }

  Future<Project> getSingleProject({required String projectId}) async {
    return exceptionCatcher(() async {
      final snapshot =
          await _fireStore.collection('projects').doc(projectId).get();
      final data = snapshot.data();
      if (data != null) {
        return Project.fromMap(data);
      }
      throw GeneralErrorException(message: 'Project not found');
    });
  }

  Future<Project> updateProject(
      {required String projectId,
      String? title,
      String? projectGoal,
      int? duration,
      bool? completed}) async {
    return exceptionCatcher(() async {
      Map<String, dynamic> updatedData = {
        if (title != null) 'title': title,
        if (projectGoal != null) 'goal': projectGoal,
        if (completed != null) 'allTasksCompleted': completed,
        if (duration != null) 'duration': duration,
      };
      await _fireStore
          .collection('projects')
          .doc(projectId)
          .update(updatedData);
      final project = await getSingleProject(projectId: projectId);
      return project;
    });
  }

  Future<void> deleteProject(String projectId) async {
    final tasksCollection = FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .collection('tasks');
    return exceptionCatcher(() async {
      // Fetch all tasks and delete them
      final tasksSnapshot = await tasksCollection.get();
      for (var taskDoc in tasksSnapshot.docs) {
        await taskDoc.reference.delete();
      }

      // Delete the project document
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .delete();
    });
  }

  Future<Project> markProjectAsComplete({required String projectId}) async {
    return exceptionCatcher(() async {
      final project = await getSingleProject(projectId: projectId);

      if (project.allTasksCompleted == false) {
        final project =
            await updateProject(projectId: projectId, completed: true);
        return project;
      }
      throw GeneralErrorException(message: 'Project already completed');
    });
  }
}
