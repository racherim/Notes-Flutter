import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_web/services/auth_services.dart';
import 'package:flutter_todo_web/utils/pagestyle.dart';
import 'package:flutter_todo_web/utils/routing.dart';
import 'package:flutter_todo_web/widgets/custom_AppBar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController controllerEmail = TextEditingController();

  final TextEditingController controllerCurrentPassword =
      TextEditingController();
  final TextEditingController controllerNewPassword = TextEditingController();
  final TextEditingController controllerConfirmNewPassword =
      TextEditingController();

  final TextEditingController controllerCurrentUsername =
      TextEditingController();
  final TextEditingController controllerNewUsername = TextEditingController();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerCurrentPassword.dispose();
    controllerConfirmNewPassword.dispose();
    controllerNewPassword.dispose();
    controllerCurrentUsername.dispose();
    controllerNewUsername.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final currentUser = authService.value.currentUser;
    if (currentUser != null && currentUser.email != null) {
      controllerEmail.text = currentUser.email!;
    }
    if (currentUser != null && currentUser.displayName != null) {
      controllerCurrentUsername.text = currentUser.displayName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    void updateUsername() async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      if (controllerNewUsername.text.isEmpty) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Username cannot be empty'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      try {
        await authService.value.updateUsername(
          username: controllerNewUsername.text,
        );
        setState(() {
          controllerCurrentUsername.text = controllerNewUsername.text;
        });
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Username updated successfully'),
            backgroundColor: Colors.greenAccent,
            duration: Duration(seconds: 2),
          ),
        );
      } on FirebaseAuthException catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occurred'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    void deleteAccount() async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        await authService.value.deleteAccount(
          email: controllerEmail.text,
          password: controllerCurrentPassword.text,
        );
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Account Has Been Deleted'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 5),
          ),
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(AppRouter.login);
          }
        });
      } on FirebaseAuthException catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occured'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    void updatePassword() async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      if (controllerConfirmNewPassword.text == controllerNewPassword.text) {
        try {
          await authService.value.updatePasswordFromCurrentPassword(
            currentPassword: controllerCurrentPassword.text,
            newPassword: controllerNewPassword.text,
            email: controllerEmail.text,
          );
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Change Password Successful'),
              backgroundColor: Colors.greenAccent,
              duration: Duration(seconds: 2),
            ),
          );
        } on FirebaseAuthException catch (e) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(e.message ?? 'An error occured'),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('New Password and Current Password Ain\'t Same 🥀'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    void logout() {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        authService.value.signOut();
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Logout Successful'),
            backgroundColor: Colors.greenAccent,
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed(AppRouter.login);
          }
        });
      } on FirebaseAuthException catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occurred'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(appBarType: AppBarType.profile, onToggleView: () {}),
      backgroundColor: PageStyle().backgroundColor,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxHeight: screenSize.height * 0.9),
          width: screenSize.width > 600 ? 400 : screenSize.width,
          decoration: BoxDecoration(
            color: PageStyle().mainColor,
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    controllerCurrentUsername.text,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(controllerEmail.text, style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 40),
                  // Username button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PageStyle().buttonColor,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Change Username'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Would you like to change your username?',
                              ),
                              const SizedBox(height: 15),
                              TextField(
                                controller: controllerNewUsername,
                                decoration: const InputDecoration(
                                  labelText: 'New Username',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                updateUsername();
                                Navigator.pop(context);
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Update Username',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PageStyle().buttonColor,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Change Password'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Would you like to change your password?',
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: controllerCurrentPassword,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Current Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: controllerNewPassword,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'New Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: controllerConfirmNewPassword,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Confirm New Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                updatePassword();
                                Navigator.pop(context);
                              },
                              child: const Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Delete Account button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PageStyle().buttonColor,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Account'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Are you sure you want to DELETE your Account?\nThis is permanent and NON-recoverable',
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: controllerCurrentPassword,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Current Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteAccount();
                                Navigator.pop(context);
                              },
                              child: const Text('Permanently Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Logout button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                logout();
                              },
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
