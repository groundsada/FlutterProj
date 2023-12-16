import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/models/settings_model.dart';

void main() {
  group('SettingsModel Tests', () {
    test('SettingsModel toMap', () {
      final settingsModel = SettingsModel(difficulty: Difficulty.medium);
      final expectedMap = {'difficulty': 'medium'};

      final actualMap = settingsModel.toMap();

      expect(actualMap, equals(expectedMap));
    });

    test('SettingsModel fromMap', () {
      final mapToTest = {'difficulty': 'easy'};
      final expectedSettingsModel = SettingsModel(difficulty: Difficulty.easy);

      final actualSettingsModel = SettingsModel.fromMap(mapToTest);

      expect(actualSettingsModel.difficulty,
          equals(expectedSettingsModel.difficulty));
    });
  });
}
