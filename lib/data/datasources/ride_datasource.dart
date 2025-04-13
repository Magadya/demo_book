import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/failures.dart';
import '../models/ride_request_model.dart';

class RideDataSource {
  Future<String> submitRideRequest(RideRequestModel rideRequest) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final String rideId = const Uuid().v4();

      debugPrint('Ride request submitted with ID: $rideId');
      debugPrint('Request details: ${rideRequest.toJson()}');

      return rideId;
    } catch (e) {
      throw RideFailure('Failed to submit ride request: ${e.toString()}');
    }
  }
}
