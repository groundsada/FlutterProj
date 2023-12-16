import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/SessionManager.dart';
import 'mainmenu.dart';

class GameView extends StatefulWidget {
  final String gameId;
  final String username;

  GameView({required this.gameId, required this.username});

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late List<List<String>> gameGrid;
  bool isLoading = true;
  late Map<String, dynamic> gameDetails;
  late int position;
  String? pendingShot;
  bool gameOverAlertDialogShown = false;

  @override
  void initState() {
    super.initState();
    fetchGameDetails();
  }

  void setPendingShot(String shot) {
    Future.delayed(Duration.zero, () {
      pendingShot = shot;
    });
  }

  void clearPendingShot() {
    setState(() {
      pendingShot = null;
    });
  }

  Future<void> fetchGameDetails() async {
    try {
      final String baseUrl = "http://165.227.117.48/";
      final String endpoint = "games/${widget.gameId}";
      final String? accessToken = await SessionManager.getToken();

      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        gameDetails = jsonDecode(response.body);
        position = gameDetails['position'];

        List<String> shots = gameDetails['shots'].cast<String>();
        List<String> sunk = gameDetails['sunk'].cast<String>();
        gameDetails['shots'] = [...shots, ...sunk];

        setState(() {
          isLoading = false;
        });
      } else {}
    } catch (e) {}
  }

  Future<void> playShot(String shot) async {
    try {
      if (gameDetails['shots'].contains(shot) ||
          gameDetails['sunk'].contains(shot)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Shot already played at $shot'),
          ),
        );
        return;
      }

      setPendingShot(shot);

      final String baseUrl = "http://165.227.117.48/";
      final String endpoint = "games/${widget.gameId}";
      final String? accessToken = await SessionManager.getToken();

      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'shot': shot}),
      );

      if (response.statusCode == 200) {
        await fetchGameDetails();

        checkGameStatus();

        clearPendingShot();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to play shot: ${response.statusCode}'),
          ),
        );

        clearPendingShot();
      }
    } catch (e) {}
  }

  void checkGameStatus() {
    if (!gameOverAlertDialogShown) {
      if (gameDetails['status'] == 1 && position == 1) {
        showAlertDialogAndNavigate('You won the game!');
      } else if (gameDetails['status'] == 2 && position == 2) {
        showAlertDialogAndNavigate('You won the game!');
      } else if (gameDetails['status'] == 1 || gameDetails['status'] == 2) {
        String winner = gameDetails['status'] == 1
            ? gameDetails['player1']
            : gameDetails['player2'];
        showAlertDialogAndNavigate('$winner won the game!');
      } else if (gameDetails['status'] == 0) {
        showAlertDialogAndNavigate('The game has ended.');
      }
    }
  }

  void showAlertDialogAndNavigate(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                gameOverAlertDialogShown = true;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainMenu(username: widget.username),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showGameResultDialog(String title, String message) {
    String emoji = '';
    if (gameDetails['status'] == 1) {
      emoji = '🎉';
    } else if (gameDetails['status'] == 2) {
      emoji = '😢';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            children: [
              Text(
                '$emoji $message',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainMenu(username: widget.username),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Details'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildGameGrid(),
    );
  }

  Widget buildGameGrid() {
    return Center(
      child: Column(
        children: [
          Container(
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
                        '${String.fromCharCode('A'.codeUnitAt(0) + row - 1)}',
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
                      if (gameDetails['turn'] == position &&
                          gameDetails['status'] == 3) {
                        String shot =
                            '${String.fromCharCode('A'.codeUnitAt(0) + row - 1)}${col}';

                        setPendingShot(shot);

                        Future.delayed(Duration.zero, () {
                          setState(() {});
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: pendingShot ==
                                '${String.fromCharCode('A'.codeUnitAt(0) + row - 1)}${col}'
                            ? Colors.red[300]
                            : Colors.white,
                      ),
                      child: Center(
                        child: getGridCellContent(row - 1, col - 1),
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
          ElevatedButton(
            onPressed: () {
              if (pendingShot != null &&
                  gameDetails['turn'] == position &&
                  gameDetails['status'] == 3) {
                playShot(pendingShot!);
              }
              fetchGameDetails();
              checkGameStatus();
            },
            child: Text('Submit Shot'),
            style: ElevatedButton.styleFrom(
              primary:
                  gameDetails['turn'] != position || gameDetails['status'] != 3
                      ? Colors.grey
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget getGridCellContent(int row, int col) {
    String coordinate =
        '${String.fromCharCode('A'.codeUnitAt(0) + row)}${col + 1}';

    if (gameDetails['wrecks'].contains(coordinate)) {
      return Row(
        children: [
          Text(
            '🫧',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (gameDetails['shots'].contains(coordinate))
            Text('💣',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          if (gameDetails['sunk'].contains(coordinate))
            Text('✨',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
        ],
      );
    } else if (gameDetails['ships'].contains(coordinate)) {
      return Row(
        children: [
          Text(
            '🚢',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (gameDetails['shots'].contains(coordinate))
            Text('💣',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          if (gameDetails['sunk'].contains(coordinate))
            Text('✨',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
        ],
      );
    } else if (gameDetails['shots'].contains(coordinate) ||
        gameDetails['sunk'].contains(coordinate)) {
      if (pendingShot != null && coordinate == pendingShot) {
        return Text('🔴',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.red));
      } else if (gameDetails['sunk'].contains(coordinate)) {
        return Text('✨',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black));
      } else {
        return Text('💣',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black));
      }
    } else {
      return Text('');
    }
  }
}
