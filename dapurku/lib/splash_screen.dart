import 'package:flutter/material.dart';
import 'dart:async';

// ignore: use_key_in_widget_constructors
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // Tambahkan key

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

// ignore: unused_element
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Timer 3 detik lalu pindah ke halaman Home
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna cream seperti di desain Figma
      backgroundColor: const Color(0xFFFDF6EC),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar panci (gambar1.png)
            Image.asset(
              'assets/images/gambar1.png',
              width: 120,
            ),

            const SizedBox(height: 20),

            // Teks judul aplikasi
            const Text(
              "DapurKu",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B00),
              ),
            ),

            const SizedBox(height: 40),

            // Gambar makanan (gambar2.png)
            Image.asset(
              'assets/images/gambar2.png',
              width: 180,
            ),
          ],
        ),
      ),
    );
  }
}
