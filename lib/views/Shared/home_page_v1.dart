import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homi_2/models/ads.dart';
import 'package:homi_2/models/chat.dart';
import 'package:homi_2/services/fetch_ads_service.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Shared/chat_page.dart';
import 'package:homi_2/views/Tenants/chat_page.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
    if (selectedFilter == 'unRead') {
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
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  bool _isPaused = false;
  late List<Ad> ads;

  @override
  void initState() {
    super.initState();
    _getFilteredChats();
    futureAds = fetchAds();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isPaused && _pageController.hasClients) {
        _currentPage++;

        if (_currentPage >= ads.length) {
          _currentPage = 0; // Reset to the first ad
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onAdTap(int index) {
    setState(() {
      _isPaused = !_isPaused;
      _currentPage = index;
    });
    if (_isPaused) {
      _timer?.cancel();
    } else {
      _startAutoScroll();
    }
  }

  @override
  Widget build(BuildContext context) {
    List unRead = chats.where((chat) => chat.unreadMessage > 0).toList();

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
                        "Homigram.",
                        style: TextStyle(
                            color: Color(0xFF105A01),
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
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 6.0,
                          ),
                          SizedBox(height: 10),
                          Text("Loading, please wait...",
                              style: TextStyle(fontSize: 16)),
                        ],
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 250,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF105A01),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 48,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        "No advertisements available",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ads = snapshot.data!;
                      return SizedBox(
                        height: 320,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: ads.length,
                          itemBuilder: (context, index) {
                            final ad = ads[index];
                            bool isSelected =
                                _isPaused && _currentPage == index;

                            return GestureDetector(
                              onTap: () => _onAdTap(index),
                              child: Stack(
                                children: [
                                  // Ad Container
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade300,
                                      borderRadius: BorderRadius.circular(12.0),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 5,
                                            offset: Offset(0, 3)),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: AspectRatio(
                                        aspectRatio: 16 /
                                            9, // Maintain a uniform aspect ratio
                                        child: ad.imageUrl != null
                                            ? Image.network(
                                                '$devUrl${ad.imageUrl!}',
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/splash.jpeg',
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),

                                  // Title Overlay
                                  Positioned(
                                    bottom: 15,
                                    left: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 4, 104, 3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        ad.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),

                                  // Expanded Content Overlay when clicked
                                  if (isSelected)
                                    Positioned.fill(
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        opacity: 1.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0B110C)
                                                .withAlpha((0.5 * 255).toInt()),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(ad.title,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(height: 8),
                                              Text(ad.description,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 16)),
                                              const SizedBox(height: 10),
                                              Text(
                                                  'Start Date: ${ad.startDate}',
                                                  style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14)),
                                              const SizedBox(height: 5),
                                              Text('End Date: ${ad.endDate}',
                                                  style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    // Lottie.asset('assets/animations/chatFeature.json',
                    //     width: double.infinity, height: 200),
                    // const SizedBox(height: 10),
                    // const Text("Lets manage your living space!",
                    //     style: TextStyle(fontSize: 18)),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: isConditionMet
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                          selected: selectedFilter == 'All',
                                          selectedColor:
                                              const Color(0xFF105A01),
                                          backgroundColor: Colors.green,
                                          checkmarkColor: Colors.white,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedFilter =
                                                  selected ? 'All' : '';
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
                                          label:
                                              Text("unRead - ${unRead.length}"),
                                          labelStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          selected: selectedFilter == 'unRead',
                                          selectedColor:
                                              const Color(0xFF105A01),
                                          backgroundColor: Colors.green,
                                          checkmarkColor: Colors.white,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedFilter =
                                                  selected ? 'unRead' : '';
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
                                          selected: selectedFilter == 'Groups',
                                          selectedColor:
                                              const Color(0xFF105A01),
                                          backgroundColor: Colors.green,
                                          checkmarkColor: Colors.white,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedFilter =
                                                  selected ? 'Groups' : '';
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
                                          label: const Text("stories"),
                                          labelStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          selected: selectedFilter == 'Stories',
                                          selectedColor:
                                              const Color(0xFF105A01),
                                          backgroundColor: Colors.green,
                                          checkmarkColor: Colors.white,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedFilter =
                                                  selected ? 'stories' : '';
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: filteredChats.isNotEmpty
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
                                                      builder: (context) =>
                                                          ChatPage(
                                                              chat:
                                                                  filteredChats[
                                                                      index]),
                                                    ),
                                                  );
                                                },
                                                child: ChatCard(
                                                    chat: filteredChats[index]),
                                              );
                                            },
                                          )
                                        : const Center(
                                            key: ValueKey('noChats'),
                                            child: Text(
                                              'No Chats Available',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            )
                          : const Padding(
                              padding: EdgeInsets.all(100.0),
                              child: Center(
                                key: ValueKey('comingSoon'),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.build_circle,
                                        size: 50, color: Color(0xFF026B13)),
                                    SizedBox(height: 10),
                                    Text(
                                      'Chat Feature Unavailable\nComing Soon!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
