import 'package:flutter/material.dart';
import 'package:mp3/views/quizview.dart';
import '../utils/db_helper.dart';
import 'editview.dart';

class CardsView extends StatefulWidget {
  final int deckId;

  CardsView({required this.deckId});

  @override
  _CardsViewState createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
  bool isSortingByDate = true;
  List<Map<String, dynamic>> cards = [];
  String deckName = "";

  int calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 500) {
      return 3;
    } else if (screenWidth <= 750) {
      return 4;
    } else if (screenWidth <= 900) {
      return 5;
    } else if (screenWidth <= 1200) {
      return 6;
    } else if (screenWidth <= 1500) {
      return 7;
    } else {
      return 8;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCards();
    _fetchTitle();
  }

  void _fetchTitle() async {
    DBHelper dbHelper = DBHelper();
    String title = await dbHelper.getDeckTitleById(widget.deckId);

    setState(() {
      deckName = title;
    });
  }

  void _fetchCards() async {
    DBHelper dbHelper = DBHelper();
    List<Map<String, dynamic>> fetchedCards =
        await dbHelper.getCardsForDeckById(widget.deckId);

    List<Map<String, dynamic>> sortedCards =
        List<Map<String, dynamic>>.from(fetchedCards);

    if (isSortingByDate) {
    } else {
      sortedCards.sort((a, b) =>
          a['question'].toLowerCase().compareTo(b['question'].toLowerCase()));
    }

    setState(() {
      this.cards = sortedCards;
    });
  }

  void handleCardUpdate() {
    _fetchCards();
  }

  void navigateToEditView(int cardId, int deckId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditView(
            cardId: cardId, deckId: deckId, onCardUpdate: handleCardUpdate),
      ),
    );
  }

  void navigateToQuizView() {
    if (cards.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              QuizView(deckName: deckName, deckId: widget.deckId),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Cards Available'),
            content: Text('There are no cards in the deck to quiz on.'),
            actions: <Widget>[
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

  void toggleSort() {
    setState(() {
      isSortingByDate = !isSortingByDate;
      _fetchCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = calculateCrossAxisCount(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
        title: Text(
          '${deckName}',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: isSortingByDate
                ? Icon(Icons.sort_by_alpha)
                : Icon(Icons.access_time),
            onPressed: () {
              toggleSort();
            },
          ),
          IconButton(
            icon: Icon(Icons.play_arrow, size: 30),
            onPressed: () {
              navigateToQuizView();
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: crossAxisCount,
        padding: const EdgeInsets.all(4),
        children: List.generate(cards.length, (index) {
          final card = cards[index];
          return Card(
            color: Colors.purple[700],
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      navigateToEditView(card['id'], widget.deckId);
                    },
                  ),
                  Center(
                    child: Text(
                      card['question'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToEditView(-1, widget.deckId);
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.purple[900],
      ),
    );
  }
}
