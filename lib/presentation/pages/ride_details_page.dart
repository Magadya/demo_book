import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/location_entity.dart';
import '../blocs/ride/ride_bloc.dart';
import '../blocs/ride/ride_event.dart';
import '../blocs/ride/ride_state.dart';
import '../widgets/app_snack_bar_widget.dart' show AppSnackBarWidget;
import '../widgets/map_widget.dart';
import '../widgets/ride_details_form.dart';

class RideDetailsPage extends StatelessWidget {
  final LocationEntity pickup;
  final LocationEntity destination;

  const RideDetailsPage({
    super.key,
    required this.pickup,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
      ),
      body: BlocConsumer<RideBloc, RideState>(
        listener: (context, state) {
          if (state is RideError) {
            AppSnackBarWidget.showError(context, state.message);
          } else if (state is RideRequestSubmitted) {
            context.goNamed('confirmation', extra: state.rideId);
          }
        },
        builder: (context, state) {
          final rideBloc = context.read<RideBloc>();

          return SingleChildScrollView(
            child: Column(
              children: [
                // Map showing the route
                SizedBox(
                  height: 250,
                  child: MapWidget(
                    pickup: pickup,
                    destination: destination,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ride info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLocationInfo(
                                'Pickup',
                                pickup.address ?? 'Unknown location',
                                Icons.trip_origin,
                                Colors.green,
                              ),
                              const Divider(),
                              _buildLocationInfo(
                                'Destination',
                                destination.address ?? 'Unknown location',
                                Icons.location_on,
                                Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Ride details form
                      RideDetailsForm(
                        passengersCount: rideBloc.passengersCount,
                        rideTime: rideBloc.rideTime,
                        onPassengersCountChanged: (count) {
                          rideBloc.add(UpdatePassengersCountEvent(count));
                        },
                        onRideTimeChanged: (dateTime) {
                          rideBloc.add(UpdateRideTimeEvent(dateTime));
                        },
                      ),

                      const SizedBox(height: 24),

                      // Book ride button
                      ElevatedButton(
                        onPressed: state is RideLoading ? null : () => _bookRide(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: state is RideLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Book Ride'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationInfo(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _bookRide(BuildContext context) {
    final rideBloc = context.read<RideBloc>();

    rideBloc.add(SubmitRideRequestEvent(
      pickup: pickup,
      destination: destination,
      passengersCount: rideBloc.passengersCount,
      rideTime: rideBloc.rideTime,
    ));
  }
}
