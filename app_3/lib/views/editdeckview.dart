import 'package:flutter/material.dart';
import '../utils/db_helper.dart';

class EditDeckView extends StatefulWidget {
  final int deckId;
  final Function() onDeckUpdated;

  EditDeckView(
      {required this.deckId,
      required this.onDeckUpdated,
      required String deckName});

  @override
  _EditDeckViewState createState() => _EditDeckViewState();
}

class _EditDeckViewState extends State<EditDeckView> {
  TextEditingController nameController = TextEditingController();
  String appBarTitle = '';
  bool isSaveButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    if (widget.deckId == -1) {
      appBarTitle = 'New Deck';
    } else {
      fetchDeckTitle();
    }

    if (widget.deckId != -1) {
      _loadDeckData();
    }
  }

  Future<void> fetchDeckTitle() async {
    String title = await DBHelper().getDeckTitleById(widget.deckId);
    setState(() {
      appBarTitle = title;
    });
  }

  void _loadDeckData() async {
    DBHelper dbHelper = DBHelper();

    String deckName = await dbHelper.getDeckTitleById(widget.deckId);

    nameController.text = deckName;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _updateSaveButtonState() {
    setState(() {
      isSaveButtonEnabled = nameController.text.isNotEmpty;
    });
  }

  void _saveDeck() async {
    DBHelper dbHelper = DBHelper();
    String deckName = nameController.text;

    if (widget.deckId == -1) {
      int newDeckId = await dbHelper.insert('decks', {'title': deckName});
      print('New deck created with ID: $newDeckId');
    } else {
      await dbHelper.update('decks', {'id': widget.deckId, 'title': deckName});
      print('Deck updated with ID: ${widget.deckId}');
    }

    Navigator.of(context).pop();
  }

  void _deleteDeck() async {
    DBHelper dbHelper = DBHelper();

    if (widget.deckId != -1) {
      await dbHelper.deleteCardsOfDeck(widget.deckId);

      await dbHelper.delete('decks', widget.deckId);
    }

    widget.onDeckUpdated();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _updateSaveButtonState();
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
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
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
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
                      onPressed: (isSaveButtonEnabled) ? _saveDeck : null,
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (widget.deckId == -1) ? null : _deleteDeck,
                      style: ElevatedButton.styleFrom(primary: Colors.red),
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
