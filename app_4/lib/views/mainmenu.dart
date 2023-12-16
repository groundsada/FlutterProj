import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/SessionManager.dart';
import 'GameView.dart';
import 'NewGameView.dart';
import 'login.dart';

class MainMenu extends StatefulWidget {
  final String username;

  const MainMenu({required this.username});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class Game {
  final String id;
  final String player1;
  final String player2;
  final int position;
  final int status;
  final int turn;

  Game({
    required this.id,
    required this.player1,
    required this.player2,
    required this.position,
    required this.status,
    required this.turn,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'].toString(),
      player1: json['player1'].toString(),
      player2: json['player2'].toString(),
      position: json['position'] as int,
      status: json['status'] as int,
      turn: json['turn'] as int,
    );
  }

  String getTurnStatus(String myUsername) {
    if (turn == 0) {
      return 'Unknown Turn';
    } else if ((turn == 1 && myUsername == player1) ||
        (turn == 2 && myUsername == player2)) {
      return 'My Turn';
    } else {
      return 'Opponent\'s Turn';
    }
  }

  String getTitle(String myUsername) {
    switch (status) {
      case 0:
        return 'Waiting for opponent';
      case 1:
        return '$myUsername vs $player2 - Winner: $player1';
      case 2:
        return '$myUsername vs $player2 - Winner: $player2';
      case 3:
        return '$player1 vs $player2';
      default:
        return 'Unknown Status';
    }
  }
}

class _MainMenuState extends State<MainMenu> {
  bool showActiveGames = true;
  List<Game> activeGames = [];
  List<Game> completedGames = [];

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> selectAIDifficulty() async {
    String aiDifficulty = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select AI Difficulty'),
          content: Column(
            children: [
              Text('Choose the AI difficulty level:'),
              DropdownButton<String>(
                value: 'random',
                onChanged: (String? newValue) {
                  Navigator.of(context).pop(newValue);
                },
                items: <String>['random', 'perfect', 'oneship']
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
                Navigator.of(context).pop('random');
              },
              child: Text('Start Game'),
            ),
          ],
        );
      },
    );

    if (aiDifficulty != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewGameView(
              startWithAI: true,
              username: widget.username,
              aiDifficulty: aiDifficulty),
        ),
      );
    }
  }

  Future<void> fetchGames() async {
    final String baseUrl = '165.227.117.48';
    final String? token = await SessionManager.getToken();

    try {
      final response = await http.get(
        Uri.parse('http://$baseUrl/games'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> gamesData = jsonDecode(response.body)['games'];

        setState(() {
          activeGames = gamesData
              .map((game) => Game.fromJson(game))
              .where((game) => game.status == 0 || game.status == 3)
              .toList();

          completedGames = gamesData
              .map((game) => Game.fromJson(game))
              .where((game) => game.status == 1 || game.status == 2)
              .toList();
        });
      } else {
        print('Failed to fetch games: ${response.statusCode}');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Battleships')),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              fetchGames();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '\nBattleships',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Logged in as: ${widget.username}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('New Game'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewGameView(
                      startWithAI: false,
                      username: widget.username,
                      aiDifficulty: '',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.android),
              title: Text('New Game with AI'),
              onTap: () {
                selectAIDifficulty();
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text(showActiveGames
                  ? 'Show Completed Games'
                  : 'Show Active Games'),
              onTap: () {
                setState(() {
                  showActiveGames = !showActiveGames;
                  fetchGames();
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () async {
                await SessionManager.clearToken();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async {
            await fetchGames();
          },
          child: showActiveGames
              ? buildGamesList(activeGames)
              : buildGamesList(completedGames),
        ),
      ),
    );
  }

  bool isMyTurn(Game game, String myUsername) {
    return game.turn == 1 && myUsername == game.player1 ||
        game.turn == 2 && myUsername == game.player2;
  }

  bool isOpponentsTurn(Game game, String myUsername) {
    return game.turn == 1 && myUsername == game.player2 ||
        game.turn == 2 && myUsername == game.player1;
  }

  Widget buildGamesList(List<Game> games) {
    return games.isNotEmpty
        ? ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              final statusText = getStatusText(game.status, game.position);

              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  deleteGame(game.id);
                },
                background: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: Container(
                  color: isMyTurn(game, widget.username)
                      ? Colors.green[700]
                      : (isOpponentsTurn(game, widget.username)
                          ? Colors.yellow[700]
                          : null),
                  child: ListTile(
                    title: Text(
                        '🎮  Game #${game.id}: ${game.getTitle(widget.username)}'),
                    subtitle: Text(
                      '${statusText}${game.status == 3 ? ' - ${game.getTurnStatus(widget.username)}' : ''}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameView(
                            gameId: game.id,
                            username: widget.username,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          )
        : Text('No games available');
  }

  Future<void> deleteGame(String gameId) async {
    final String baseUrl = '165.227.117.48';
    final String? token = await SessionManager.getToken();

    try {
      final response = await http.delete(
        Uri.parse('http://$baseUrl/games/$gameId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String message = responseData['message'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );

        fetchGames();
      } else {}
    } catch (e) {}
  }

  String getStatusText(int status, int position) {
    if (status == 0) {
      return 'In Matchmaking';
    } else if (status == 1) {
      return position == 1 ? '🏆 I won' : '😢 I lost';
    } else if (status == 2) {
      return position == 2 ? '🏆 I won' : '😢 I lost';
    } else if (status == 3) {
      return 'Active';
    } else {
      return 'Unknown Status';
    }
  }
}
