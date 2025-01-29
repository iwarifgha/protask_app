import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';
import 'package:task_app/task_app/utils/exceptions/exceptions.dart';

import '../../../../features/tasks/model/task/task_model.dart';

class FirestoreDatabase {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
//----------------TASKS METHODS-------------------//

  Future<Task> addTask({required String projectId, required Task task}) async {
    try {
    await FirebaseFirestore.instance
      .collection('projects')
      .doc(projectId)
      .collection('tasks')
      .doc()
      .set(task.toMap());
  
  final singleTask =
      await getSingleTask(projectId: projectId, taskId: task.taskId);
  return singleTask;
} on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

  Future<Task> getSingleTask({
    required String projectId,
    required String taskId,
  }) async {
    try {
      final snapshot = await _fireStore
          .collection('projects')
          .doc(projectId)
          .collection('tasks')
          .doc(taskId)
          .get();
      final data = snapshot.data();
      if (data != null) {
        return Task.fromMap(
          data,
          taskId: data['task_id'],
        );
      }
      throw UnexpectedErrorException(message: 'Project not found');
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

  Future<List<Task>> fetchTasks(String projectId) async {
    try {
      final snapshot = await _fireStore
          .collection('projects')
          .doc(projectId)
          .collection('tasks')
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Task.fromMap(
          data,
          taskId: data['task_id'],
        );
      }).toList();
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

  Future<void> editTask(
      {required String projectId,
      required String taskId,
      required Map<String, dynamic> fieldsToUpdate}) async {
    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .collection('tasks')
          .doc(taskId)
          .update(fieldsToUpdate);
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

  Future<void> deleteTask(
      {required String projectId, required String taskId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .collection('tasks')
          .doc(taskId)
          .delete();
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

//----------------USER PROFILE METHODS-------------------//

//CREATE USER PROFILE
  Future<void> createUserProfile({required UserProfile user}) async {
    DocumentReference userDoc = _fireStore.collection('users').doc(user.userId);

    try {
      // Check if user document already exists
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Add user data to Firestore
        await userDoc.set({user.toMap()});
      }
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

//GET USER PROFILE
  Future<UserProfile> getUserProfile({required String userId}) async {
    try {
      final snapshot = await _fireStore.collection('users').doc(userId).get();
      final user = snapshot.data();
      if (user != null) {
        return UserProfile.fromMap(user);
      }
      throw Exception('User not found');
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

//UPDATE USER PROFILE DETAILS
  Future<void> updateUserDetails({
    required String uid,
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    try {
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
      print('User details updated successfully');
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

//DELETE USER PROFILE
  Future<void> deleteUserProfile(userId) async {
    try {
      final userInAuth = _auth.currentUser;
      final userInFirestore = _fireStore.collection('users').doc(userId);

      if (userInAuth == null) {
        throw Exception('No user logged in');
      }

      //Delete from firebase Auth
      await userInAuth.delete();

      //delete from firestore
      await userInFirestore.delete();
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

//----------------PROJECTS METHODS-------------------//

  Future<void> addProject({required Project project}) async {
    try {
      await _fireStore
          .collection('projects')
          .doc(project.projectId)
          .set(project.toMap());
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

  Future<List<Project>> fetchProjects(String userId) async {
    try {
      final snapshot = await _fireStore
          .collection('projects')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Project.fromMap(data);
      }).toList();
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

  Future<Project> getSingleProject({required String projectId}) async {
    try {
      final snapshot =
          await _fireStore.collection('projects').doc(projectId).get();
      final data = snapshot.data();
      if (data != null) {
        return Project.fromMap(data);
      }
      throw Exception('Project not found');
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

  Future<Project> updateProject(
      {required String projectId, String? title, String? duration}) async {
    try {
      Map<String, dynamic> updatedData = {
        if (title != null) 'title': title,
        if (duration != null) 'duration': duration,
      };

      await _fireStore
          .collection('projects')
          .doc(projectId)
          .update(updatedData);

      final project = await getSingleProject(projectId: projectId);
      return project;
    } on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }

  Future<void> deleteProject(String projectId) async {
    
  final tasksCollection = FirebaseFirestore.instance
      .collection('projects')
      .doc(projectId)
      .collection('tasks');
  try {
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
} on SocketException {
      throw NoInternetException();
    } on HttpException {
      throw SomethingWentWrongException();
    } on FormatException {
      throw BadResponseException();
    } on FirebaseAuthException {
      throw UnexpectedErrorException(message: 'No user logged in');
    } on FirebaseException catch (e) {
      throw UnexpectedErrorException(
          message: 'An unexpected error occured, see here ${e.toString()}');
    } catch (e) {
      throw UnexpectedErrorException(message: 'An unexpected error occured');
    }
  }
}
