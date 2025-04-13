import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/location_entity.dart';
import '../blocs/location/location_bloc.dart';
import '../blocs/location/location_event.dart';
import '../blocs/location/location_state.dart';
import '../widgets/address_search_widget.dart';
import '../widgets/app_snack_bar_widget.dart';
import '../widgets/map_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(GetCurrentLocationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Booking'),
      ),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            AppSnackBarWidget.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final locationBloc = context.read<LocationBloc>();
          final pickup = locationBloc.pickup;
          final destination = locationBloc.destination;

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Map
                    MapWidget(
                      initialLocation: pickup,
                      pickup: pickup,
                      destination: destination,
                      routePoints: state is RouteLoaded ? state.routePoints : null,
                    ),

                    // Loading indicator
                    if (state is LocationLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),

              // Location inputs
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    AddressSearchWidget(
                      label: 'Pickup Location',
                      address: pickup?.address,
                      onLocationSelected: (location) {
                        locationBloc.add(UpdatePickupLocationEvent(location));
                      },
                      onTap: () => _navigateToLocationSelection(context, isPickup: true),
                    ),
                    const SizedBox(height: 8),
                    AddressSearchWidget(
                      label: 'Destination',
                      address: destination?.address,
                      onLocationSelected: (location) {
                        locationBloc.add(UpdateDestinationLocationEvent(location));
                      },
                      onTap: () => _navigateToLocationSelection(context, isPickup: false),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: pickup != null && destination != null
                          ? () => _navigateToRideDetails(context, pickup, destination)
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToLocationSelection(BuildContext context, {required bool isPickup}) {
    context.pushNamed(
      'selectLocation',
      extra: {'isPickup': isPickup},
    );
  }

  void _navigateToRideDetails(
    BuildContext context,
    LocationEntity pickup,
    LocationEntity destination,
  ) {
    context.pushNamed(
      'rideDetails',
      extra: {
        'pickup': pickup,
        'destination': destination,
      },
    );
  }
}
