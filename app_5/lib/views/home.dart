import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mp5/views/settings.dart';
import 'package:mp5/views/trivia.dart';

import 'categorylist.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _timedMode = false;
  String _selectedCategory = 'Any Category';
  Color _backgroundColor = Colors.blue;

  @override
  void initState() {
    super.initState();

    _startBackgroundColorAnimation();
  }

  void _startBackgroundColorAnimation() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _backgroundColor = _getRandomColor();
      });
    });
  }

  Color _getRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      50 + random.nextInt(206),
      50 + random.nextInt(206),
      50 + random.nextInt(206),
      1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Braintastic: The Trivia Game',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.yellow[700],
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        color: _backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 200.0,
                height: 200.0,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _startQuickGame();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  minimumSize: Size(250, 70),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                child: Text(
                  'Quick Game',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _startCategoryGame();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  minimumSize: Size(250, 70),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                child: Text(
                  'Category Game',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _goToSettings();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow[700],
                  minimumSize: Size(250, 70),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: _timedMode ? Colors.yellow[700] : Colors.blue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(_timedMode ? Icons.access_time : Icons.loop_rounded),
            Text(
              _timedMode ? 'Timed Mode' : 'Endless Mode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Switch(
              value: _timedMode,
              onChanged: (value) {
                setState(() {
                  _timedMode = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _startQuickGame() {
    _navigateToTriviaPage(timedMode: _timedMode, category: 'none');
  }

  void _startCategoryGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CategoryList(timedMode: _timedMode)),
    );
  }

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
  }

  void _navigateToTriviaPage(
      {required bool timedMode, required String category}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TriviaPage(
          timedMode: timedMode,
          selectedCategory: category,
        ),
      ),
    );
  }
}
