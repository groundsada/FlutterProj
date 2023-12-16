import 'package:flutter/foundation.dart';
import 'package:mp5/models/categories_model.dart';

class TriviaModel extends ChangeNotifier {
  List<TriviaQuestion> _questions = [];
  int _currentQuestionIndex = 0;

  List<TriviaQuestion> get questions => _questions;

  int get currentQuestionIndex => _currentQuestionIndex;

  int _correctAnswersCount = 0;

  int get correctAnswersCount => _correctAnswersCount;
  String? name;

  int? id;

  TriviaModel({
    required this.id,
    required this.name,
    required correctAnswersCount,
    required List<TriviaQuestion> questions,
    required int currentQuestionIndex,
  });

  TriviaQuestion get currentQuestion {
    printAllQuestionsAndAnswers;
    if (_currentQuestionIndex < _questions.length) {
      return _questions[_currentQuestionIndex];
    } else {
      return TriviaQuestion(
        questionText: 'End of Trivia.\nCongratulations! You are braintastic!',
        choices: [],
        correctAnswerIndex: -1,
      );
    }
  }

  get http => null;

  void advanceToNextQuestion() {
    _correctAnswersCount++;
    _currentQuestionIndex++;
    notifyListeners();
  }

  void updateQuestions(List<TriviaQuestion> newQuestions) {
    _questions = newQuestions;
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  void selectAnswer(int selectedAnswerIndex) {
    if (selectedAnswerIndex == currentQuestion.correctAnswerIndex) {
      _correctAnswersCount++;
    }

    _currentQuestionIndex++;
    notifyListeners();
  }

  void reset() {
    _correctAnswersCount = 0;
    _questions.clear();
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  void printAllQuestionsAndAnswers() {
    for (int i = 0; i < _questions.length; i++) {
      TriviaQuestion question = _questions[i];
      print('Question ${i + 1}: ${question.questionText}');
      for (int j = 0; j < question.choices.length; j++) {
        print('  Choice ${j + 1}: ${question.choices[j]}');
      }
      print('Correct Answer Index: ${question.correctAnswerIndex}\n');
    }
  }

  String _getCategoryCode(String selectedCategory) {
    return Categories.getCategoryIndex(selectedCategory).toString();
  }
}

class TriviaQuestion {
  final String questionText;
  final List<String> choices;
  final int correctAnswerIndex;

  TriviaQuestion({
    required this.questionText,
    required this.choices,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'choices': choices,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
