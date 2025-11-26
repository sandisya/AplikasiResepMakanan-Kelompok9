import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DapurKu",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),

      home: SplashScreen(), // tanpa const

      routes: {
        '/home': (_) => HomeScreen(),
      },
    );
  }
}
