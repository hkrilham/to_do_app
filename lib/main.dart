import 'package:flutter/material.dart';
import 'package:to_do_app/homeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDu App',
      home: Homescreen(),
    );
  }
}
