import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/errors/failures.dart';
import '../models/location_model.dart';

class LocationDataSource {
  LocationDataSource();

  Future<LocationModel> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.requestPermission();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw const LocationFailure('Location services are disabled');
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const LocationFailure('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationFailure('Location permissions are permanently denied');
      }

      final position = await Geolocator.getCurrentPosition();
      final address = await getAddressFromCoordinates(position.latitude, position.longitude);

      return LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (e) {
      throw LocationFailure(e.toString());
    }
  }

  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.country}";
    } catch (e) {
      throw LocationFailure('Error getting address: ${e.toString()}');
    }
  }

  Future<List<LocationModel>> getRoutePoints(LocationModel start, LocationModel end) async {
    try {
      List<LocationModel> routePoints = [
        start,
        LocationModel(
          latitude: (start.latitude + end.latitude) / 2,
          longitude: (start.longitude + end.longitude) / 2,
        ),
        end
      ];

      return routePoints;
    } catch (e) {
      debugPrint('Error in getRoutePoints: ${e.toString()}');
      return [start, end];
    }
  }
}
