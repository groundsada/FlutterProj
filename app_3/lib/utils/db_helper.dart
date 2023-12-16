import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _databaseName = 'flashcards.db';
  static const int _databaseVersion = 1;

  DBHelper._();

  static final DBHelper _singleton = DBHelper._();

  factory DBHelper() => _singleton;

  Database? _database;

  get db async {
    _database ??= await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    var dbDir = await getApplicationDocumentsDirectory();
    var dbPath = path.join(dbDir.path, _databaseName);
    var db = await openDatabase(dbPath, version: _databaseVersion,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE decks(
            id INTEGER PRIMARY KEY,
            title TEXT
          )
        ''');

      await db.execute('''
          CREATE TABLE cards(
            id INTEGER PRIMARY KEY,
            question TEXT,
            answer TEXT,
            deck_id INTEGER,
            FOREIGN KEY (deck_id) REFERENCES decks(id)
          )
        ''');
    });

    return db;
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where}) async {
    final db = await this.db;
    return where == null ? db.query(table) : db.query(table, where: where);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    int id = await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> update(String table, Map<String, dynamic> data) async {
    final db = await this.db;
    await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  Future<void> delete(String table, int id) async {
    final db = await this.db;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearDatabase() async {
    final db = await this.db;

    await db.delete('decks');
    await db.delete('cards');
  }

  Future<List<Map<String, dynamic>>> getCardsForDeckById(int deckId) async {
    final db = await this.db;

    final query = '''
      SELECT id, question, answer
      FROM cards
      WHERE deck_id = ?
    ''';

    return db.rawQuery(query, [deckId]);
  }

  Future<Map<String, dynamic>> getCardById(int cardId) async {
    final db = await this.db;
    final query = '''
      SELECT id, question, answer, deck_id
      FROM cards
      WHERE id = ?
    ''';
    var result = await db.rawQuery(query, [cardId]);
    return result.isNotEmpty ? result.first : {};
  }

  Future<String> getDeckTitleById(int deckId) async {
    final db = await this.db;

    final query = '''
    SELECT title
    FROM decks
    WHERE id = ?
  ''';

    var result = await db.rawQuery(query, [deckId]);

    if (result.isNotEmpty) {
      return result.first['title'];
    } else {
      return 'Deck Not Found';
    }
  }

  Future<void> updateCard(Map<String, dynamic> updatedCardData) async {
    final db = await this.db;
    await db.update(
      'cards',
      updatedCardData,
      where: 'id = ?',
      whereArgs: [updatedCardData['id']],
    );
  }

  Future<void> deleteCard(int cardId) async {
    final db = await this.db;
    await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [cardId],
    );
  }

  Future<int> insertCard(Map<String, dynamic> cardData) async {
    final db = await this.db;
    int id = await db.insert(
      'cards',
      cardData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<void> deleteCardsOfDeck(int deckId) async {
    final db = await this.db;
    await db.delete('cards', where: 'deck_id = ?', whereArgs: [deckId]);
  }
}
