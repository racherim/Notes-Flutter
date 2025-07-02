import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/PageStyle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_todo_web/utils/routing.dart';
import 'package:flutter_todo_web/services/auth_services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class AuthGuard extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _checkAuthentication(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _checkAuthentication(newRoute);
    }
  }

  void _checkAuthentication(Route<dynamic> route) {
    final routeName = route.settings.name;
    if (routeName == AppRouter.login) return;
    
    // Check if user is authenticated for protected routes
    if ((routeName == AppRouter.home || routeName == AppRouter.profile) &&
        authService.value.currentUser == null) {
      Navigator.of(route.navigator!.context)
          .pushReplacementNamed(AppRouter.login);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: PageStyle().secondaryColor,
        ),
      ),
      navigatorObservers: [AuthGuard()],
      initialRoute: authService.value.currentUser != null ? AppRouter.home : AppRouter.login,
      routes: AppRouter.getRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}