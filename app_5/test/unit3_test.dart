import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/models/categories_model.dart';

void main() {
  group('Categories Tests', () {
    test('Get Category List', () {
      final expectedCategoryList = [
        'Animals',
        'Art',
        'Celebrities',
        'Entertainment: Board Games',
        'Entertainment: Books',
        'Entertainment: Cartoon and Animations',
        'Entertainment: Comics',
        'Entertainment: Film',
        'Entertainment: Japanese Anime and Manga',
        'Entertainment: Music',
        'Entertainment: Musicals and Theatres',
        'Entertainment: Television',
        'Entertainment: Video Games',
        'General Knowledge',
        'Geography',
        'History',
        'Mythology',
        'Politics',
        'Science and Nature',
        'Science: Computers',
        'Science: Gadgets',
        'Science: Mathematics',
        'Sports',
        'Vehicles',
      ];

      final actualCategoryList = Categories.getCategoryList();

      expect(actualCategoryList, equals(expectedCategoryList));
    });

    test('Get Category Map', () {
      final expectedCategoryMap = {
        'Animals': 27,
        'Art': 25,
        'Celebrities': 26,
        'Entertainment: Board Games': 16,
        'Entertainment: Books': 10,
        'Entertainment: Cartoon and Animations': 32,
        'Entertainment: Comics': 29,
        'Entertainment: Film': 11,
        'Entertainment: Japanese Anime and Manga': 31,
        'Entertainment: Music': 12,
        'Entertainment: Musicals and Theatres': 13,
        'Entertainment: Television': 14,
        'Entertainment: Video Games': 15,
        'General Knowledge': 9,
        'Geography': 22,
        'History': 23,
        'Mythology': 20,
        'Politics': 24,
        'Science and Nature': 17,
        'Science: Computers': 18,
        'Science: Gadgets': 30,
        'Science: Mathematics': 19,
        'Sports': 21,
        'Vehicles': 28,
      };

      final actualCategoryMap = Categories.getCategoryMap();

      expect(actualCategoryMap, equals(expectedCategoryMap));
    });

    test('Get Category Index', () {
      final categoryToTest = 'Art';
      final expectedIndex = 25;

      final actualIndex = Categories.getCategoryIndex(categoryToTest);

      expect(actualIndex, equals(expectedIndex));
    });

    test('Get Category Index for Non-existent Category', () {
      final categoryToTest = 'NonExistentCategory';
      final expectedIndex = -1;

      final actualIndex = Categories.getCategoryIndex(categoryToTest);

      expect(actualIndex, equals(expectedIndex));
    });
  });
}
