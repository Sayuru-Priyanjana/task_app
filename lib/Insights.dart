import 'package:flutter/material.dart';

class InsightsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: AppBar(
        title: Text("Insights", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActivityGrid(),
            SizedBox(height: 20),
            _buildLeaderboard(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityGrid() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF5500FF).withOpacity(0.34),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Month wise activity of your team",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 10),
          _buildHeatMap(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Learn how we count contributions",
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              _buildColorLegend(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeatMap() {
    List<Color> colors = [
      Colors.black,
      Colors.teal,
      Colors.lightBlueAccent,
      Colors.deepPurpleAccent
    ];

    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(11, (index) {
            return Text(
              months[index],
              style: TextStyle(color: Colors.white70, fontSize: 10),
            );
          }),
        ),
        SizedBox(height: 5),
        Column(
          children: List.generate(6, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(11, (col) {
                return Container(
                  margin: EdgeInsets.all(2),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colors[(row + col) % colors.length],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildColorLegend() {
    return Row(
      children: [
        Text("Less", style: TextStyle(color: Colors.white70, fontSize: 12)),
        SizedBox(width: 5),
        _legendBox(Colors.black),
        _legendBox(Colors.teal),
        _legendBox(Colors.lightBlueAccent),
        Text("More", style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _legendBox(Color color) {
    return Container(
      width: 16,
      height: 16,
      margin: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildLeaderboard() {
    List<Map<String, dynamic>> users = [
      {"name": "User 1", "progress": 45, "image": "assets/human 1.png"},
      {"name": "User 2", "progress": 53, "image": "assets/human 2.png"},
      {"name": "User 3", "progress": 85, "image": "assets/human 3.png"},
      {"name": "User 4", "progress": 20, "image": "assets/human 4.png"},
      {"name": "User 5", "progress": 100, "image": "assets/man.png"},
    ];

    users.sort((a, b) => b["progress"].compareTo(a["progress"]));

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Member leaderboard",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 10),
          Column(
            children: users.map((user) => _buildUserProgress(user)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProgress(Map<String, dynamic> user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(user["image"]),
            radius: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: user["progress"] / 100,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(0xFF9473F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Color(0xFF9473F1),
            radius: 15,
            child: Text("${user["progress"]}%",
                style: TextStyle(color: Colors.white, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
