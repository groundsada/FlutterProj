import 'package:flutter/material.dart';
import 'package:mp3/views/decklist.dart';

void main() async {
  runApp(MaterialApp(
    theme: ThemeData.dark().copyWith(
      primaryColor: Colors.amber,
    ),
    debugShowCheckedModeBanner: false,
    home: const DeckList(),
  ));
}