import 'package:battleships/utils/SessionManager.dart';
import 'package:battleships/views/login.dart';
import 'package:battleships/views/mainmenu.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SessionManager.initialize();

  bool _isLoggedIn = await SessionManager.isLoggedIn();
  String? _username = await SessionManager.getUsername();

  runApp(MyApp(isLoggedIn: _isLoggedIn, username: _username));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? username;

  const MyApp({required this.isLoggedIn, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: isLoggedIn ? MainMenu(username: username ?? '') : LoginScreen(),
    );
  }
}
