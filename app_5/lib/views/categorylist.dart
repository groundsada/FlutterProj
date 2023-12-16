import 'package:flutter/material.dart';
import 'package:mp5/views/trivia.dart';

import '../models/categories_model.dart';

class CategoryList extends StatefulWidget {
  final bool timedMode;

  CategoryList({required this.timedMode});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final List<String> categories = Categories.getCategoryList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose a category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.yellow[700],
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 6,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                categories[index],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              tileColor: Colors.deepPurple,
              onTap: () {
                _startTrivia(context, categories[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _startTrivia(BuildContext context, String selectedCategory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TriviaPage(
          timedMode: widget.timedMode,
          selectedCategory: selectedCategory,
        ),
      ),
    );
  }
}
