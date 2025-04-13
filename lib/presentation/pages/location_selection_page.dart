import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import '../blocs/location/location_bloc.dart';
import '../blocs/location/location_event.dart';
import '../widgets/map_widget.dart';
import '../widgets/address_search_widget.dart';
import '../../domain/entities/location_entity.dart';

class LocationSelectionPage extends StatefulWidget {
  final bool isPickup;

  const LocationSelectionPage({
    super.key,
    required this.isPickup,
  });

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  LocationEntity? _selectedLocation;
  String? _address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isPickup ? 'Select Pickup' : 'Select Destination'),
      ),
      body: Stack(
        children: [
          // Map for location selection
          MapWidget(
            initialLocation: context.read<LocationBloc>().pickup,
            onLocationSelected: _onLocationSelected,
          ),

          // Marker at the center (for UI feedback)
          if (_selectedLocation == null)
            const Center(
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),

          // Search bar at the top
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: AddressSearchWidget(
              label: widget.isPickup ? 'Search Pickup Location' : 'Search Destination',
              address: _address,
              onLocationSelected: (location) {
                setState(() {
                  _selectedLocation = location;
                  _address = location.address;
                });

                // Center map on the selected location
                if (_selectedLocation != null) {
                  _confirmLocation(context);
                }
              },
              onTap: () {},
            ),
          ),

          // Bottom panel showing selected location info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.isPickup ? 'Pickup Location' : 'Destination',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(_address ?? 'Tap on the map to select a location or search above'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _selectedLocation != null
                        ? () => _confirmLocation(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Confirm Location'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onLocationSelected(LocationEntity location) async {
    setState(() {
      _selectedLocation = location;
      _address = 'Loading address...';
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address = "${place.street}, ${place.locality}, ${place.country}";
          _selectedLocation = LocationEntity(
            latitude: location.latitude,
            longitude: location.longitude,
            address: _address,
          );
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Address not available';
      });
    }
  }

  void _confirmLocation(BuildContext context) {
    if (_selectedLocation != null) {
      final locationBloc = context.read<LocationBloc>();

      if (widget.isPickup) {
        locationBloc.add(UpdatePickupLocationEvent(_selectedLocation!));
      } else {
        locationBloc.add(UpdateDestinationLocationEvent(_selectedLocation!));
      }

      context.pop();
    }
  }
}