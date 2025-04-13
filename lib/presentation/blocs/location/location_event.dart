import 'package:equatable/equatable.dart';

import '../../../domain/entities/location_entity.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentLocationEvent extends LocationEvent {}

class UpdatePickupLocationEvent extends LocationEvent {
  final LocationEntity location;

  const UpdatePickupLocationEvent(this.location);

  @override
  List<Object?> get props => [location];
}

class UpdateDestinationLocationEvent extends LocationEvent {
  final LocationEntity location;

  const UpdateDestinationLocationEvent(this.location);

  @override
  List<Object?> get props => [location];
}

class GetRouteEvent extends LocationEvent {
  final LocationEntity pickup;
  final LocationEntity destination;

  const GetRouteEvent({
    required this.pickup,
    required this.destination,
  });

  @override
  List<Object?> get props => [pickup, destination];
}