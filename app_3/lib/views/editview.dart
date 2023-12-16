import 'package:flutter/material.dart';
import '../utils/db_helper.dart';

class EditView extends StatefulWidget {
  final int deckId;
  final int cardId;
  final Function() onCardUpdate;

  EditView(
      {required this.cardId, required this.deckId, required this.onCardUpdate});

  @override
  _EditViewState createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  bool isTextNotEmpty = false;

  @override
  void initState() {
    super.initState();
    if (widget.cardId != -1) {
      _loadCardData();
    }
  }

  void _loadCardData() async {
    DBHelper dbHelper = DBHelper();
    Map<String, dynamic> cardData = await dbHelper.getCardById(widget.cardId);
    questionController.text = cardData['question'];
    answerController.text = cardData['answer'];
    _updateSaveButtonState();
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  void _updateSaveButtonState() {
    setState(() {
      isTextNotEmpty = questionController.text.isNotEmpty &&
          answerController.text.isNotEmpty;
    });
  }

  void _saveCard() async {
    DBHelper dbHelper = DBHelper();
    if (widget.cardId != -1) {
      Map<String, dynamic> updatedCardData = {
        'id': widget.cardId,
        'question': questionController.text,
        'answer': answerController.text,
        'deck_id': widget.deckId,
      };
      await dbHelper.updateCard(updatedCardData);
    } else {
      Map<String, dynamic> newCardData = {
        'question': questionController.text,
        'answer': answerController.text,
        'deck_id': widget.deckId,
      };
      await dbHelper.insertCard(newCardData);
    }
    widget.onCardUpdate();
    Navigator.of(context).pop();
  }

  void _deleteCard() async {
    if (widget.cardId != -1) {
      DBHelper dbHelper = DBHelper();
      await dbHelper.deleteCard(widget.cardId);
    }

    widget.onCardUpdate();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Card'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: TextField(
                  controller: questionController,
                  decoration: InputDecoration(
                    labelText: 'Question',
                  ),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  onChanged: (text) {
                    _updateSaveButtonState();
                  },
                ),
              ),
              SizedBox(height: 16),
              Flexible(
                child: TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                  ),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  onChanged: (text) {
                    _updateSaveButtonState();
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: isTextNotEmpty ? _saveCard : null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (widget.cardId == -1) ? null : _deleteCard,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
