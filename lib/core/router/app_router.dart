import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/location_selection_page.dart';
import '../../presentation/pages/ride_details_page.dart';
import '../../presentation/pages/ride_confirmation_page.dart';
import '../../domain/entities/location_entity.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/select-location',
        name: 'selectLocation',
        builder: (context, state) {
          try {
            final Map<String, dynamic> extra = state.extra as Map<String, dynamic>? ?? {'isPickup': true};
            final bool isPickup = extra['isPickup'] as bool? ?? true;
            return LocationSelectionPage(isPickup: isPickup);
          } catch (e) {
            debugPrint('Error in location selection route: $e');
            return const LocationSelectionPage(isPickup: true);
          }
        },
      ),
      GoRoute(
        path: '/ride-details',
        name: 'rideDetails',
        builder: (context, state) {
          try {
            final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
            final LocationEntity pickup = extra['pickup'] as LocationEntity;
            final LocationEntity destination = extra['destination'] as LocationEntity;

            return RideDetailsPage(
              pickup: pickup,
              destination: destination,
            );
          } catch (e) {
            debugPrint('Error in ride details route: $e');
            return const HomePage();
          }
        },
      ),
      GoRoute(
        path: '/confirmation',
        name: 'confirmation',
        builder: (context, state) {
          try {
            final String rideId = state.extra as String? ?? 'unknown';
            return RideConfirmationPage(rideId: rideId);
          } catch (e) {
            debugPrint('Error in confirmation route: $e');
            return const HomePage();
          }
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text('Navigation Error: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}