import 'package:equatable/equatable.dart';
import 'location_entity.dart';

class RideRequestEntity extends Equatable {
  final LocationEntity pickup;
  final LocationEntity destination;
  final int passengersCount;
  final DateTime rideTime;
  final String? id;

  const RideRequestEntity({
    required this.pickup,
    required this.destination,
    required this.passengersCount,
    required this.rideTime,
    this.id,
  });

  @override
  List<Object?> get props => [pickup, destination, passengersCount, rideTime, id];

  RideRequestEntity copyWith({
    LocationEntity? pickup,
    LocationEntity? destination,
    int? passengersCount,
    DateTime? rideTime,
    String? id,
  }) {
    return RideRequestEntity(
      pickup: pickup ?? this.pickup,
      destination: destination ?? this.destination,
      passengersCount: passengersCount ?? this.passengersCount,
      rideTime: rideTime ?? this.rideTime,
      id: id ?? this.id,
    );
  }
}