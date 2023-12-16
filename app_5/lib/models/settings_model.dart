enum Difficulty {
  easy,
  medium,
  hard,
}

class SettingsModel {
  final Difficulty difficulty;

  SettingsModel({
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'difficulty': difficulty.toString().split('.').last,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      difficulty: Difficulty.values.firstWhere(
        (e) => e.toString() == 'Difficulty.${map['difficulty']}',
      ),
    );
  }
}
