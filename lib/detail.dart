import 'package:flutter/material.dart';
import 'addmembers.dart';
import 'chat.dart';
import 'database.dart';
import 'createtask.dart';
import 'taskdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {

  // final String projectId;
  // const DetailPage({required this.projectId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String projectTitle = "Green Sky Website Dev";
  String projectDescription =
      "GreenSky DG focuses on evaluating and developing solar opportunities for landholders";
  bool isEditing = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
    String _currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    titleController.text = projectTitle;
    descriptionController.text = projectDescription;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }



  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserEmail = prefs.getString('user_email') ?? '';
     
    });
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        projectTitle = titleController.text;
        projectDescription = descriptionController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Details",
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
            _buildProjectInfoCard(),
            SizedBox(height: 20),
            _buildWhiteCard(_buildAssignedSection(context)),
            SizedBox(height: 20),
            _buildWhiteCard(_buildTaskSection(context)),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                label: Text(
                  "Feedback",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FeedbackDatabaseScreen()),
                  );
                },
              ),
            ),
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

  Widget _buildProjectInfoCard() {
    return Stack(
      children: [
        Positioned(
          top: 10,
          left: 120,
          child: Image.asset(
            'assets/pie chart.png',
            width: 50,
            height: 50,
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Image.asset(
            'assets/smartphone notifications.png',
            width: 50,
            height: 50,
          ),
        ),
        Positioned(
          bottom: 70,
          right: 10,
          child: Image.asset(
            'assets/desk calendar.png',
            width: 50,
            height: 50,
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF7700FF).withOpacity(0.21),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: isEditing
                        ? TextField(
                            controller: titleController,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          )
                        : Text(
                            projectTitle,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  IconButton(
                    icon: Icon(
                      isEditing ? Icons.check : Icons.edit,
                      size: 20,
                      color: Colors.deepPurple,
                    ),
                    onPressed: _toggleEditing,
                  ),
                ],
              ),
              SizedBox(height: 8),
              isEditing
                  ? TextField(
                      controller: descriptionController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: 2,
                    )
                  : Text(
                      projectDescription,
                      style: TextStyle(color: Colors.black),
                    ),
              SizedBox(height: 8),
              Text(
                "Due date: Thursday, 20 July 2023",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
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
                  MaterialPageRoute(builder: (context) => MembersPage(
                    currentUserEmail: _currentUserEmail,
                  )),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.deepPurple,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) => _buildAvatar()),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, color: Colors.white),
      ),
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
              "Task",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Createtaskpage()),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
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
        _buildTaskItem(context, "Create Design System", 20, true),
        _buildTaskItem(context, "Create Wireframe", 18, true),
        _buildTaskItem(context, "Landing Page Design", 8, false),
        _buildTaskItem(context, "Mobile Screen Design", 40, false),
      ],
    );
  }

  Widget _buildTaskItem(
      BuildContext context, String task, int hours, bool completed) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailPage(),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: completed ? Colors.blue : Colors.grey,
            ),
            title: Text(task, style: TextStyle(fontSize: 16)),
            subtitle: Row(
              children: [
                Image.asset(
                  'assets/Flag.png',
                  width: 10,
                  height: 10,
                ),
                SizedBox(width: 8),
                Text("$hours hr"),
              ],
            ),
            trailing: _buildCombinedAvatars(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: LinearProgressIndicator(
              value: completed ? 1 : 0.4,
              backgroundColor: Colors.purple[100],
              color: Colors.purple,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCombinedAvatars() {
    return SizedBox(
      width: 70,
      height: 40,
      child: Stack(
        children: [
          Positioned(left: 0, child: _buildAvatar()),
          Positioned(left: 15, child: _buildAvatar()),
          Positioned(left: 30, child: _buildAvatar()),
        ],
      ),
    );
  }
}
