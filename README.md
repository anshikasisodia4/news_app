# NewsNest 📰

NewsNest is a Flutter news app that lets users browse, search, and save news articles in one place.

## Features

- Email, Google & Phone Authentication
- Latest news using GNews API
- Search news
- News categories
- Save and remove bookmarks
- Firebase Firestore
- Open full articles in the browser
- Dark theme
- Login/logout with persistent login state

## Tech Stack

- Flutter & Dart
- Firebase Authentication
- Cloud Firestore
- GNews API
- Provider
- URL Launcher

## Project Structure

lib/
├── models/
├── services/
├── providers/
├── utils/
├── widgets/
└── views/

The project follows an MVC-style structure with Provider for state management.

## Setup

1. Clone the repository.

2. Install dependencies:

flutter pub get

3. Configure Firebase.

4. Add your GNews API key in:

lib/services/news_api_service.dart

5. Run the app:

flutter run

## Author
Anshika Sisodiya

NewsNest - Flutter News App

Built with Flutter & Firebase 