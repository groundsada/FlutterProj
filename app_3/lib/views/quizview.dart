import 'package:flutter/material.dart';

import '../utils/db_helper.dart';

class QuizView extends StatefulWidget {
  final String deckName;
  final int deckId;

  QuizView({required this.deckName, required this.deckId});

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int currentCardIndex = 0;
  bool isFlipped = false;
  int seenCards = 0;
  int peekedCards = 0;
  List<Map<String, String>> flashcards = [];

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  void _fetchCards() async {
    DBHelper dbHelper = DBHelper();
    List<Map<String, dynamic>> fetchedCards =
        await dbHelper.getCardsForDeckById(widget.deckId);

    List<int> shuffledIndices =
        List<int>.generate(fetchedCards.length, (index) => index)..shuffle();

    List<Map<String, String>> convertedCards = shuffledIndices
        .map((index) => {
              'question': fetchedCards[index]['question'] as String,
              'answer': fetchedCards[index]['answer'] as String,
            })
        .toList();

    setState(() {
      flashcards = convertedCards;
      seenCardIndices.add(0);
    });
  }

  Set<int> seenCardIndices = Set<int>();
  Set<int> peekedCardIndices = Set<int>();

  void onLeftArrowPressed() {
    setState(() {
      currentCardIndex =
          (currentCardIndex - 1 + flashcards.length) % flashcards.length;
      isFlipped = false;
      seenCardIndices.add(currentCardIndex);
    });
  }

  void onRightArrowPressed() {
    setState(() {
      currentCardIndex = (currentCardIndex + 1) % flashcards.length;
      isFlipped = false;
      seenCardIndices.add(currentCardIndex);
    });
  }

  void onFlipPressed() {
    setState(() {
      isFlipped = !isFlipped;
      if (isFlipped) {
        peekedCardIndices.add(currentCardIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double cardHeight = screenHeight * 0.4;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[900],
          title: Text(widget.deckName),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: onFlipPressed,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Card(
                      key: ValueKey<bool>(isFlipped),
                      color: isFlipped ? Colors.green[700] : Colors.yellow[700],
                      child: SizedBox(
                        height: cardHeight,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isFlipped
                                      ? flashcards[currentCardIndex]
                                              ['answer'] ??
                                          'Answer not available'
                                      : flashcards[currentCardIndex]
                                              ['question'] ??
                                          'Question not available',
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 32),
                        onPressed: onLeftArrowPressed,
                      ),
                      IconButton(
                        onPressed: onFlipPressed,
                        icon: Icon(
                          isFlipped ? Icons.visibility_off : Icons.visibility,
                          size: 32,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward, size: 32),
                        onPressed: onRightArrowPressed,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  'Seen ${seenCardIndices.length} cards out of ${flashcards.length}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 50),
                Text(
                  'Peeked at ${peekedCardIndices.length} questions out of ${seenCardIndices.length} seen',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ));
  }
}
