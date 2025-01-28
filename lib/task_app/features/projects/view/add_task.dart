import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../authentication/controller/service/auth_service_provider.dart';
import '../controller/state/projects_state_provider.dart';

// class AddTaskView extends StatefulWidget {
//   const AddTaskView({super.key});
//   static const path = '/add_task';

//   @override
//   State<AddTaskView> createState() => _AddTaskViewState();
// }

// class _AddTaskViewState extends State<AddTaskView> {
//   final _authProvider = TaskAppAuthServiceProvider();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   void _addTask({
//     required String title,
//     required String description,
//     required String userID,
//   }) {
//     context.read<HomeStateProvider>().addProject(title, description, userID);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final taskProvider = context.read<HomeStateProvider>();
//     final errorMessage = taskProvider.errorMessage;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add a Task'),
//       ),
//       body: Column(
//         spacing: 18,
//         children: [
//           TextField(
//             controller: _titleController,
//             decoration: const InputDecoration(labelText: 'Name your task'),
//           ),
//           TextField(
//             controller: _descriptionController,
//             decoration: const InputDecoration(labelText: 'Describe your task'),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 taskProvider.clearError();

//                 _addTask(
//                   title: _titleController.text.trim(),
//                   description: _descriptionController.text.trim(),
//                   userID: _authProvider.getCurrentUser().uid,
//                 );

//                 if (errorMessage != null) {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text(errorMessage)));
//                   return;
//                 }

//                 Navigator.pop(context);
//               },
//               child: const Text('Add task'))
//         ],
//       ),
//     );
//   }
// }
