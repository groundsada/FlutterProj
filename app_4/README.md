# Battleships App

## Overview

Welcome to the Battleships App! As the developer behind this project, I've created an application that interfaces with a RESTful service, allowing users to register, log in, and play games of Battleships against both human and computer opponents. The app integrates a prototypical RESTful API into a Flutter application, using asynchronous operations provided by the `http` package to communicate with the API.

## Features

### User Authentication

1. **Logging In and Registering New Users:** Users can log in with their username and password or register for a new account.

2. **Session Token Management:** The app keeps track of session tokens across application restarts. Users are required to log in again after their session tokens expire.

### Game Management

3. **Listing Ongoing and Completed Games:** The game list page displays active, matchmaking, and completed games. Users can manually refresh the list of games.

4. **Starting New Games:** Users can start new games with both human and AI opponents. The game board allows users to place ships before starting a game.

### Playing Games

5. **Gameplay Screen:** The gameplay screen displays the game board and allows users to play the game if it is their turn. It provides information on ships, wrecks, missed shots, sunk ships, and the game's status.

6. **Responsive Game Board:** The game board is appropriately responsive, adapting to different screen sizes.

### Additional Features

7. **Log Out:** Users can log out, expunging the session token.

## Project Structure

### Code Organization

The project follows Flutter conventions, with major widget classes residing in the "lib/views" directory. Model classes are located in the "lib/models" directory, and helper classes can be found in the "lib/utils" directory.

### External Packages

The following packages are included in the `pubspec.yaml` file:

- [`http`](https://pub.dev/packages/http): For HTTP communication with the RESTful API.
- [`shared_preferences`](https://pub.dev/packages/shared_preferences): For local storage of session tokens.
- [`provider`](https://pub.dev/packages/provider): For state management.

Do not add additional packages without consulting with us.

### RESTful API Documentation

Detailed documentation for the Battleships REST API is provided in the MP description.

### Implementation Details

- Modular UI Code: Modularized UI code for easy readability and understanding.
- Asynchronous Operations: Asynchronous operations are managed without blocking the UI using `FutureProvider`, `FutureBuilder`, or `StreamBuilder`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
