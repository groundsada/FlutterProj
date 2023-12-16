# Flashcards App

[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=12417039&assignment_repo_type=AssignmentRepo)

## Overview

Welcome to the Flashcards App! As the developer behind this project, I've designed a multi-page application that empowers users to create, edit, and manage decks of two-sided flashcards. The app also supports running quizzes using cards drawn from a selected deck. The application uses Flutter and incorporates techniques related to navigation, responsive design, state management, and persistence.

## Features

### Deck Management

1. **Creating, Editing, and Deleting Decks:** Users can effortlessly create, edit, and delete decks. Each deck is identified by a title, and the app displays the current number of cards in each deck alongside its title.

2. **Loading Starter Decks from JSON:** The app allows users to load a "starter set" of decks and flashcards from a provided JSON file.

### Flashcard Management

3. **Creating, Editing, Sorting, and Deleting Flashcards:** Users have the flexibility to create, edit, sort, and delete flashcards associated with a specific deck.

### Persistence

4. **Persistence of Decks and Flashcards:** All deck and flashcard information is persisted to a local SQLite database, ensuring data continuity across application restarts.

### Quiz Functionality

5. **Running Quizzes:** Users can run quizzes with flashcards from a specific deck. The quiz page displays flashcards randomly shuffled, and users can navigate both forward and backward through the cards.

### Responsive Design

6. **Responsive UI:** The app adapts to changes in screen size, ensuring an optimal user experience. The layout adjusts based on available screen real estate.

## Project Structure

### Code Organization

The project follows Flutter conventions, with major widget classes residing in the "lib/views" directory. Model classes are located in the "lib/models" directory, and helper classes can be found in the "lib/utils" directory.

### External Packages

The following packages are included in the `pubspec.yaml` file:

- [`provider`](https://pub.dev/packages/provider): State management
- [`collection`](https://pub.dev/packages/collection): Data structure operations
- [`sqflite`](https://pub.dev/packages/sqflite): Database operations
- [`path_provider`](https://pub.dev/packages/path_provider): Filesystem access
- [`path`](https://pub.dev/packages/path): Path manipulation

Do not add additional packages without consulting with us.

### Database

The app utilizes the [`sqflite`](https://pub.dev/packages/sqflite) package to persist data to a local SQLite database. Separate tables for decks and cards are maintained, linked by a foreign key.

### Navigation

Navigation between different pages is managed using `MaterialApp`'s `Navigator` with `push` and `pop` operations. The app includes distinct pages for deck list, deck editor, card list, card editor, and quiz.

### JSON Initialization

A JSON file at "assets/flashcards.json" contains a set of decks and cards for initializing the database. The app loads this file using `rootBundle`, parses it with the `json` package, and inserts the data into the database upon user request.

### Asynchronous Operations

Asynchronous operations, including database operations, are managed without blocking the UI. Widgets such as `FutureProvider`, `FutureBuilder`, or `StreamBuilder` are employed to display loading indicators during lengthy operations.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
