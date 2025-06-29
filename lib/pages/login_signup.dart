import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/pagestyle.dart';
import 'package:flutter_todo_web/widgets/login_widget.dart';
import 'package:flutter_todo_web/widgets/signup_widget.dart';
import 'dart:math' as math;

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage>
    with SingleTickerProviderStateMixin {
  bool showLogin = true;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleView() {
    if (showLogin) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PageStyle().backgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateY(_animation.value * math.pi),
              child: _animation.value <= 0.5
                  ? LoginPage(toggleView: toggleView)
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: SignupPage(toggleView: toggleView),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final Function toggleView;

  const LoginPage({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<RegisterNowEvent>(
      onNotification: (notification) {
        toggleView();
        return true;
      },
      child: const LoginWidget(),
    );
  }
}

class SignupPage extends StatelessWidget {
  final Function toggleView;

  const SignupPage({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<LoginNowEvent>(
      onNotification: (notification) {
        toggleView();
        return true;
      },
      child: const SignUpWidget(),
    );
  }
}

class RegisterNowEvent extends Notification {}

class LoginNowEvent extends Notification {}
