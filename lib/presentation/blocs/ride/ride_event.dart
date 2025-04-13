import 'package:equatable/equatable.dart';

import '../../../domain/entities/location_entity.dart';

abstract class RideEvent extends Equatable {
  const RideEvent();

  @override
  List<Object?> get props => [];
}

class UpdatePassengersCountEvent extends RideEvent {
  final int count;

  const UpdatePassengersCountEvent(this.count);

  @override
  List<Object?> get props => [count];
}

class UpdateRideTimeEvent extends RideEvent {
  final DateTime dateTime;

  const UpdateRideTimeEvent(this.dateTime);

  @override
  List<Object?> get props => [dateTime];
}

class SubmitRideRequestEvent extends RideEvent {
  final LocationEntity pickup;
  final LocationEntity destination;
  final int passengersCount;
  final DateTime rideTime;

  const SubmitRideRequestEvent({
    required this.pickup,
    required this.destination,
    required this.passengersCount,
    required this.rideTime,
  });

  @override
  List<Object?> get props => [pickup, destination, passengersCount, rideTime];
}
