import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(124, 70, 240, 0.15),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "About"),
              Tab(text: "Work"),
              Tab(text: "Activity"),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/girly.jpg"),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Livia Vaccaro",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 1),
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Text("Joined ",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black)),
                            Text("Sep 2018",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      print("Edit Profile pressed");
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  AboutSection(),
                  WorkSection(),
                  ActivitySection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutSection extends StatefulWidget {
  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool isEditingBio = false;
  bool isEditingWeb = false;
  TextEditingController bioController = TextEditingController(
      text:
          "Livia Vaccora is a skilled problem solver with expertise in software development and system optimization. Over four years, she has honed her abilities in coding, debugging, and project management.");
  TextEditingController websiteController =
      TextEditingController(text: "www.portfolio.e");
  TextEditingController phoneController =
      TextEditingController(text: "626-398-654");

  // Focus nodes for managing focus
  FocusNode bioFocusNode = FocusNode();
  FocusNode websiteFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  @override
  void dispose() {
    bioController.dispose();
    websiteController.dispose();
    phoneController.dispose();
    bioFocusNode.dispose();
    websiteFocusNode.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("BIO", style: _sectionTitleStyle),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    isEditingBio = !isEditingBio;
                    if (isEditingBio) {
                      // Request focus when entering edit mode
                      FocusScope.of(context).requestFocus(bioFocusNode);
                    } else {
                      // Save changes when done editing
                      print("New BIO: ${bioController.text}");
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          isEditingBio
              ? TextFormField(
                  controller: bioController,
                  focusNode: bioFocusNode,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  autofocus: true,
                )
              : Text(
                  bioController.text,
                  style: _bodyTextStyle,
                ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("ON THE WEB", style: _sectionTitleStyle),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    isEditingWeb = !isEditingWeb;
                    if (isEditingWeb) {
                      // Request focus on the first field when entering edit mode
                      FocusScope.of(context).requestFocus(websiteFocusNode);
                    } else {
                      // Save changes when done editing
                      print(
                          "New Web Info: ${websiteController.text}, ${phoneController.text}");
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          isEditingWeb
              ? Column(
                  children: [
                    TextFormField(
                      controller: websiteController,
                      focusNode: websiteFocusNode,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.link),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      autofocus: true,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: phoneController,
                      focusNode: phoneFocusNode,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildInfoRow(Icons.link, websiteController.text),
                    _buildInfoRow(Icons.phone, phoneController.text),
                  ],
                ),
        ],
      ),
    );
  }
}

class WorkSection extends StatefulWidget {
  @override
  _WorkSectionState createState() => _WorkSectionState();
}

class _WorkSectionState extends State<WorkSection> {
  bool isEditingWork = false;
  TextEditingController typeController =
      TextEditingController(text: "Software Engineer");
  TextEditingController locationController =
      TextEditingController(text: "Pasadena, CA");
  TextEditingController experienceController =
      TextEditingController(text: "4 years");

  // Focus nodes
  FocusNode typeFocusNode = FocusNode();
  FocusNode locationFocusNode = FocusNode();
  FocusNode experienceFocusNode = FocusNode();

  @override
  void dispose() {
    typeController.dispose();
    locationController.dispose();
    experienceController.dispose();
    typeFocusNode.dispose();
    locationFocusNode.dispose();
    experienceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("WORK INFORMATION", style: _sectionTitleStyle),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    isEditingWork = !isEditingWork;
                    if (isEditingWork) {
                      // Focus the first field when entering edit mode
                      FocusScope.of(context).requestFocus(typeFocusNode);
                    } else {
                      // Save changes when done editing
                      print(
                          "New Work Info: ${typeController.text}, ${locationController.text}, ${experienceController.text}");
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          isEditingWork
              ? Column(
                  children: [
                    TextFormField(
                      controller: typeController,
                      focusNode: typeFocusNode,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.work),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: "Type",
                      ),
                      autofocus: true,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: locationController,
                      focusNode: locationFocusNode,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: "Location",
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: experienceController,
                      focusNode: experienceFocusNode,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.star),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: "Experience",
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildInfoRow(Icons.work, "Type: ${typeController.text}"),
                    _buildInfoRow(Icons.location_on, locationController.text),
                    _buildInfoRow(
                        Icons.star, "Experience: ${experienceController.text}"),
                  ],
                ),
          SizedBox(height: 16),
          Text("STATS", style: _sectionTitleStyle),
          SizedBox(height: 8),
          Row(
            children: [
              _buildStatBox("17", "Projects"),
              SizedBox(width: 16),
              _buildStatBox("92%", "Success Rate"),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildStatBox("5", "Teams"),
              SizedBox(width: 16),
              _buildStatBox("243", "Client Reports"),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("RECENT ACTIVITY", style: _sectionTitleStyle),
          SizedBox(height: 16),
          _buildActivityItem("Completed Project X", "2 hours ago"),
          _buildActivityItem("Joined Team Y", "1 day ago"),
          _buildActivityItem("Updated Profile", "3 days ago"),
        ],
      ),
    );
  }
}

Widget _buildInfoRow(IconData icon, String text) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 16, color: Colors.black)),
      ],
    ),
  );
}

Widget _buildStatBox(String value, String label) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF7700FF).withOpacity(0.21),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        ],
      ),
    ),
  );
}

Widget _buildActivityItem(String title, String time) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(Icons.circle, color: Colors.blue, size: 8),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
            Text(time, style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ],
    ),
  );
}

final TextStyle _sectionTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

final TextStyle _bodyTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.grey[700],
);
