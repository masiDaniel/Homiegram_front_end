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

  //this will hold the current filter selection
  String selectedFilter = 'All';

  // Sample chat list
  final List<Chat> chats = [
    Chat(
        chatName: "Landlord Maina",
        lastMessage: "Welcome to heri",
        unreadMessage: 1),
    Chat(
        chatName: "Heri Group Chat",
        lastMessage: "Party at 5",
        unreadMessage: 0),
    Chat(
        chatName: "Complaints",
        lastMessage: "Will be completed tomorrow",
        unreadMessage: 4),
    Chat(
        chatName: "Liquor",
        lastMessage: "Will be completed tomorrow",
        unreadMessage: 0),
    Chat(
        chatName: "Food",
        lastMessage: "Will be completed tomorrow",
        unreadMessage: 0),
  ];

  // Function to filter chats based on the selected filter
  List<Chat> _getFilteredChats() {
    if (selectedFilter == 'Unread') {
      return chats.where((chat) => chat.unreadMessage > 0).toList();
    } else if (selectedFilter == 'Groups') {
      return chats.where((chat) => chat.chatName.contains('Group')).toList();
    } else {
      return chats; // 'All' or default
    }
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'http://127.0.0.1:8000';
    List Unread = chats.where((chat) => chat.unreadMessage > 0).toList();

    final filteredChats = _getFilteredChats();

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
                    Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text("All"),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          selected: true,
                          selectedColor: Colors.green,
                          backgroundColor: Colors.blue,
                          checkmarkColor: Colors.red,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedFilter = 'All'; // Update filter
                            });
                          },
                        )
                      ],
                    ),
                    Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: Text("Unread - ${Unread.length}"),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          selected: true,
                          selectedColor: Colors.green,
                          backgroundColor: Colors.blue,
                          checkmarkColor: Colors.red,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedFilter = 'Unread'; // Update filter
                            });
                          },
                        )
                      ],
                    ),
                    Wrap(
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text("Groups - 1"),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          selected: true,
                          selectedColor: Colors.green,
                          backgroundColor: Colors.blue,
                          checkmarkColor: Colors.red,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedFilter = 'Groups'; // Update filter
                            });
                          },
                        )
                      ],
                    ),
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
                              key: ValueKey(selectedFilter),
                              itemCount: filteredChats.length,
                              itemBuilder: (context, index) {
                                return ChatCard(chat: filteredChats[index]);
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
