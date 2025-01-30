import 'package:flutter/material.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';

class ProjectTile extends StatelessWidget {
  final Project project;

  const ProjectTile({super.key, required this.project});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          ProtaskCustomText(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            text: project.title,
          ),
          ProtaskCustomText(
            fontSize: 20,
            color: Colors.black12,
            fontWeight: FontWeight.w400,
            text: '${project.duration} Days',
          ),
          ProtaskCustomText(
            fontSize: 20,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            text: project.goal,
          ),
        ],
      ),
    );
  }
}
