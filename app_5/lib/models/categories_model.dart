class Categories {
  static List<String> getCategoryList() {
    return getCategoryMap().keys.toList();
  }

  static Map<String, int> getCategoryMap() {
    return {
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
  }

  static int getCategoryIndex(String category) {
    final Map<String, int> categoryMap = getCategoryMap();
    return categoryMap[category] ?? -1;
  }
}
