# Stock Manager

Stock Manager is a Flutter inventory app for tracking household or small-shop stock. It lets you add products, organize them by category, monitor stock health, and keep a simple local record of expiry dates and quantities.

## Features

- Dashboard with total products, out-of-stock items, and products expiring soon
- Add product flow with category, quantity, and expiry date
- Category filter on the home screen for quick browsing
- Category overview screen with grouped products and stock counts
- Dark mode toggle with saved theme preference
- Local offline persistence using Drift and Shared Preferences
- Seeded default categories such as Vegetables, Groceries, Clothes, and Others

## Tech Stack

- Flutter with Material 3
- Drift for local database access
- Shared Preferences for app settings
- Google Fonts for typography

## Project Structure

```text
lib/
  core/         Shared colors and design tokens
  database/     Drift tables, queries, and generated database code
  helper/       Date formatting helpers
  models/       UI-facing model adapters
  screens/      Main app screens
  services/     Persistent app settings
  widgets/      Reusable UI sections and components
```

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- A device or emulator for Android, iOS, macOS, Linux, Windows, or web

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

## Development Notes

The app stores data locally in a Drift database named `stock_manager`.

If you update database tables or Drift queries, regenerate the database code with:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Current Behavior

- Products are stored with a name, category, quantity, and expiry date
- Categories are automatically seeded on app startup if they do not already exist
- "Expiring soon" currently means within the next 4 days
- Theme preference is restored when the app launches

## Testing

Run the test suite with:

```bash
flutter test
```
