import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🔥 INIT LANGUAGE
  final langService = LanguageService();
  await langService.loadLanguage();

  runApp(
    ChangeNotifierProvider(
      create: (_) => langService,
      child: const MyApp(),
    ),
  );
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