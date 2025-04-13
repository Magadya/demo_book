import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/location_entity.dart';

class LocationUtils {
  static LatLng locationToLatLng(LocationEntity location) {
    return LatLng(location.latitude, location.longitude);
  }

  static LocationEntity latLngToLocation(LatLng latLng) {
    return LocationEntity(latitude: latLng.latitude, longitude: latLng.longitude);
  }

  static double calculateDistance(LocationEntity start, LocationEntity end) {
    return 0.0;
  }
}
