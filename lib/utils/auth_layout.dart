import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_web/pages/app_loading_page.dart';
import 'package:flutter_todo_web/pages/home.dart';
import 'package:flutter_todo_web/pages/login_signup.dart';
import 'package:flutter_todo_web/services/auth_services.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = const AppLoadingPage();
            } else if (snapshot.hasData) {
              widget = const Home();
            } else {
              widget = pageIfNotConnected ?? const LoginSignupPage();
            }
            return widget;
          },
        );
      },
    );
  }
}
