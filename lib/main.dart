import 'package:flutter/material.dart';
import 'package:flutter_todo_web/pages/home.dart';
import 'package:flutter_todo_web/pages/login_signup.dart';
import 'package:flutter_todo_web/utils/PageStyle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: PageStyle().secondaryColor,
        ),
      ),
      home: const LoginSignupPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
