import 'package:flutter/material.dart';
import 'package:homi_2/models/ads.dart';
import 'package:homi_2/models/chat.dart';
import 'package:homi_2/views/Shared/chat_page.dart';
import 'package:homi_2/views/Tenants/chat_page.dart';
import 'package:video_player/video_player.dart';

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

  void _markChatAsRead(int index) {
    setState(() {
      chats[index].markAsRead();
    });
  }

  late Future<List<Ad>> futureAds;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _getFilteredChats();
    futureAds = fetchAds();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "HomiGram.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 16, 90, 1),
                            fontSize: 40,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Ad>>(
                  future: futureAds,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Image.asset(
                          'assets/images/splash.jpeg', // Fallback image path
                          fit: BoxFit.contain,
                        ),
                      );
                    } else {
                      final ads = snapshot.data!;
                      return Column(
                        children: ads.map((ad) {
                          return Container(
                            height: 300,
                            width: 400,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.green,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ad.imageUrl != null
                                ? Image.network(
                                    ad.imageUrl!,
                                    fit: BoxFit.fill,
                                  )
                                : ad.videoUrl != null
                                    ? FutureBuilder(
                                        future:
                                            initializeVideoPlayer(ad.videoUrl!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return AspectRatio(
                                              aspectRatio: _videoController!
                                                  .value.aspectRatio,
                                              child: VideoPlayer(
                                                  _videoController!),
                                            );
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      )
                                    : Center(
                                        child: Text("No content available")),
                          );
                        }).toList(),
                      );
                    }
                  },
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
                  height: 500,
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
                                return InkWell(
                                  onTap: () {
                                    _markChatAsRead(index);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                            chat: filteredChats[index]),
                                      ),
                                    );
                                  },
                                  child: ChatCard(chat: filteredChats[index]),
                                );
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

  Future<void> initializeVideoPlayer(String videoUrl) async {
    _videoController = VideoPlayerController.network(videoUrl);
    await _videoController!.initialize();
    setState(() {});
    _videoController!.play();
  }
}
