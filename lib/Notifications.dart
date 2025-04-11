import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildNotificationSection(
                "Recently", Color(0xFF7700FF).withOpacity(0.21), [
              _buildTaskCompletedNotification(
                  "Marvin McKinney",
                  "UX Research",
                  "Banking mobile app",
                  "Mar 13, 2022",
                  'assets/human 1.png',
                  'assets/Thumbnail.png'),
              _buildJoinRequestNotification("Cody Fisher", "Medical Dashboard",
                  "Mar 13, 2022", 'assets/human 2.png'),
            ]),
            const SizedBox(height: 20),
            _buildNotificationSection("Older", Colors.white, [
              _buildTaskCompletedNotification(
                  "Leslie Alexander",
                  "UX Research",
                  "SEO e-commerce website",
                  "Mar 13, 2022",
                  'assets/human 3.png',
                  'assets/Thumbnaill.png'),
              _buildJoinRequestNotification(
                  "Jerome Bell",
                  "Health track Dashboard",
                  "Mar 13, 2022",
                  'assets/human 4.png'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(
      String title, Color backgroundColor, List<Widget> notifications) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A8E9E))),
          const SizedBox(height: 10),
          ...notifications,
        ],
      ),
    );
  }

  Widget _buildTaskCompletedNotification(String name, String task,
      String project, String date, String avatar, String projectImage) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(avatar)),
          title: Row(
            children: [
              Expanded(
                child: Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF5F33E1))),
              ),
              Text(date,
                  style: const TextStyle(color: Colors.black, fontSize: 12)),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Online',
                  style: TextStyle(color: Colors.green, fontSize: 12)),
              const SizedBox(height: 4),
              Text('$name completed "$task" task in "$project" project.',
                  style: const TextStyle(color: Colors.black)),
            ],
          ),
          trailing: Image.asset(projectImage,
              width: 40, height: 40, fit: BoxFit.cover),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildJoinRequestNotification(
      String name, String project, String date, String avatar) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(avatar)),
          title: Row(
            children: [
              Expanded(
                child: Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF5F33E1))),
              ),
              Text(date,
                  style: const TextStyle(color: Colors.black, fontSize: 12)),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Online',
                  style: TextStyle(color: Colors.green, fontSize: 12)),
              const SizedBox(height: 4),
              Text('$name sent you a request to join "$project" project.',
                  style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton("Decline", const Color(0xFF5F33E1)),
            _buildActionButton("Allow", const Color(0xFF5F33E1)),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      onPressed: () {},
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
