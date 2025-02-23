import 'package:flutter/material.dart';
import 'package:to_do_app/screens/homeScreen.dart';
import 'package:to_do_app/signin.dart';
import 'package:to_do_app/login.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      title: 'ToDo App',
      initialRoute: _getInitialRoute(),
      routes: {
        '/signin': (context) => const SignInPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }

  String _getInitialRoute() {
    // Replace with actual logic to check if the user is signed in
    bool isSignedIn = false; // Example placeholder
    return isSignedIn ? '/home' : '/login';
  }
}
