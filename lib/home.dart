import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_app/Insights.dart';
import 'add.dart';
import 'budget.dart';
import 'office.dart';
import 'personal.dart';
import 'tasks.dart';
import 'user.dart';
import 'events.dart';
import 'detail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'catogery_projects.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showAllTasks = false;
  bool _showAllProjects = false;
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Guest';
      userEmail = prefs.getString('user_email') ?? 'No email';
    });
  }

  @override
  Widget build(BuildContext context) {
    final double fullWidth = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 20),
              _buildTaskProgressCard(context),
              SizedBox(height: 20),
              _buildCard(
                'Add',
                Icons.add,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProjectPage()),
                  );
                },
                width: fullWidth,
                isCentered: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCard('Budget', Icons.attach_money_sharp, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Budget()),
                    );
                  }, width: (fullWidth - 8) / 2),
                  _buildCard('Insights', CupertinoIcons.graph_square_fill, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InsightsPage()),
                    );
                  }, width: (fullWidth - 8) / 2),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle("In Progress", 4),
              _buildInProgressTasks(),
              SizedBox(height: 5),
              _buildSectionTitle("Categories", 3),
              _buildTaskGroups(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/girly.jpg'),
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(userName ?? "Guest",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskProgressCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your today's task\nalmost done!",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TasksPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Text("View Task",
                    style: TextStyle(color: Colors.deepPurple)),
              ),
            ],
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                    value: 0.85,
                    color: Colors.white,
                    backgroundColor: Colors.white24),
                Text("85%",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            if (title == "Categories")
              GestureDetector(
                onTap: () => _addNewCategory(context),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple, shape: BoxShape.circle),
                  child: Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
        Text("$count", style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  void _addNewCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String newCategory = "";
        return AlertDialog(
          title: Text("Add New Category"),
          content: TextField(
            decoration: InputDecoration(
              hintText: "Enter category name",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => newCategory = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (newCategory.isNotEmpty) {
                  print("New Category: $newCategory");
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInProgressTasks() {
    final DatabaseReference _db = FirebaseDatabase.instance.ref();
    String? currentUserEmail;

    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final prefs = snapshot.data as SharedPreferences;
          currentUserEmail = prefs.getString('user_email');
          
          if (currentUserEmail == null) {
            return Center(child: Text("User not logged in"));
          }

          final sanitizedEmail = currentUserEmail!.replaceAll('.', ',');
          
          return StreamBuilder(
            stream: _db.child('members/$sanitizedEmail/projects').onValue,
            builder: (context, projectSnapshot) {
              if (projectSnapshot.hasError) {
                return Center(child: Text("Error loading projects"));
              }

              if (projectSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!projectSnapshot.hasData || projectSnapshot.data!.snapshot.value == null) {
                return Center(child: Text("No projects found"));
              }

              final projectsMap = projectSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              final projects = projectsMap.entries.map((entry) {
                return {
                  'id': entry.key,
                  'title': entry.value['name'] ?? 'No Name',
                  'category': entry.value['catogory'] ?? 'No Category',
                  'color': _getCategoryColor(entry.value['catogory'] ?? 'Other'),
                };
              }).toList();

              return Column(
                children: [
                  ...projects.take(_showAllProjects ? projects.length : 2).map((project) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(projectId: project['id']),
                          ),
                        );
                      },
                      child: _buildTaskCard(
                        project['title'],
                        project['category'],
                        project['color'],
                      ),
                    );
                  }).toList(),
                  if (projects.length > 2)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllProjects = !_showAllProjects;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _showAllProjects ? "Show Less" : "Show More",
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                          Icon(
                            _showAllProjects ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Color _getCategoryColor(String category) {
    const colors = {
      'Office': Colors.lightBlue,
      'Personal': Colors.orangeAccent,
      'Study': Colors.purple,
      'Shopping': Colors.pink,
      'Other': Colors.green,
    };
    return colors[category] ?? Colors.grey;
  }

  Widget _buildTaskCard(String title, String category, Color progressColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: category == "Office Project"
            ? Colors.lightBlue[100]
            : category == "Personal Project"
                ? Colors.orange[100]
                : category == "Events"
                    ? Colors.pink[100]
                    : category == "My Project"
                        ? Colors.purple[100]
                        : Colors.lightBlue[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: TextStyle(fontSize: 14, color: Colors.grey)),
          SizedBox(height: 5),
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          LinearProgressIndicator(
              value: 0.5,
              color: progressColor,
              backgroundColor: Colors.grey[300]),
        ],
      ),
    );
  }

Widget _buildTaskGroups(BuildContext context) {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  String? currentUserEmail;

  return FutureBuilder(
    future: SharedPreferences.getInstance(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
  final prefs = snapshot.data as SharedPreferences;
  final currentUserEmail = prefs.getString('user_email');

  if (currentUserEmail == null) {
    return Center(child: Text("User not logged in"));
  }

  final sanitizedEmail = currentUserEmail.replaceAll('.', ',');

        
        return StreamBuilder(
          stream: _db.child('members/$sanitizedEmail/projects').onValue,
          builder: (context, projectSnapshot) {
            if (projectSnapshot.hasError) {
              return Center(child: Text("Error loading categories"));
            }

            if (projectSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!projectSnapshot.hasData || projectSnapshot.data!.snapshot.value == null) {
              return Center(child: Text("No categories found"));
            }

            final projectsMap = projectSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            Map<String, int> categoryCounts = {};

            projectsMap.forEach((_, project) {
              final category = project['catogory'] ?? 'Uncategorized';
              categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
            });

            return Column(
              children: categoryCounts.entries.map((entry) {
                final category = entry.key;
                final count = entry.value;
                
                return _buildTaskGroup(
                  category,
                  count,
                  0.5, // Replace with actual progress calculation
                  _getCategoryColor(category),
                  context,
                  CategoryProjectsScreen(category: category),
                );
              }).toList(),
            );
          },
        );
      }
      return Center(child: CircularProgressIndicator());
    },
  );
}

  Widget _buildCard(String title, IconData icon, VoidCallback onTap,
      {double? width, bool isCentered = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: width ?? double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 1),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment:
                isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(icon, size: 19),
              SizedBox(width: 10),
              Text(title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskGroup(String title, int tasks, double progress,
      Color progressColor, BuildContext context, Widget? destination) {
    return GestureDetector(
      onTap: () {
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2))
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("$tasks Tasks", style: TextStyle(color: Colors.grey)),
          trailing: SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                    value: progress,
                    color: progressColor,
                    backgroundColor: Colors.grey[300]),
                Text("${(progress * 100).toInt()}%",
                    style: TextStyle(
                        color: progressColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}