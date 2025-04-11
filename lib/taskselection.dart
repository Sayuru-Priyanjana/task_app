import 'package:flutter/material.dart';

class TaskSelectionPage extends StatefulWidget {
  final List<String>? initialSelectedTasks;

  const TaskSelectionPage({Key? key, this.initialSelectedTasks})
      : super(key: key);

  @override
  _TaskSelectionPageState createState() => _TaskSelectionPageState();
}

class _TaskSelectionPageState extends State<TaskSelectionPage> {
  final List<String> _allTasks = [
    "Create Design System",
    "Develop Homepage",
    "Implement Authentication",
    "Database Integration",
    "API Development",
    "Mobile Responsiveness",
    "Testing",
    "Deployment"
  ];

  final List<String> _selectedTasks = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedTasks != null) {
      _selectedTasks.addAll(widget.initialSelectedTasks!);
    }
  }

  void _toggleTaskSelection(String task) {
    setState(() {
      if (_selectedTasks.contains(task)) {
        _selectedTasks.remove(task);
      } else {
        _selectedTasks.add(task);
      }
    });
  }

  void _confirmSelection() {
    Navigator.pop(context, _selectedTasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, const Color(0xFF7C46F0), 0.15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Select Tasks",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _confirmSelection,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _allTasks.length,
        itemBuilder: (context, index) {
          final task = _allTasks[index];
          final isSelected = _selectedTasks.contains(task);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            color:
                isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.white,
            child: ListTile(
              title: Text(task),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.deepPurple)
                  : null,
              onTap: () => _toggleTaskSelection(task),
            ),
          );
        },
      ),
    );
  }
}
