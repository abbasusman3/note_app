import 'package:anab_notes/screen_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:anab_notes/sqflite.dart'; // Assuming this file handles your SQLite database logic

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized before running code

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ScreenDashboard(),
    );
  }
}
