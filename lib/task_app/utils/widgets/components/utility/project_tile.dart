import 'package:flutter/material.dart';
import 'package:task_app/task_app/features/projects/model/project/projects_model.dart';

import '../text/protask_text.dart';

class ProjectTile extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  bool isHighlighted = false;

  ProjectTile(
      {super.key,
      required this.project,
      required this.onTap,
      required this.isHighlighted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 5, top: 5),
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          height: isHighlighted == true ? 150 : 100,
          width: double.maxFinite,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              //border:Border.all(color: const Color.fromARGB(255, 219, 225, 230)),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade100, offset: Offset(3, 3)),
                BoxShadow(color: Colors.grey.shade100, offset: Offset(-3, -3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            //spacing: 5,
            children: [
              Row(
                children: [
                  Expanded( // Expands to fill available space
                    child: ProtaskCustomText(
                      color: isHighlighted
                          ? const Color.fromARGB(255, 0, 140, 255)
                          : Colors.black,
                      fontSize: isHighlighted ? 25 : 20,
                      fontWeight: FontWeight.bold,
                      text: project.title,
                    ),
                  ),
                  const SizedBox(width: 8), // Add spacing between text and icon
                  Icon(
                    Icons.check_circle,
                    color: project.allTasksCompleted ? Colors.green : Colors.grey.shade100,
                  ),
                ],
              ),

              Expanded(
                child: ProtaskCustomText(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  text: 'Duration: ${project.duration} Day(s)',
                ),
              ),
              Expanded(
                child: ProtaskCustomText(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w200,
                  text: project.goal,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
