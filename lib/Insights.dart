import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:multicast_dns/multicast_dns.dart';
import 'dnsDiscovery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';



class InsightsPage extends StatefulWidget {
  @override
  _InsightsPageState createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {

Future<List<LeaderboardEntry>> fetchLeaderboard() async {
  // Get IP from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final String? serverIp = prefs.getString('ip');
  print('Server IP: $serverIp');
  
  if (serverIp == null) {
    throw Exception('No server IP found in SharedPreferences');
  }

  // Make API call using the stored IP
  final response = await http.get(
    Uri.parse('http://$serverIp:5000/leaderboard'),
    headers: {"Content-Type": "application/json"},
  );
  
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => LeaderboardEntry.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load leaderboard: ${response.statusCode}');
  }
}

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  Map<DateTime, int> _heatmapData = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHeatmapData();
  }

Future<void> _loadHeatmapData() async {
    print('🔥 Starting heatmap data load');
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userEmail = prefs.getString('user_email');

      if (userEmail == null) {
        print('🚫 No user email found');
        setState(() {
          _errorMessage = 'User not logged in';
          _isLoading = false;
        });
        return;
      }

      final sanitizedEmail = userEmail.replaceAll('.', ',');
      print('📧 Sanitized email: $sanitizedEmail');

      final snapshot = await _dbRef.child('members/$sanitizedEmail/projects').get();
      print('📦 Firebase snapshot exists: ${snapshot.exists}');

      final Map<DateTime, int> newData = {};
      int taskCount = 0;

      if (snapshot.exists) {
        final projects = snapshot.value as Map<dynamic, dynamic>;

        projects.forEach((projectId, projectData) {
          final tasks = (projectData as Map)['tasks'] as Map<dynamic, dynamic>?;

          tasks?.forEach((taskId, taskData) {
            try {
              final status = taskData['status'] ?? false;
              final completedDateStr = taskData['completed_date'];
              final priority = taskData['priority'] ?? 3;

              if (status == true && completedDateStr != null) {
                final completedDate = DateTime.parse(completedDateStr.toString());
                final dateKey = DateTime(completedDate.year, completedDate.month, completedDate.day);

                if (!newData.containsKey(dateKey) || priority < newData[dateKey]!) {
                  newData[dateKey] = priority;
                }
                taskCount++;
              }
            } catch (e) {
              print('❌ Error processing task $taskId: $e');
            }
          });
        });
      }

      print('📊 Tasks counted: $taskCount');
      print('🧩 Raw newData keys: ${newData.keys.toList()}');

      setState(() {
        _heatmapData = newData;
        _isLoading = false;
        _errorMessage = null;
      });

      print('📊 Heatmap data loaded: $_heatmapData');

    } catch (e) {
      print('‼️ Critical error: $e');
      setState(() {
        _errorMessage = 'Failed to load activity data';
        _isLoading = false;
      });
    }
  }

  List<DateTime> _generateLast35Days() {
    final today = DateTime.now();
    return List.generate(35, (i) {
      final date = today.subtract(Duration(days: 34 - i));
      return DateTime(date.year, date.month, date.day);
    });
  }

Widget _buildHeatMap() {
  // Activity intensity colors (from low to high)
  final List<Color> intensityColors = [
    Colors.grey[300]!,    // Low
    Color(0xFF9473F1),    // Medium
    Color(0xFF7C46F0),    // High
    Colors.deepPurple,    // Very High
  ];

  // Month labels (April is index 3, May is 4)
  final List<String> months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov"];

  return Column(
    children: [
      // Month labels
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(months.length, (index) {
          return Text(
            months[index],
            style: TextStyle(color: Colors.white70, fontSize: 10),
          );
        }),
      ),
      SizedBox(height: 8),
      // Heatmap grid
      Column(
        children: List.generate(5, (row) { // 5 rows
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(months.length, (col) {
              // April (col=3) - High activity
              if (col == 3) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: intensityColors[row % intensityColors.length], // Varying intensity
                    shape: BoxShape.circle,
                  ),
                );
              } 
              // May (col=4) - Low activity (only 2 dots)
              else if (col == 4 && row % 2 == 0) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: intensityColors[1], // Medium intensity
                    shape: BoxShape.circle,
                  ),
                );
              } 
              // Other months - empty
              else {
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                );
              }
            }),
          );
        }),
      ),
      // Legend
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // children: [
        //   _buildLegendDot(intensityColors[0], "Low"),
        //   _buildLegendDot(intensityColors[1], "Medium"),
        //   _buildLegendDot(intensityColors[2], "High"),
        // ],
      ),
    ],
  );
}

// Helper widget for legend dots
Widget _buildLegendDot(Color color, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    ),
  );
}
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: AppBar(
        title: const Text("Insights", 
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActivityGrid(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildLeaderboardSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5500FF).withOpacity(0.34),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monthly Activity Overview",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          _buildHeatMap(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Activity intensity scale:",
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
              ),
              _buildColorLegend(),
            ],
          ),
        ],
      ),
    );
  }


  
  Widget _buildColorLegend() {
    return Row(
      children: [
        _legendItem(Colors.grey[300]!, "Low"),
        _legendItem(const Color(0xFF9473F1), "Med"),
        _legendItem(const Color(0xFF7C46F0), "High"),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardSection() {
    return FutureBuilder<List<LeaderboardEntry>>(
      future: fetchLeaderboard(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No leaderboard data available'));
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Team Leaderboard",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildScoreLegend(),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  itemBuilder: (context, index) {
                    return _buildLeaderboardItem(snapshot.data![index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreLegend() {
    return Row(
      children: [
        _scoreLegendItem("SCORE", isHeader: true),
        _scoreLegendItem("TASKS"),
        
      ],
    );
  }

  Widget _scoreLegendItem(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(LeaderboardEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _rankColor(entry.rank),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${entry.rank}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complexity: L3 (${entry.complexity3}) • L4 (${entry.complexity4})',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          _buildMetricColumn("${entry.scorePercentage}%", 
              Color(0xFF7C46F0)),
          _buildMetricColumn("${entry.totalTasks}", Colors.grey[600]!),
        
               
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _rankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return const Color(0xFF7C46F0);
  }
}

class LeaderboardEntry {
  final String name;
  final String email;
  final int rank;
  final double score;
  final int totalTasks;
  final double onTimeRate;
  final int complexity3;
  final int complexity4;

  LeaderboardEntry({
    required this.name,
    required this.email,
    required this.rank,
    required this.score,
    required this.totalTasks,
    required this.onTimeRate,
    required this.complexity3,
    required this.complexity4,
  });

  double get scorePercentage => (score * 100).clamp(0, 100);

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      rank: json['rank'] ?? 0,
      score: (json['score'] as num).toDouble(),
      totalTasks: json['total_tasks'] ?? 0,
      onTimeRate: (json['on_time_rate'] as num).toDouble(),
      complexity3: json['complexity_3'] ?? 0,
      complexity4: json['complexity_4'] ?? 0,
    );
  }
}