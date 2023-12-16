import '../utils/db_helper.dart';

class Deck {
  int? id;

  final String title;

  Deck({this.id, required this.title});

  Future<void> dbSave() async {
    id = await DBHelper().insert('decks', {
      'title': title,
    });
  }
}

class Flashcard {
  int? id;
  final int deckId;
  final String question;
  final String answer;

  Flashcard({
    this.id,
    required this.deckId,
    required this.question,
    required this.answer,
  });

  Future<void> dbSave() async {
    id = await DBHelper().insert('cards', {
      'deck_id': deckId,
      'question': question,
      'answer': answer,
    });
  }

  Future<void> dbDelete() async {
    if (id != null) {
      await DBHelper().delete('cards', id!);
    }
  }
}
