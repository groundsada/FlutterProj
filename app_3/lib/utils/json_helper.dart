import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/deck.dart';
import 'db_helper.dart';

class JSONHelper {
  static const String jsonFilePath = 'assets/flashcards.json';

  JSONHelper._();

  static final JSONHelper _singleton = JSONHelper._();

  factory JSONHelper() => _singleton;

  Future<void> importDataToDatabase() async {
    final String jsonData = await rootBundle.loadString(jsonFilePath);
    final List<dynamic> data = json.decode(jsonData);

    final dbHelper = DBHelper();

    for (var item in data) {
      final String deckTitle = item['title'];
      final List<dynamic> flashcardsData = item['flashcards'];

      final Deck deck = Deck(title: deckTitle);
      await deck.dbSave();

      for (var flashcardData in flashcardsData) {
        final Flashcard flashcard = Flashcard(
          id: 1,
          question: flashcardData['question'],
          answer: flashcardData['answer'],
          deckId: deck.id ?? 1,
        );
        flashcard.id = deck.id;
        await flashcard.dbSave();
      }
    }
  }
}
