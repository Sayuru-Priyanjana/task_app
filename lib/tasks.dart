import 'package:flutter/material.dart';
import 'Notifications.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final Color customPurple = Color(0xFF5F33E1);
  String selectedFilter = "All";
  String selectedDate = "25";

  List<Map<String, dynamic>> allTasks = [
    // Tasks for March 23
    {
      "category": "Mobile App Development",
      "title": "Setup Firebase",
      "time": "09:00 AM",
      "status": "In Progress",
      "date": "23",
      "color": Colors.orange
    },
    {
      "category": "Marketing Campaign",
      "title": "Social Media Planning",
      "time": "02:00 PM",
      "status": "To-do",
      "date": "23",
      "color": Colors.blueAccent
    },

    // Tasks for March 24
    {
      "category": "Product Launch",
      "title": "Create Landing Page",
      "time": "11:00 AM",
      "status": "Done",
      "date": "24",
      "color": Colors.green
    },
    {
      "category": "Meeting",
      "title": "Client Discussion",
      "time": "04:00 PM",
      "status": "In Progress",
      "date": "24",
      "color": Colors.orange
    },

    // Tasks for March 25
    {
      "category": "Grocery shopping app",
      "title": "Market Research",
      "time": "10:00 AM",
      "status": "Done",
      "date": "25",
      "color": Colors.green
    },
    {
      "category": "Grocery shopping app",
      "title": "Competitive Analysis",
      "time": "12:00 PM",
      "status": "In Progress",
      "date": "25",
      "color": Colors.orange
    },

    // Tasks for March 26
    {
      "category": "Uber Eats redesign",
      "title": "Wireframe",
      "time": "07:00 PM",
      "status": "To-do",
      "date": "26",
      "color": Colors.blueAccent
    },

    // Tasks for March 27
    {
      "category": "Design Sprint",
      "title": "How to pitch",
      "time": "09:00 PM",
      "status": "To-do",
      "date": "27",
      "color": Colors.blueAccent
    },
  ];

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
          "Tasks",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()));
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            _buildDatePicker(),
            SizedBox(height: 16),
            _buildFilterButtons(),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _getFilteredTasks().map((task) {
                  return _buildTaskCard(task["category"], task["title"],
                      task["time"], task["status"], task["color"]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredTasks() {
    return allTasks.where((task) {
      bool matchesDate = task["date"] == selectedDate;
      bool matchesFilter =
          selectedFilter == "All" || task["status"] == selectedFilter;
      return matchesDate && matchesFilter;
    }).toList();
  }

  Widget _buildDatePicker() {
    List<Map<String, String>> dates = [
      {"day": "23", "week": "Fri"},
      {"day": "24", "week": "Sat"},
      {"day": "25", "week": "Sun"},
      {"day": "26", "week": "Mon"},
      {"day": "27", "week": "Tue"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: dates.map((date) {
        bool isSelected = date["day"] == selectedDate;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date["day"]!;
            });
          },
          child: Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: isSelected ? customPurple : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(date["week"]!, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 4),
                Text(
                  date["day"]!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilterButtons() {
    List<String> filters = ["All", "To-do", "In Progress", "Done"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: filters.map((filter) {
        bool isSelected = filter == selectedFilter;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedFilter = filter;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? customPurple : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: customPurple),
            ),
            child: Text(
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : customPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTaskCard(
      String category, String title, String time, String status, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: customPurple, size: 16),
                SizedBox(width: 4),
                Text(
                  time,
                  style: TextStyle(
                      fontSize: 14,
                      color: customPurple,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                _buildStatusTag(status, color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(String status, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
