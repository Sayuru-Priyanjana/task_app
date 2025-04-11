import 'package:flutter/material.dart';
import 'office.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final List<Map<String, String>> allProjects = [
    {"title": "Green sky Website Dev", "dueDate": "Thursday, 20 July 2023"},
    {"title": "Grocery app design", "dueDate": "Thursday, 10 July 2023"},
    {
      "title": "Development planning\nw3 technologies",
      "dueDate": "Friday, 25 July 2023"
    },
    {"title": "Fitness app development", "dueDate": "Monday, 30 July 2023"},
    {
      "title": "Product Launch\nInnovate LTD",
      "dueDate": "Monday, 30 July 2023"
    },
  ];

  List<Map<String, String>> selectedProjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "All",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                print("Selected Projects: $selectedProjects");

                Navigator.pop(context, selectedProjects);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: allProjects.length,
                itemBuilder: (context, index) {
                  final project = allProjects[index];
                  final isSelected = selectedProjects.contains(project);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedProjects.remove(project);
                        } else {
                          selectedProjects.add(project);
                        }
                      });

                      print("Updated Selected Projects: $selectedProjects");
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.deepPurple.withOpacity(0.5)
                            : Color(0xFF7700FF).withOpacity(0.21),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project["title"]!,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Due date: ${project["dueDate"]!}",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
