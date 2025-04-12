import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addmembers.dart';
import 'chat.dart';
import 'createtask.dart';
import 'taskdetail.dart';
import 'update_project_member.dart';

class DetailPage extends StatefulWidget {
  final String projectId;
  const DetailPage({required this.projectId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isEditing = false;
  String _currentUserEmail = '';
  List<String> _assignedMembers = [];
  Map<String, dynamic> _tasks = {};
  String? _dueDate;
  String? _category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserEmail = prefs.getString('user_email') ?? '';
    });
    _loadProjectData();
  }

  Future<void> _loadProjectData() async {
    final sanitizedEmail = _currentUserEmail.replaceAll('.', ',');
    
    _db.child('members/$sanitizedEmail/projects/${widget.projectId}').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _titleController.text = data['name'] ?? 'Project Title';
          _descriptionController.text = data['description'] ?? 'Project Description';
          _assignedMembers = List<String>.from(data['assign_to'] ?? []);
          _dueDate = data['due_date'];
          _category = data['catogory'];
          _tasks = data['tasks'] != null ? Map<String, dynamic>.from(data['tasks']) : {};
        });
      }
    });
  }

  Color _getAvatarColor(String email) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
    return colors[email.hashCode % colors.length];
  }

  String _getInitials(String email) {
    final parts = email.split('@').first.split('.');
    if (parts.length > 1) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return email.substring(0, 2).toUpperCase();
  }

  Future<void> _updateProject() async {
    final sanitizedEmail = _currentUserEmail.replaceAll('.', ',');
    await _db.child('members/$sanitizedEmail/projects/${widget.projectId}').update({
      'name': _titleController.text,
      'description': _descriptionController.text
    });
    setState(() => _isEditing = false);
  }

  Future<void> _toggleTaskStatus(String taskId, bool newStatus) async {
    final sanitizedEmail = _currentUserEmail.replaceAll('.', ',');
    
    // Update task status
    await _db.child('members/$sanitizedEmail/projects/${widget.projectId}/tasks/$taskId/status').set(newStatus);
    
    // Get task details
    final taskSnapshot = await _db.child('members/$sanitizedEmail/projects/${widget.projectId}/tasks/$taskId').get();
    if (taskSnapshot.exists) {
      final taskData = taskSnapshot.value as Map<dynamic, dynamic>;
      final complextivity = taskData['complextivity'] ?? 1;
      final pointsToAdd = complextivity * 5 * (newStatus ? 1 : -1);
      final assignTo = List<String>.from(taskData['assign_to'] ?? []);
      
      // Update points for each assigned member
      for (final memberEmail in assignTo) {
        final sanitizedMemberEmail = memberEmail.replaceAll('.', ',');
        final memberRef = _db.child('members/$sanitizedMemberEmail');
        
        final memberSnapshot = await memberRef.get();
        if (memberSnapshot.exists) {
          final currentPoints = memberSnapshot.child('points').value as int? ?? 0;
          await memberRef.update({'points': currentPoints + pointsToAdd});
        }
      }
    }
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
        actions: [
          IconButton(
            icon: Icon(Icons.chat, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Chat())),
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
            _buildWhiteCard(_buildAssignedSection()),
            SizedBox(height: 20),
            _buildWhiteCard(_buildTaskSection()),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                label: Text("Feedback", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
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
          child: Image.asset('assets/pie chart.png', width: 50, height: 50),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Image.asset('assets/smartphone notifications.png', width: 50, height: 50),
        ),
        Positioned(
          bottom: 70,
          right: 10,
          child: Image.asset('assets/desk calendar.png', width: 50, height: 50),
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
                    child: _isEditing
                        ? TextField(
                            controller: _titleController,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            _titleController.text,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  IconButton(
                    icon: Icon(_isEditing ? Icons.check : Icons.edit, size: 20, color: Colors.deepPurple),
                    onPressed: () => _isEditing ? _updateProject() : setState(() => _isEditing = true),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _isEditing
                  ? TextField(
                      controller: _descriptionController,
                      style: TextStyle(color: Colors.black),
                      maxLines: 3,
                    )
                  : Text(
                      _descriptionController.text,
                      style: TextStyle(color: Colors.black),
                    ),
              SizedBox(height: 8),
              if (_dueDate != null)
                Text(
                  "Due date: ${_formatDate(_dueDate!)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              if (_category != null)
                Text(
                  "Category: $_category",
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${_getWeekday(date.weekday)}, ${date.day} ${_getMonth(date.month)}}";
    } catch (e) {
      return dateString;
    }
  }

  String _getWeekday(int weekday) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return weekdays[weekday - 1];
  }

  String _getMonth(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  Widget _buildAssignedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Assigned to", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final selected = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProjectMembers(
                      projectId: widget.projectId,
                      currentUserEmail: _currentUserEmail,
                      existingMembers: _assignedMembers,
                    ),
                  ),
                ).then((selectedMembers) {
                  if (selectedMembers != null) {
                    setState(() => _assignedMembers = selectedMembers);
                  }
                });
                if (selected != null) {
                  final updatedMembers = [..._assignedMembers, ...selected].toSet().toList();
                  final sanitizedEmail = _currentUserEmail.replaceAll('.', ',');
                  await _db.child('members/$sanitizedEmail/projects/${widget.projectId}/assign_to')
                    .set(updatedMembers);
                }
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _assignedMembers.map((email) => CircleAvatar(
            backgroundColor: _getAvatarColor(email),
            child: Text(_getInitials(email), style: TextStyle(color: Colors.white)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildTaskSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Createtaskpage(projectId: widget.projectId),
                ),
              ),
            ),
          ],
        ),
        if (_tasks.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: Text("No tasks yet")),
          )
        else
          ..._tasks.entries.map((entry) => _buildTaskItem(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildTaskItem(String taskId, dynamic taskData) {
    final name = taskData['name'] ?? 'Unnamed Task';
    final description = taskData['description'] ?? '';
    final status = taskData['status'] ?? false;
    final complextivity = taskData['complextivity'] ?? 1;
    final dueDate = taskData['due_date'] ?? '';
    final assignTo = List<String>.from(taskData['assign_to'] ?? []);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TaskDetailPage(
            projectId: widget.projectId,
            taskId: taskId,
          ),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: status,
              onChanged: (value) => _toggleTaskStatus(taskId, value ?? false),
            ),
            title: Text(name, style: TextStyle(fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description.isNotEmpty) Text(description),
                SizedBox(height: 4),
                Row(
                  children: [
                    Image.asset('assets/Flag.png', width: 10, height: 10),
                    SizedBox(width: 8),
                    Text("${complextivity * 5} pts"),
                    if (dueDate.isNotEmpty) ...[
                      SizedBox(width: 16),
                       //Image.asset('assets/calendar.png', width: 10, height: 10),
                      SizedBox(width: 8),
                      Text(_formatDate(dueDate)),
                    ],
                  ],
                ),
              ],
            ),
            trailing: SizedBox(
              width: 70,
              height: 40,
              child: Stack(
                children: List.generate(assignTo.length, (index) {
                  if (index < 3) {
                    return Positioned(
                      left: index * 15,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: _getAvatarColor(assignTo[index]),
                        child: Text(
                          _getInitials(assignTo[index]),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else if (index == 3) {
                    return Positioned(
                      left: 3 * 15,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey[300],
                        child: Text(
                          '+${assignTo.length - 3}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    );
                  }
                  return Container();
                }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: LinearProgressIndicator(
              value: status ? 1 : 0.4,
              backgroundColor: Colors.purple[100],
              color: Colors.purple,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}