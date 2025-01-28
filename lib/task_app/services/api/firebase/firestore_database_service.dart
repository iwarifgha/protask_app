import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/features/profile/model/user_model.dart';

import '../../../features/tasks/model/task/task_model.dart';

class FirestoreDatabase {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
//----------------TASKS METHODS-------------------//

  Future<Task> addTask({required String projectId, required Task task}) async {
    final doc = await FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .collection('tasks')
        .doc()
        .set(task.toMap());

    final singleTask =
        await getSingleTask(projectId: projectId, taskId: task.taskId);
    return singleTask;
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
      throw Exception('Project not found');
    } catch (e) {
      throw Exception(e.toString());
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
    } catch (e) {
      throw Exception(e);
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
    } on Exception catch (e) {
      throw Exception(e);
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
    } on Exception catch (e) {
      throw Exception(e.toString);
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
    } catch (e) {
      throw Exception(e);
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
    } catch (e) {
      throw Exception(e);
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
        throw Exception('No user is currently logged in');
      }

      // Step 1: Update Firebase Auth
      if (displayName != null || photoUrl != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoUrl);
      }

      if (email != null && email != user.email) {
        await user.verifyBeforeUpdateEmail(email);
      }

      // Step 2: Update Firestore
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
    } catch (e) {
      print('Error updating user details: $e');
      rethrow; // Re-throw the error for the caller to handle
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
    } catch (e) {
      throw Exception(e);
    }
  }

//----------------PROJECTS METHODS-------------------//

  Future<void> addProject({required Project project}) async {
    try {
      await _fireStore
          .collection('projects')
          .doc(project.projectId)
          .set(project.toMap());
    } catch (e) {
      throw Exception(e);
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
    } catch (e) {
      throw Exception(e);
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
    } catch (e) {
      throw Exception(e.toString());
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
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteProject(String projectId) async {
    final tasksCollection = FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .collection('tasks');

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
  }
}
