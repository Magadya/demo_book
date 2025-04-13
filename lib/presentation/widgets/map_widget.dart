import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/location_permission_service.dart';
import '../../core/utils/location_utils.dart';
import '../../domain/entities/location_entity.dart' as domain;

class MapWidget extends StatefulWidget {
  final domain.LocationEntity? initialLocation;
  final domain.LocationEntity? pickup;
  final domain.LocationEntity? destination;
  final List<domain.LocationEntity>? routePoints;
  final void Function(domain.LocationEntity)? onLocationSelected;

  const MapWidget({
    super.key,
    this.initialLocation,
    this.pickup,
    this.destination,
    this.routePoints,
    this.onLocationSelected,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  static const LatLng _defaultLocation = LatLng(52.2297, 21.0122);
  bool _isLocationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initializeLocationServices();
  }

  Future<void> _initializeLocationServices() async {
    _isLocationPermissionGranted = await LocationPermissionService.handleLocationPermission();

    if (mounted) {
      setState(() {
        _updateMarkers();
        _updatePolylines();
      });
    }
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pickup != widget.pickup ||
        oldWidget.destination != widget.destination ||
        oldWidget.routePoints != widget.routePoints) {
      _updateMarkers();
      _updatePolylines();
    }
  }

  void _updateMarkers() {
    setState(() {
      _markers.clear();

      if (widget.pickup != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('pickup'),
            position: LocationUtils.locationToLatLng(widget.pickup!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: 'Pickup Location'),
          ),
        );
      }

      if (widget.destination != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: LocationUtils.locationToLatLng(widget.destination!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(title: 'Destination'),
          ),
        );
      }
    });
  }

  void _updatePolylines() {
    setState(() {
      _polylines.clear();

      if (widget.routePoints != null && widget.routePoints!.isNotEmpty) {
        final List<LatLng> polylinePoints =
            widget.routePoints!.map((point) => LocationUtils.locationToLatLng(point)).toList();

        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            points: polylinePoints,
            width: 5,
          ),
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _moveToInitialLocation();
  }

  void _moveToInitialLocation() {
    if (_mapController == null) return;

    if (widget.initialLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LocationUtils.locationToLatLng(widget.initialLocation!),
          AppConstants.mapDefaultZoom,
        ),
      );
    } else if (widget.pickup != null && widget.destination != null) {
      // Zoom to show both pickup and destination
      LatLngBounds bounds = _getBounds([
        LocationUtils.locationToLatLng(widget.pickup!),
        LocationUtils.locationToLatLng(widget.destination!),
      ]);

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  LatLngBounds _getBounds(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;

    for (LatLng point in points) {
      minLat = minLat == null
          ? point.latitude
          : point.latitude < minLat
              ? point.latitude
              : minLat;
      maxLat = maxLat == null
          ? point.latitude
          : point.latitude > maxLat
              ? point.latitude
              : maxLat;
      minLng = minLng == null
          ? point.longitude
          : point.longitude < minLng
              ? point.longitude
              : minLng;
      maxLng = maxLng == null
          ? point.longitude
          : point.longitude > maxLng
              ? point.longitude
              : maxLng;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  void _onTap(LatLng latLng) {
    if (widget.onLocationSelected != null) {
      final location = domain.LocationEntity(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
      );

      widget.onLocationSelected!(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Если нет разрешения на геолокацию, показываем заглушку
    if (!_isLocationPermissionGranted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Location Permission Required'),
            ElevatedButton(
              onPressed: () async {
                final result = await LocationPermissionService.handleLocationPermission();
                if (result && mounted) {
                  setState(() {
                    _isLocationPermissionGranted = true;
                  });
                }
              },
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      );
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target:
            widget.initialLocation != null ? LocationUtils.locationToLatLng(widget.initialLocation!) : _defaultLocation,
        zoom: AppConstants.mapDefaultZoom,
      ),
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      onTap: widget.onLocationSelected != null ? _onTap : null,
    );
  }
}
