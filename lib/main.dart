import 'package:flutter/material.dart';
import './pages/login.dart';
import 'package:firebase_core/firebase_core.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Tesis_Admin",
      debugShowCheckedModeBanner: false,
      home: SignInPage1(),
    );
  }
}