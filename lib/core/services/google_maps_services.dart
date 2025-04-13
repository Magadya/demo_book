import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';

class GoogleMapsService {
  static Future<void> initGoogleMaps() async {
    try {
      const String apiKey = AppConstants.googleMapsApiKey;
      const channel = MethodChannel('google_maps_api_key');
      await channel.invokeMethod('setApiKey', {'apiKey': apiKey});
    } catch (e) {
      debugPrint('Error initializing Google Maps: $e');
    }
  }
}