import 'package:flutter/material.dart';
import 'addmembers.dart';
import 'package:task_app/chat.dart';
import 'createtask.dart';

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  TextEditingController _projectNameController = TextEditingController();
  TextEditingController _projectDescriptionController = TextEditingController();
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Add New",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.chat, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Chat()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProjectInfoSection(),
            SizedBox(height: 20),
            _buildWhiteCard(_buildAssignedSection(context)),
            SizedBox(height: 20),
            _buildWhiteCard(_buildTaskSection(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteCard(Widget child) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildProjectInfoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF7700FF).withOpacity(0.21),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _projectNameController,
            decoration: InputDecoration(
              hintText: "Name",
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            autofocus: false, // Cursor appears when tapped
          ),
          SizedBox(height: 8),
          TextField(
            controller: _projectDescriptionController,
            decoration: InputDecoration(
              hintText: "Description",
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _dueDate == null
                    ? "Due Date: Add Due Date"
                    : "Due Date: ${_dueDate!.toLocal()}".split(' ')[0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today, color: Colors.deepPurple),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dueDate = pickedDate;
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Assigned to",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MembersPage()),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "No members assigned yet.",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTaskSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tasks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Createtaskpage()),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "No tasks added yet.",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class TaskDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
      ),
      body: Center(
        child: Text("Task detail page content here."),
      ),
    );
  }
}
