import 'package:flutter/material.dart';
import 'package:flutter_todo_web/utils/pagestyle.dart';
import 'package:flutter_todo_web/widgets/custom_AppBar.dart';
import 'package:flutter_todo_web/widgets/login_widget.dart';
import 'package:flutter_todo_web/widgets/resetpassword_widget.dart';
import 'package:flutter_todo_web/widgets/signup_widget.dart';
import 'dart:math' as math;

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage>
    with SingleTickerProviderStateMixin {
  // 0: login, 1: signup, 2: reset password
  int currentView = 0;
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

  void switchView(int newView) {
    if (currentView == newView) return;

    // Always animate when switching between views
    if (_animation.value > 0.5) {
      // If we're currently showing back side, first reset to front
      _controller.reverse().then((_) {
        setState(() {
          currentView = newView;
          if (newView != 0) {
            // If not going to login view, animate forward
            _controller.forward();
          }
        });
      });
    } else {
      setState(() {
        currentView = newView;
        if (newView != 0) {
          // If not going to login view, animate forward
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarType: AppBarType.login, onToggleView: () {}),
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
                  ? _getFrontWidget()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: _getBackWidget(),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _getFrontWidget() {
    // Always show login on front side
    return NotificationListener<RecoverpasswordEvent>(
      onNotification: (notification) {
        switchView(2); // Switch to reset password
        return true;
      },
      child: LoginPage(
        toggleView: () => switchView(1), // Switch to signup
      ),
    );
  }

  Widget _getBackWidget() {
    // Show either signup or reset password on back
    if (currentView == 1) {
      return SignupPage(
        toggleView: () => switchView(0), // Switch to login
      );
    } else {
      return ResetPasswordPage(
        toggleView: () => switchView(0), // Switch to login
      );
    }
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

class ResetPasswordPage extends StatelessWidget {
  final Function toggleView;

  const ResetPasswordPage({super.key, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<LoginNowEvent>(
      onNotification: (notification) {
        toggleView();
        return true;
      },
      child: const ResetpasswordWidget(),
    );
  }
}

class RecoverpasswordEvent extends Notification {}

class RegisterNowEvent extends Notification {}

class LoginNowEvent extends Notification {}
