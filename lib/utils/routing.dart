import 'package:flutter/material.dart';
import 'package:flutter_todo_web/pages/home.dart';
import 'package:flutter_todo_web/pages/profile_page.dart';
import 'package:flutter_todo_web/pages/login_signup.dart';

class AppRouter {
  static const String home = '/';
  static const String trash = '/trash';
  static const String profile = '/profile';
  static const String login = '/login';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginSignupPage(),
      home: (context) => const Home(),
      profile: (context) => const ProfilePage(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginSignupPage());
      case home:
        return MaterialPageRoute(builder: (_) => const Home());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
