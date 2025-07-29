import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homi_2/chat%20feature/user_list_page.dart';
import 'package:homi_2/models/ads.dart';
import 'package:homi_2/models/chat.dart';
import 'package:homi_2/services/fetch_ads_service.dart';
import 'package:homi_2/services/user_data.dart';
import 'package:homi_2/services/user_sigin_service.dart';
import 'package:homi_2/views/Shared/ad_details_page.dart';
import 'package:homi_2/views/Shared/chat_page.dart';
import 'package:homi_2/views/Tenants/chat_page.dart';

import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool isConditionMet = true;

  String selectedFilter = 'All';

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

  List<Chat> _getFilteredChats() {
    if (selectedFilter == 'unRead') {
      return chats.where((chat) => chat.unreadMessage > 0).toList();
    } else if (selectedFilter == 'Groups') {
      return chats.where((chat) => chat.chatName.contains('Group')).toList();
    } else {
      return chats;
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
  late String authToken;
  late int user_id;
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
          _currentPage = 0;
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

  void getToken() {
    setState(() async {
      authToken = (await UserPreferences.getAuthToken())!;
      user_id = (await UserPreferences.getUserId())!;
    });
  }

  @override
  Widget build(BuildContext context) {
    List unRead = chats.where((chat) => chat.unreadMessage > 0).toList();

    final filteredChats = _getFilteredChats();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                  height: 5,
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
                                    color: const Color(0xFF105A01),
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
                        height: 300,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: ads.length,
                          itemBuilder: (context, index) {
                            final ad = ads[index];

                            return GestureDetector(
                              onTap: () {
                                _onAdTap(index);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UserListPage(
                                        jwtToken: authToken, userId: user_id),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
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
                                        aspectRatio: 16 / 9.5,
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
                                        borderRadius: BorderRadius.circular(12),
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
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: isConditionMet
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 2),
                                  child: Text("Homi Chat",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF105A01))),
                                ),
                                SizedBox(
                                  height: 48,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    children: [
                                      buildFilterChip(
                                          "All", selectedFilter == 'All',
                                          (val) {
                                        setState(() =>
                                            selectedFilter = val ? 'All' : '');
                                      }),
                                      buildFilterChip(
                                          "unRead - ${unRead.length}",
                                          selectedFilter == 'unRead', (val) {
                                        setState(() => selectedFilter =
                                            val ? 'unRead' : '');
                                      }),
                                      buildFilterChip("Groups - 1",
                                          selectedFilter == 'Groups', (val) {
                                        setState(() => selectedFilter =
                                            val ? 'Groups' : '');
                                      }),
                                      buildFilterChip("Stories",
                                          selectedFilter == 'Stories', (val) {
                                        setState(() => selectedFilter =
                                            val ? 'Stories' : '');
                                      }),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: filteredChats.isNotEmpty
                                        ? ListView.separated(
                                            key: ValueKey(selectedFilter),
                                            itemCount: filteredChats.length,
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(height: 12),
                                            itemBuilder: (context, index) {
                                              final chat = filteredChats[index];
                                              return GestureDetector(
                                                onTap: () {
                                                  _markChatAsRead(index);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(chat: chat),
                                                    ),
                                                  );
                                                },
                                                child: ChatCard(chat: chat),
                                              );
                                            },
                                          )
                                        : const Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.chat_bubble_outline,
                                                    size: 60,
                                                    color: Color(0xFF026B13)),
                                                SizedBox(height: 10),
                                                Text(
                                                  'No Chats Available',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF026B13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              key: ValueKey('comingSoon'),
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.upcoming,
                                        size: 80, color: Color(0xFF026B13)),
                                    SizedBox(height: 20),
                                    Text(
                                      'Chat Feature Unavailable',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Coming Soon!',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
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

  Widget buildFilterChip(
      String label, bool isSelected, Function(bool) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : Colors.black,
        ),
        selected: isSelected,
        selectedColor: const Color(0xFF105A01),
        backgroundColor: Colors.grey[200],
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: isSelected ? Colors.green : Colors.grey.shade300),
        ),
        onSelected: onSelected,
      ),
    );
  }
}

    // Lottie.asset('assets/animations/chatFeature.json',
                    //     width: double.infinity, height: 200),
                    // const SizedBox(height: 10),
                    // const Text("Lets manage your living space!",
                    //     style: TextStyle(fontSize: 18)),
