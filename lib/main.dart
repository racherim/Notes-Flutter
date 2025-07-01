import 'package:flutter/material.dart';
import 'package:flutter_todo_web/pages/login_signup.dart';
import 'package:flutter_todo_web/utils/PageStyle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());

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
