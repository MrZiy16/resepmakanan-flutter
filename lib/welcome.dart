import 'package:flutter/material.dart';
import 'package:myapp/sign_in.dart';
import 'dart:async';

// Asumsikan ini adalah halaman utama aplikasi Anda


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => SignInScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Atau warna latar belakang pilihan Anda
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo
            Image.asset(
              'assets/logo.jpg', // Pastikan untuk mengganti dengan path logo Anda
              width: 200, // Sesuaikan ukuran logo
            ),
            SizedBox(height: 24),
            // Teks
            Text(
              'Kulinerin',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Sesuaikan warna teks
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Tempatnya Resep Lezat!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}