# MP5: Final Project - Braintastic

## Overview

Welcome to the Final Project - MP5! In this project, I've developed a trivia quiz app named "Braintastic" using the Flutter framework. The application challenges users with intriguing trivia questions sourced from the Open Trivia Database API. Below are the details of the project.

## Features

### 1. Navigation

Braintastic features at least 3 separate screens/pages, each implemented as a separate widget. The home page acts as the default screen, and users can seamlessly navigate between pages using a BottomNavigationBar, providing an intuitive and smooth user experience.

### 2. Stateful Widget and Model

The quiz page is backed by a stateful widget, supported by a custom model class. The model class efficiently manages the trivia data, ensuring dynamic updates as users progress through the quiz. State management is achieved using the Provider package, enhancing responsiveness.

### 3. Data Persistence

Braintastic persists crucial user data, such as quiz progress and settings, across application launches. SharedPreferences is employed to store and retrieve this information, contributing to a personalized and continuous quiz experience.

### 4. External Data Source

Dynamic trivia questions are fetched from the Open Trivia Database API using the `http` package. Users are presented with a diverse range of questions, enhancing the challenge and excitement of the quiz.

### 5. Testing

The project boasts a comprehensive testing suite, including unit, widget, and integration tests. Over 5 unit tests validate the functionality of model classes, while 5 widget tests ensure the correctness of custom quiz widgets. Integration tests showcase the flawless execution of core features, delivering a reliable quiz experience.

## Implementation Details

### Project Structure

The project adheres to Flutter conventions, featuring organized code in dedicated directories. Major widget classes reside in the "lib/views" directory, model classes in the "lib/models" directory, and utility classes in the "lib/utils" directory.

### External Packages

Braintastic makes use of the provided external packages and incorporates the Open Trivia Database API (https://opentdb.com/api_config.php) for dynamic quiz questions. All package usage aligns with Flutter best practices and contributes to the app's overall functionality.

## Braintastic Specifics

Braintastic is a trivia quiz app designed to challenge users with a variety of intriguing questions from different categories. Users can customize their quiz experience, track their progress, and compete with friends. The app aims to provide an engaging and educational platform for users to test and expand their knowledge.

## Testing

The project includes a robust testing suite covering unit, widget, and integration tests. These tests ensure the correctness and reliability of Braintastic across diverse components, delivering a seamless quiz experience.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
