// addmembers.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MembersPage extends StatefulWidget {
  final String currentUserEmail;

  const MembersPage({required this.currentUserEmail});

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  List<String> _allMembers = [];
  List<String> _filteredMembers = [];
  Set<String> _selectedMembers = Set();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final snapshot = await _db.child('members').get();
    if (snapshot.exists) {
      final membersMap = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _allMembers = membersMap.keys
            .where((key) => key != widget.currentUserEmail.replaceAll('.', ','))
            .map((key) => key.toString().replaceAll(',', '.'))
            .toList();
        _filteredMembers = _allMembers;
      });
    }
  }

  void _filterMembers(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredMembers = _allMembers.where((email) 
          => email.toLowerCase().contains(_searchQuery)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: AppBar(
        title: Text('Select Members'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedMembers.toList()),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by email...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterMembers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMembers.length,
              itemBuilder: (context, index) {
                final email = _filteredMembers[index];
                return CheckboxListTile(
                  title: Text(email),
                  value: _selectedMembers.contains(email),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedMembers.add(email);
                      } else {
                        _selectedMembers.remove(email);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}