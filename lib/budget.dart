import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Budget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 8),
                Text(
                  "Budget Tracking",
                  style: TextStyle(
                    fontFamily: 'Lexend Deca',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildBudgetCard(
              context: context,
              title: "Total Earnings",
              amount: "\$50000.00",
              icon: Icons.attach_money,
              cardColor: Colors.green,
              iconColor: Colors.greenAccent,
            ),
            SizedBox(height: 16),
            _buildBudgetCard(
              context: context,
              title: "Total Spendings",
              amount: "\$45000.00",
              icon: Icons.money_off,
              cardColor: const Color.fromARGB(255, 246, 90, 79),
              iconColor: const Color.fromARGB(255, 246, 19, 3),
            ),
            SizedBox(height: 16),
            _buildBudgetCard(
              context: context,
              title: "Target Budget",
              amount: "\$200,000",
              icon: Icons.flag,
              cardColor: Color(0xFF7700FF).withOpacity(0.21),
              iconColor: Colors.purple,
            ),
            SizedBox(height: 16),
            _buildProgressCard(
              title: "Target Percentage",
              percentage: 75,
              cardColor: Colors.white,
              progressColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCard({
    required BuildContext context,
    required String title,
    required String amount,
    required IconData icon,
    required Color cardColor,
    required Color iconColor,
  }) {
    return Container(
      width: 2000,
      height: 140,
      child: Stack(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, size: 60, color: iconColor),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.black54),
              onPressed: () {
                _showEditDialog(context, title, amount);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required String title,
    required int percentage,
    required Color cardColor,
    required Color progressColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: progressColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            SizedBox(height: 8),
            Text(
              "$percentage%",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, String title, String currentValue) {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter new value",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                // Here you would typically save the new value
                print("New value for $title: ${controller.text}");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Budget(),
    debugShowCheckedModeBanner: false,
  ));
}
