import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projet_patient/Page/dossiermedical.dart';
import 'package:projet_patient/Page/homepage.dart';
import 'package:projet_patient/Page/profilepage.dart';
import 'package:projet_patient/Page/rdvpage.dart';
import 'package:projet_patient/auth/login.dart';
import 'package:projet_patient/firebase_options.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return MyHomePage();
        }
        return LoginScreen();
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  int selectedIndex = 0;
  final List<Widget> pages = [
    AcceuilPage(),
    DossierPage(),
    RdvPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: pages,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: onButtonPressed,
        iconSize: 30,
        activeColor: const Color.fromARGB(255, 0, 145, 255),
        selectedIndex: selectedIndex,
        barItems: <BarItem>[
          BarItem(icon: Icons.home, title: 'Accueil'),
          BarItem(icon: Icons.menu_book, title: 'Dossier_Médical'),
          BarItem(icon: Icons.event_available, title: 'Rendez-vous'),
          BarItem(icon: Icons.person, title: 'Profile'),
        ],
      ),
    );
  }
}
