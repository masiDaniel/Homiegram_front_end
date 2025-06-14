import 'package:flutter/material.dart';
import 'package:homi_2/providers/user_provider.dart';
import 'package:homi_2/services/theme_provider.dart';
import 'package:homi_2/views/Shared/about_app.dart';
import 'package:homi_2/views/Shared/splash_screen.dart';
import 'package:homi_2/views/Shared/video_splash_screen.dart';
import 'package:homi_2/views/Tenants/navigation_bar.dart';
import 'package:homi_2/views/Shared/all_houses.dart';
import 'package:homi_2/views/Shared/home_page_v1.dart';
import 'package:homi_2/views/Tenants/house_list_screen.dart';
import 'package:homi_2/views/Shared/search_page.dart';
import 'package:homi_2/views/landlord/management.dart';
import 'package:homi_2/views/Shared/sign_in.dart';
import 'package:homi_2/views/Shared/sign_up.dart';
import 'package:homi_2/views/Shared/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialRoute = await getInitialRoute();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()..loadUserData()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ], child: MyApp(initialRoute: initialRoute)));
}

///
/// (TODO): Have an internet test on launch, and how to keep it accurate
///
///

Future<String> getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // Go to homescreen if logged in
  return isLoggedIn ? '/homescreen' : '/';
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HG',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      initialRoute: initialRoute,
      // home: const WelcomePage(),
      home: const VideoSplashScreen(),
      // should refactor on this to user flutters way
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomePage(),
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
        '/about': (context) => AboutHomiegram(),
        '/homepage': (context) => const HomePage(),
        '/homescreen': (context) => const CustomBottomNavigartion(),
        '/allHouses': (context) => const AllHouses(),
        '/trialAllHouses': (context) => const HouseListScreen(),
        '/searchPage': (context) => const SearchPage(),
        '/landlordManagement': (context) => const LandlordManagement(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const NotFoundPage(), // Handle unknown routes
        );
      },
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF126E06),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Oops!"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                "404 - Page Not Found",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Sorry, the page you are looking for doesn't exist or has been moved.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.home),
                label: const Text("Go Back Home"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
