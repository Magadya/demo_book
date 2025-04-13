# Ride Booking App

A basic ride booking application developed with Flutter. This app allows users to select pickup and
destination locations on a map, specify passenger count, choose ride date and time, and confirm
bookings.

## Features

- Google Maps integration for location selection and route display
- Pickup and destination selection with automatic address detection
- Customizable passenger count and ride time settings
- Ride confirmation and booking flow
- Clean architecture using BLoC for state management

## Architecture

The application is built following Clean Architecture principles and consists of the following
layers:

1. **Presentation Layer**: Responsible for UI/UX, including widgets, screens, and BLoC components.
2. **Domain Layer**: Contains business logic, including entities, repositories, and use cases.
3. **Data Layer**: Handles data from external sources, including data models and repository
   implementations.
4. **Core**: Contains common components and utilities used throughout the application.

## Technologies and Libraries

- **Flutter**: Framework for building cross-platform applications
- **Google Maps API**: For maps integration and geocoding
- **BLoC Pattern**: For application state management
- **Go Router**: For navigation
- **Get It**: For dependency injection
- **Dartz**: For functional programming and error handling
- **Equatable**: For object comparison
- **Geolocator & Geocoding**: For working with geodata

## Project Setup

### Requirements

- Flutter SDK 3.0.0 or higher
- Dart 3.0.0 or higher
- Valid Google Maps API key

### Setup Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ride_booking_app.git
   cd ride_booking_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up Google Maps API:
    - Get a Google Maps API key from the [Google Cloud Console](https://console.cloud.google.com/)
    - Enable necessary APIs (Maps SDK for Android/iOS, Places API, Directions API)
    - Replace `YOUR_GOOGLE_MAPS_API_KEY` in `lib/core/constants/app_constants.dart` with your API
      key

4. Run the application:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── router/
│   ├── theme/
│   └── utils/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── blocs/
│   ├── pages/
│   └── widgets/
└── main.dart
```

## Future Improvements

- User authentication and profile management
- Payment integration
- Ride history
- Real-time driver tracking
- Push notifications
- Multi-language support

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

Dzmitry Mahadzia
