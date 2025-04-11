import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [
    {"text": "Hello! Jhon Abraham", "isMe": true, "time": "09:25 AM"},
    {"text": "Hello! Nazrul, How are you?", "isMe": false, "time": "09:25 AM"},
    {"text": "You did your job well!", "isMe": true, "time": "09:25 AM"},
    {"text": "Have a great working week!!", "isMe": false, "time": "09:25 AM"},
    {"text": "Hope you like it", "isMe": false, "time": "09:25 AM"},
    {"text": "Thanks.", "isMe": true, "time": "09:25 AM"},
  ];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          "text": _messageController.text,
          "isMe": true,
          "time": "09:26 AM"
        });
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.lerp(Colors.white, Color(0xFF7C46F0), 0.15)!,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Image.asset(
                "assets/stopwatch .png",
                width: 50,
                height: 50,
              ),
            ),
          ],
          flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 288,
                      height: 71,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Text("P"),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Project",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/Group.png",
                                  width: 40,
                                  height: 33,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Active now",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 2,
            left: (MediaQuery.of(context).size.width - 2000) / 2,
            child: Container(
              width: 2000,
              height: 850,
              decoration: BoxDecoration(
                color: Color(0xFF7700FF).withOpacity(0.21),
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset(
              "assets/desk calendar.png",
              width: 70,
              height: 70,
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Image.asset(
              "assets/smartphone notifications.png",
              width: 50,
              height: 50,
            ),
          ),
          Positioned(
            bottom: 90,
            left: 20,
            child: Image.asset(
              "assets/pie chart.png",
              width: 50,
              height: 50,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Image.asset(
              "assets/vase.png",
              width: 50,
              height: 500,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Center(
                  child: Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  reverse: false,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment: message["isMe"]
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: message["isMe"]
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!message["isMe"])
                            Image.asset(
                              "assets/human 1.png",
                              width: 30,
                              height: 30,
                            ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: message["isMe"]
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.all(12),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                decoration: BoxDecoration(
                                  color: message["isMe"]
                                      ? Colors.green
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  message["text"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: message["isMe"]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: message["isMe"] ? 10 : 0,
                                    left: message["isMe"] ? 0 : 10),
                                child: Text(
                                  message["time"],
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.blueGrey),
                                ),
                              ),
                            ],
                          ),
                          if (message["isMe"])
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Image.asset(
                                "assets/human 2.png",
                                width: 30,
                                height: 30,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_file, color: Colors.black54),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Write your message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.blue),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
