# Yahtzee Game App

## Overview

Welcome to the Yahtzee Game App! As the developer behind this project, I've crafted a single-player version of the classic [Yahtzee](https://en.wikipedia.org/wiki/Yahtzee) game using Flutter. The primary goal of this implementation is to showcase the usage of stateful widgets and state-management techniques in a non-trivial, single-page application.

## Features

### Dice Rolling Mechanism

The app allows players to roll five dice up to three times per turn. The rolling mechanism includes the ability to hold and unhold dice strategically. The most recently rolled dice faces are displayed, along with indicators for held dice.

### Scorecard Functionality

Players can choose a scoring category to end each turn. The app features a scorecard that keeps track of used and unused categories, displaying the current score for each used category. Scoring is correctly calculated for all categories, contributing to the total score.

### Game State Management

The game progresses until the player has entered a score in each of the 13 categories on the scorecard. The app then displays the final score and resets to the initial state, ready for another round. The game state is effectively managed using stateful widgets and state management techniques.

### User Interface Modularization

To enhance code readability and organization, the UI code is modularized into separate widgets. The main Yahtzee game container, the dice display, and the scorecard display each have their dedicated widgets. Additional widgets are created as needed, with a focus on maintaining a clean and manageable code structure.

## Project Structure

### Code Organization

The project structure follows Flutter conventions, with modifications made primarily in the `lib/main.dart` file. UI-related source files, such as custom `Widget`s, are stored in the `lib/views` directory. Data model source files, like `Dice`, `ScoreCategory`, and `Scorecard`, can be found in the `lib/models` directory. Image files are added to the `assets/images` directory.

### External Packages

The project includes the `provider` and `collection` packages for state management and data structure operations.

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
