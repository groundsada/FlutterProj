import 'package:flutter/material.dart';

import '../utils/db_helper.dart';
import '../utils/json_helper.dart';
import 'cardsview.dart';
import 'editdeckview.dart';

class DeckList extends StatefulWidget {
  const DeckList({Key? key});

  @override
  _DeckListState createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  Future<List<Map<String, dynamic>>> fetchDecks() async {
    final dbHelper = DBHelper();
    return dbHelper.query('decks');
  }

  List<Map<String, dynamic>> _decks = [];

  int calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 500) {
      return 2;
    } else if (screenWidth <= 750) {
      return 3;
    } else if (screenWidth <= 900) {
      return 4;
    } else if (screenWidth <= 1200) {
      return 5;
    } else if (screenWidth <= 1500) {
      return 6;
    } else {
      return 7;
    }
  }

  void updateDecks() {
    _fetchDecks();
  }

  Future<void> _fetchDecks() async {
    final dbHelper = DBHelper();
    final decks = await dbHelper.query('decks');
    setState(() {
      _decks = decks;
    });
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = calculateCrossAxisCount(context);

    void navigateToDeckEditView(int deckid, String deckName) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditDeckView(
            deckId: deckid,
            deckName: deckName,
            onDeckUpdated: updateDecks,
          ),
        ),
      );
    }

    Future<void> clearDatabase() async {
      final dbHelper = DBHelper();
      await dbHelper.db;
      dbHelper.clearDatabase();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchDecks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Flashcard Decks (Loading...)');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No decks available');
            } else {
              final deckCount = snapshot.data!.length;
              return Text('Flashcard Decks ($deckCount)',
                  style: TextStyle(fontSize: 20));
            }
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.restore_outlined, size: 30),
            onPressed: () async {
              clearDatabase();
              await JSONHelper().importDataToDatabase();
              _fetchDecks();
            },
          ),
          IconButton(
            icon: Icon(Icons.download, size: 30),
            onPressed: () async {
              await JSONHelper().importDataToDatabase();
              _fetchDecks();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchDecks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No decks available.',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
          } else {
            final _decks = snapshot.data;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: calculateCrossAxisCount(context),
              ),
              itemCount: _decks?.length,
              itemBuilder: (context, index) {
                final deck = _decks?[index];
                final deckName = deck?['title'];
                final deckId = deck?['id'];
                return Card(
                  color: Colors.blue[700],
                  child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CardsView(deckId: deckId),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.yellow,
                              ),
                              onPressed: () {
                                navigateToDeckEditView(deckId, deckName);
                              },
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            deckName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDeckEditView(-1, '');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 36,
        ),
        backgroundColor: Colors.yellow[700],
      ),
    );
  }
}
