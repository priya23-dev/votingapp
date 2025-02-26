import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chart_screen.dart';
import 'screens/favourite_screen.dart';
import 'screens/profile_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Votely',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register' : (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/chart': (context) => const ChartScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/profile': (context) => const ProfileScreen(),

      },
    );
  }
}
