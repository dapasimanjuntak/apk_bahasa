import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ tambahkan ini
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // wajib sebelum Firebase
  await Firebase.initializeApp(); // inisialisasi Firebase
  print("🔥 Firebase Initialized");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APK Bahasa',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(), // halaman awal login
    );
  }
}