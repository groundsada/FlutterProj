import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/SessionManager.dart';
import '../utils/AuthService.dart';
import 'mainmenu.dart';

class NewGameView extends StatefulWidget {
  final bool startWithAI;
  final String username;
  final String aiDifficulty;

  NewGameView(
      {required this.startWithAI,
      required this.username,
      required this.aiDifficulty});

  @override
  _NewGameViewState createState() => _NewGameViewState();
}

class _NewGameViewState extends State<NewGameView> {
  late List<String> ships;
  late String aiOption;
  bool gameStarted = false;
  List<List<String>> grid = List.generate(5, (index) => List.filled(5, ''));
  String shipIcon = '🚢';
  List<String> alphabet = ['A', 'B', 'C', 'D', 'E'];
  String aiDifficulty = "random";

  @override
  void initState() {
    super.initState();
    ships = ["", "", "", "", ""];
    aiOption = "oneship";
  }

  Future<void> startGame() async {
    await initiateGameStart();
  }

  Future<void> selectAIDifficulty() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select AI Difficulty'),
          content: Column(
            children: [
              Text('Choose the AI difficulty level:'),
              DropdownButton<String>(
                value: aiDifficulty,
                onChanged: (String? newValue) {
                  setState(() {
                    aiDifficulty = newValue!;
                  });
                },
                items: <String>['random', 'perfect', 'one ship']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                initiateGameStart();
              },
              child: Text('Start Game'),
            ),
          ],
        );
      },
    );
  }

  Future<void> initiateGameStart() async {
    final Map<String, dynamic> requestBody = {
      "ships": ships,
      "ai": widget.startWithAI ? widget.aiDifficulty : null,
    };

    try {
      final String? accessToken = await SessionManager.getToken();

      if (accessToken == null) {
        return;
      }

      final String baseUrl = AuthService.baseUrl;

      final response = await http.post(
        Uri.parse('$baseUrl/games'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        String gameId = responseData['id'].toString();
        int player = responseData['player'] as int;
        bool matched = responseData['matched'] as bool;

        Navigator.of(context).pop();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainMenu(username: widget.username),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Failed to Start Game'),
              content: Text('Please make sure you selected 5 unique ships.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error starting the game: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Game'),
      ),
      body: gameStarted ? buildGamePlayView() : buildShipPlacementView(),
    );
  }

  Widget buildShipPlacementView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Place your ships on the board'),
        buildGrid(),
        ElevatedButton(
          onPressed: startGame,
          child: Text('Start Game'),
        ),
      ],
    );
  }

  Widget buildGamePlayView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Game in progress'),
        buildGameBoard(),
      ],
    );
  }

  Widget buildGrid() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
          ),
          itemBuilder: (context, index) {
            int row = index ~/ 6;
            int col = index % 6;

            if (row == 0 && col == 0) {
              return Container();
            } else if (row == 0 && col > 0) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    '${col}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            } else if (col == 0 && row > 0) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    '${alphabet[row - 1]}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            } else if (row > 0 && col > 0) {
              return GestureDetector(
                onTap: () {
                  placeShip(row - 1, col - 1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: grid[row - 1][col - 1] != ''
                        ? Colors.blue
                        : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      grid[row - 1][col - 1] != '' ? '🚢' : '',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
          itemCount: 36,
        ),
      ),
    );
  }

  Widget buildGameBoard() {
    return Container();
  }

  void placeShip(int row, int col) {
    setState(() {
      if (grid[row][col] == '') {
        int emptyPosition = ships.indexOf('');

        if (emptyPosition != -1) {
          ships[emptyPosition] = '${alphabet[row]}${col + 1}';

          grid[row][col] = shipIcon;
        } else {}
      } else {
        int position = ships.indexOf('${alphabet[row]}${col + 1}');

        grid[row][col] = '';

        ships[position] = '';
      }
    });
  }
}
