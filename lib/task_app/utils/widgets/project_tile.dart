import 'package:flutter/material.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';
import 'package:task_app/task_app/utils/widgets/protask_text.dart';

class ProjectTile extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectTile({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            //spacing: 5,
            children: [
              ProtaskCustomText(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                text: project.title,
              ),
              ProtaskCustomText(
                fontSize: 17,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                text: 'Duration: ${project.duration} Days',
              ),
              ProtaskCustomText(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w200,
                text: project.goal,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
