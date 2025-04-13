import '../../domain/entities/ride_request_entity.dart';
import 'location_model.dart';

class RideRequestModel extends RideRequestEntity {
  const RideRequestModel({
    required LocationModel super.pickup,
    required LocationModel super.destination,
    required super.passengersCount,
    required super.rideTime,
    super.id,
  });

  factory RideRequestModel.fromJson(Map<String, dynamic> json) {
    return RideRequestModel(
      pickup: LocationModel.fromJson(json['pickup']),
      destination: LocationModel.fromJson(json['destination']),
      passengersCount: json['passengersCount'],
      rideTime: DateTime.parse(json['rideTime']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickup': (pickup as LocationModel).toJson(),
      'destination': (destination as LocationModel).toJson(),
      'passengersCount': passengersCount,
      'rideTime': rideTime.toIso8601String(),
      'id': id,
    };
  }

  factory RideRequestModel.fromEntity(RideRequestEntity request) {
    return RideRequestModel(
      pickup: LocationModel.fromEntity(request.pickup),
      destination: LocationModel.fromEntity(request.destination),
      passengersCount: request.passengersCount,
      rideTime: request.rideTime,
      id: request.id,
    );
  }
}
