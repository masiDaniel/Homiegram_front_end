import 'package:flutter/material.dart';
import 'package:homi_2/models/chat.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Shared/chat_page.dart';
import 'package:homi_2/views/Tenants/student_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// get this into a seperate function that can be used in differenet files
String _extractInitials(String name) {
  List<String> nameParts = name.split(' ');
  if (nameParts.isNotEmpty) {
    return nameParts[0][0].toUpperCase(); // First letter of the first name
  } else {
    return ''; // Return empty string if name is empty
  }
}

class _HomePageState extends State<HomePage> {
  final bool isConditionMet = true;
  @override
  Widget build(BuildContext context) {
    String baseUrl = 'http://127.0.0.1:8000';
    final chats = [
      Chat(
          chatName: "Landlord Maina",
          lastMessage: "Welcome to heri",
          unreadMessage: 2),
      Chat(
          chatName: "Heri Group Chat",
          lastMessage: "Party at 5",
          unreadMessage: 0),
      Chat(
          chatName: "Complaints",
          lastMessage: "Will be completed tomorrow",
          unreadMessage: 1),
      Chat(
          chatName: "Liqour",
          lastMessage: "Will be completed tomorrow",
          unreadMessage: 1),
      Chat(
          chatName: "Food",
          lastMessage: "Will be completed tomorrow",
          unreadMessage: 1),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFEFFFF),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const studentDashboardView()),
                        );
                      },
                      child: CircleAvatar(
                        foregroundImage: imageUrl != null
                            ? NetworkImage('$baseUrl$imageUrl')
                            : null,
                        backgroundColor: const Color(0xFF126E06),
                        child: imageUrl != null
                            ? null
                            : Text(
                                _extractInitials('$firstName'),
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Welcome back, $firstName",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 22,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text('Rent status'),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 300,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.green, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(12.0), // Rounded edges
                  ),
                  child: Image.asset(
                    'assets/images/ad2.jpeg',
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'All - 6',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Unread - 6',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Groups - 1',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 400,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: isConditionMet
                          ? ListView.builder(
                              itemCount: chats.length,
                              itemBuilder: (context, index) {
                                return ChatCard(chat: chats[index]);
                              },
                            )
                          : const Center(
                              key: ValueKey('animation'),
                              child:
                                  CircularProgressIndicator(), // Example animation, can be any other widget
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
