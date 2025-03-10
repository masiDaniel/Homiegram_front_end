import 'package:flutter/material.dart';
import 'package:homi_2/providers/user_provider.dart';
import 'package:homi_2/views/Shared/about_app.dart';
import 'package:homi_2/views/Shared/splash_screen.dart';
import 'package:homi_2/views/Tenants/navigation_bar.dart';
import 'package:homi_2/views/Tenants/all_houses.dart';
import 'package:homi_2/views/Tenants/home_page_v1.dart';
import 'package:homi_2/views/Tenants/house_list_screen.dart';
import 'package:homi_2/views/Tenants/search_page.dart';
import 'package:homi_2/views/landlord/management.dart';
import 'package:homi_2/views/sign_in.dart';
import 'package:homi_2/views/Shared/sign_up.dart';
import 'package:homi_2/views/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for SharedPreferences to be initialized before running the app
  final initialRoute = await getInitialRoute();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()..loadUserData()),
  ], child: MyApp(initialRoute: initialRoute)));
}

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      initialRoute: initialRoute,
      // should refactor on this to user flutters way
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const WelcomePage(),
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
      appBar: AppBar(
        title: const Text("Not Found"),
      ),
      body: Container(
        color: const Color(0xFF0b8793),
        height: 300,
        width: 300,
      ),
    );
  }
}
