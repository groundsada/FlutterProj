import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:mp5/models/settings_model.dart';

class DBHelper {
  static Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'diff.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            difficulty INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertSettings(SettingsModel settings) async {
    final Database db = await initDatabase();

    final existingSettings = await db.query('settings');
    if (existingSettings.isNotEmpty) {
      await db.update(
        'settings',
        {'difficulty': settings.difficulty.index},
        where: 'id = ?',
        whereArgs: [existingSettings.first['id']],
      );
    } else {
      await db.insert('settings', {'difficulty': settings.difficulty.index});
    }
  }

  static Future<SettingsModel?> getSettings() async {
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('settings');

    if (maps.isNotEmpty) {
      return SettingsModel(
          difficulty: Difficulty.values[maps.first['difficulty']]);
    } else {
      return null;
    }
  }
}
