import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:mp5/models/categories_model.dart';
import '../models/settings_model.dart';
import '../models/trivia_model.dart';
import '../utils/db_helper.dart';
import 'home.dart';

class TriviaPage extends StatefulWidget {
  final bool timedMode;
  final String selectedCategory;

  TriviaPage({required this.timedMode, required this.selectedCategory});

  @override
  _TriviaPageState createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  late TriviaModel _triviaModel;
  bool _gameOverAlertShown = false;
  bool _isLoading = true;
  int? _selectedAnswerIndex;
  late Timer _timer;
  Duration _countdownDuration = Duration(minutes: 1);
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _triviaModel = TriviaModel(
      id: null,
      correctAnswersCount: null,
      questions: [],
      currentQuestionIndex: 0,
      name: widget.selectedCategory,
    );
    _fetchTriviaQuestions();
    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    if (widget.timedMode) {
      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        setState(() {
          if (_countdownDuration.inSeconds > 0) {
            _countdownDuration -= Duration(seconds: 1);
          } else {
            _timer.cancel();
            _showGameOverAlert();
          }
        });
      });
    }
  }

  void _fetchTriviaQuestions() async {
    _isLoading = true;
    const maxAttempts = 10;
    const retryDelay = Duration(seconds: 2);
    int attempts = 0;

    final settings = await DBHelper.getSettings();
    Difficulty difficulty = settings?.difficulty ?? Difficulty.medium;

    Map<String, String> queryParams = {
      'amount': '30',
      'type': 'multiple',
      'difficulty': _difficultyToString(difficulty),
    };
    if (widget.selectedCategory != 'none') {
      queryParams['category'] = _getCategoryCode(widget.selectedCategory);
      _triviaModel.name = widget.selectedCategory;
    }

    Future.delayed(Duration(seconds: 10), () {
      if (_isLoading) {
        _showTimeoutError();
      }
    });

    while (attempts < maxAttempts) {
      try {
        final uri = Uri.https('opentdb.com', '/api.php', queryParams);
        print('Reached hello....');
        print(uri.toString());

        final response = await http.get(uri);
        print('RESPONSE....');
        print(response.body);

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          if (responseData['response_code'] == 0) {
            final List<dynamic> results = responseData['results'];
            final List<TriviaQuestion> triviaQuestions = results.map((result) {
              List<String> choices =
                  List<String>.from(result['incorrect_answers']);
              choices.add(result['correct_answer']);

              choices.shuffle();

              return TriviaQuestion(
                questionText: _decodeHtmlEntities(result['question']),
                choices: choices.map(_decodeHtmlEntities).toList(),
                correctAnswerIndex: choices.indexOf(result['correct_answer']),
              );
            }).toList();

            print('\t\tHello\t\t\n\n');
            print(triviaQuestions);

            _triviaModel.updateQuestions(triviaQuestions);
            _triviaModel.printAllQuestionsAndAnswers();
            _refreshUI();
            break;
          } else {
            attempts++;
            print('Retrying... Attempt $attempts');
            await Future.delayed(retryDelay);
          }
        } else {
          attempts++;
          print('Retrying... Attempt $attempts');
          await Future.delayed(retryDelay);
        }
      } catch (error) {
        attempts++;
        print('Retrying... Attempt $attempts');
        await Future.delayed(retryDelay);
      }
    }
  }

  String _decodeHtmlEntities(String input) {
    final unescape = HtmlUnescape();
    return unescape.convert(input);
  }

  String _getCategoryCode(String selectedCategory) {
    return Categories.getCategoryIndex(selectedCategory).toString();
  }

  void _refreshUI() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia Page'),
      ),
      body: _isLoading ? _buildLoadingSpinner() : _buildTriviaUI(),
    );
  }

  Widget _buildLoadingSpinner() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget _buildTriviaUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selected Category: ${widget.selectedCategory}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            'Timed Mode: ${widget.timedMode}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question: ${_triviaModel.currentQuestion.questionText}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                for (int index = 0;
                    index < _triviaModel.currentQuestion.choices.length;
                    index++)
                  GestureDetector(
                    onTap: () {
                      _checkAnswer(index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: _getColorForAnswer(index),
                      ),
                      child: ListTile(
                        title: Text(
                          'Choice ${index + 1}: ${_triviaModel.currentQuestion.choices[index]}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.timedMode) SizedBox(height: 20),
          if (widget.timedMode)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Time Remaining: ${_countdownDuration.inMinutes}:${(_countdownDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }

  Color _getColorForAnswer(int answerIndex) {
    if (_selectedAnswerIndex != null) {
      if (_triviaModel.currentQuestion.correctAnswerIndex == answerIndex) {
        return _selectedAnswerIndex == answerIndex
            ? Colors.green
            : Colors.green.withOpacity(0.5);
      } else {
        return _selectedAnswerIndex == answerIndex
            ? Colors.red
            : Colors.red.withOpacity(0.5);
      }
    } else {
      return Colors.transparent;
    }
  }

  void _showTimeoutError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Timeout Error'),
          content:
              Text('It seems that the API is down. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkAnswer(int selectedAnswerIndex) async {
    if (_triviaModel.currentQuestionIndex < _triviaModel.questions.length) {
      setState(() {
        _selectedAnswerIndex = selectedAnswerIndex;
      });

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _selectedAnswerIndex = selectedAnswerIndex;
        });
      });

      if (!widget.timedMode &&
          selectedAnswerIndex !=
              _triviaModel.currentQuestion.correctAnswerIndex) {
        _showGameOverAlert();
      }

      if (selectedAnswerIndex ==
          _triviaModel.currentQuestion.correctAnswerIndex) {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _triviaModel.advanceToNextQuestion();
            _selectedAnswerIndex = null;
            _refreshUI();
          });
        });
      }
      print(
          '\n\nThe number of games:  ${_triviaModel.correctAnswersCount}\n\n');
    } else {}
  }

  void _showGameOverAlert() {
    if (!_gameOverAlertShown) {
      _gameOverAlertShown = true;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          print(
              '\n\nThe number of games:  ${_triviaModel.correctAnswersCount}\n\n');
          return AlertDialog(
            title: Text('Game Over'),
            content: widget.timedMode
                ? Text(
                    'You got ${_triviaModel.correctAnswersCount} questions right in a row!')
                : Text(
                    'You got ${_triviaModel.correctAnswersCount} questions right in a row!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _handleAnswer(int selectedAnswerIndex) {
    if (_triviaModel.currentQuestionIndex < _triviaModel.questions.length) {
      bool isCorrect = selectedAnswerIndex ==
          _triviaModel.currentQuestion.correctAnswerIndex;

      _triviaModel.selectAnswer(selectedAnswerIndex);

      _showAnswerFeedback(isCorrect);
    } else {
      _showEndOfTrivia();
    }
  }

  void _showAnswerFeedback(bool isCorrect) {
    String feedback = isCorrect ? 'Correct!' : 'Incorrect!';

    setState(() {
      _selectedAnswerIndex = null;
    });
  }

  void _showEndOfTrivia() {
    print('End of trivia. You can implement further actions here.');
  }

  String _difficultyToString(Difficulty difficulty) {
    return difficulty.toString().split('.').last;
  }
}
