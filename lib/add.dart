// add.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'addmembers.dart';

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectDescriptionController = TextEditingController();
  DateTime? _dueDate;
  List<String> _selectedMembers = [];
  String _currentUserEmail = '';
  String _selectedCategory = 'Office';
  final List<String> _categories = [
    'Office',
    'Personal',
    'Study',
    'Shopping',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserEmail = prefs.getString('user_email') ?? '';
      // Add current user to selected members automatically
      if (_currentUserEmail.isNotEmpty && !_selectedMembers.contains(_currentUserEmail)) {
        _selectedMembers.add(_currentUserEmail);
      }
    });
  }

  Future<void> _createProject() async {
    if (_projectNameController.text.isEmpty) {
      _showError('Project name is required');
      return;
    }

    try {
      final sanitizedEmail = _currentUserEmail.replaceAll('.', ',');
      final projectRef = _db.child('members/$sanitizedEmail/projects').push();
      
      final projectData = {
        'name': _projectNameController.text,
        'description': _projectDescriptionController.text,
        'catogory': _selectedCategory,
        'due_date': _dueDate != null 
            ? DateFormat('yyyy-MM-dd').format(_dueDate!)
            : '',
        'assign_to': _selectedMembers.map((email) => email.replaceAll('.', ',')).toList(),
        'tasks': {}
      };

      await projectRef.set(projectData);
      Navigator.pop(context, true);
    } catch (e) {
      _showError('Error creating project: ${e.toString()}');
    }
  }

void _showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ), // ✅ This closing comma is fine
  ); // ✅ Proper closing of showSnackBar
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("New Project", style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF5F33E1),
        child: Icon(Icons.save, color: Colors.white),
        onPressed: _createProject,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProjectInfoCard(),
            SizedBox(height: 20),
            _buildCategorySelector(),
            SizedBox(height: 20),
            _buildTeamMembersSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectInfoCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TextField(
            controller: _projectNameController,
            decoration: InputDecoration(
              labelText: 'Project Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _projectDescriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text(_dueDate == null 
                ? 'Select Due Date'
                : 'Due Date: ${DateFormat('yyyy-MM-dd').format(_dueDate!)}'),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() => _dueDate = pickedDate);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category', style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _selectedCategory,
            items: _categories.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() => _selectedCategory = newValue!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMembersSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Team Members', style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  final selected = await Navigator.push<List<String>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MembersPage(
                        currentUserEmail: _currentUserEmail,
                      ),
                    ),
                  );
                  if (selected != null) {
                    setState(() {
                      _selectedMembers = [..._selectedMembers, ...selected];
                    });
                  }
                },
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedMembers.map((email) => Chip(
              label: Text(email),
              deleteIcon: Icon(Icons.close, size: 16),
              onDeleted: () => setState(() => _selectedMembers.remove(email)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}