import 'package:flutter/material.dart';

class MembersPage extends StatefulWidget {
  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final List<String> members = [
    "John Doe",
    "Tharushi kavindya",
    "pamaya hussen",
    "dilshan kavindu",
    "pramuda Davis",
    "Elina wickramge",
    "samindi kularathna",
    "Grace Black",
  ];

  List<String> filteredMembers = [];
  Set<String> selectedMembers = Set();

  @override
  void initState() {
    super.initState();
    filteredMembers = members;
  }

  void filterMembers(String query) {
    setState(() {
      filteredMembers = members
          .where((member) => member.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void toggleMemberSelection(String member) {
    setState(() {
      if (selectedMembers.contains(member)) {
        selectedMembers.remove(member);
      } else {
        selectedMembers.add(member);
        print(selectedMembers);
      }
    });
  }

  void addSelectedMembers() {
    // Here you would typically do something with the selected members
    print("Added members: $selectedMembers");
    Navigator.pop(context, selectedMembers.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Add Members",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          if (selectedMembers.isNotEmpty)
            IconButton(
              icon: Icon(Icons.done, color: Colors.deepPurple),
              onPressed: addSelectedMembers,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search members...",
                prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
              onChanged: filterMembers,
            ),
          ),
          if (selectedMembers.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    "${selectedMembers.length} selected",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedMembers.clear();
                      });
                    },
                    child: Text(
                      "Clear",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                final member = filteredMembers[index];
                final isSelected = selectedMembers.contains(member);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isSelected ? Colors.deepPurple : Colors.deepPurple[100],
                    child: Icon(Icons.person,
                        color: isSelected ? Colors.white : Colors.deepPurple),
                  ),
                  title: Text(
                    member,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: Colors.deepPurple)
                      : Icon(Icons.add, color: Colors.deepPurple),
                  onTap: () => toggleMemberSelection(member),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
