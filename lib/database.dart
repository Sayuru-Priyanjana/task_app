import 'package:flutter/material.dart';

class FeedbackDatabaseScreen extends StatelessWidget {
  final String employeeName = "David";
  final String eventProjectTitle = "ABC"; // Updated to be generic
  final String manager = "Charles"; // Updated to be generic
  final String role = "Team Lead"; // Updated to be generic
  final String date = "22/05/2022";

  final List<Map<String, dynamic>> feedbackData = [
    {
      'statement': 'Manager led and motivated team', // Updated
      'rating': 3,
      'comment': 'Excellent leadership',
    },
    {
      'statement': 'Manager demonstrated self control', // Updated
      'rating': 3,
      'comment': 'Very calm under pressure',
    },
    {
      'statement': 'Manager allowed suggestions', // Updated
      'rating': 2,
      'comment': 'Could improve in listening',
    },
    {
      'statement': 'Manager handled team conflicts', // Updated
      'rating': 3,
      'comment': 'Resolved issues well',
    },
    {
      'statement': 'Event/Project was well managed by manager', // Updated
      'rating': 3,
      'comment': 'Very smooth process',
    },
    {
      'statement': 'Manager communicated objectives clearly', // Updated
      'rating': 3,
      'comment': 'Everyone was clear',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback Summary"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Employee Name: $employeeName",
                style: TextStyle(fontSize: 16)),
            Text("Event/Project Title: $eventProjectTitle", // Updated
                style: TextStyle(fontSize: 16)),
            Text("Role: $role", style: TextStyle(fontSize: 16)), // Updated
            Text("Manager: $manager",
                style: TextStyle(fontSize: 16)), // Updated
            Text("Date: $date", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FlexColumnWidth(3.5),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Statement",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Rating",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Comment",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                ...feedbackData.map(
                  (item) => TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(item['statement']),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(item['rating'].toString()),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(item['comment']),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
