import 'package:flutter/material.dart';

import '../utils/AuthService.dart';
import '../utils/SessionManager.dart';
import 'package:flutter/material.dart';

import 'mainmenu.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    bool _loading = false;
    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        String action = 'Login';

        if (_registering) {
          action = 'Registration';
        }

        final response = _registering
            ? await AuthService.register(username, password)
            : await AuthService.login(username, password);

        if (response.containsKey('access_token')) {
          final String token = response['access_token'];
          final DateTime expiry = DateTime.now().add(Duration(hours: 1));

          await SessionManager.saveToken(token, expiry, username);

          _navigateToMainMenu(username);
        } else {
          _showErrorAlert('$action failed: ${response['message']}');
        }
      } catch (e) {
        _showErrorAlert('Error during login/registration. Please try again.');
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _navigateToMainMenu(String username) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainMenu(username: username),
      ),
    );
  }

  void _showErrorAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login/Registration Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _registering = false;

  void _showRegistrationStatus(bool success) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registration Status'),
        content:
            Text(success ? 'Registration succeeded!' : 'Registration failed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_registering ? 'Register' : 'Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text(_registering ? 'Register' : 'Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() {
                  _registering = !_registering;
                });
              },
              child:
                  Text(_registering ? 'Switch to Login' : 'Switch to Register'),
            ),
          ],
        ),
      ),
    );
  }
}
