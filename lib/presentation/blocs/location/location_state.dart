import 'package:equatable/equatable.dart';
import '../../../domain/entities/location_entity.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class CurrentLocationLoaded extends LocationState {
  final LocationEntity location;

  const CurrentLocationLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

class PickupLocationUpdated extends LocationState {
  final LocationEntity location;

  const PickupLocationUpdated(this.location);

  @override
  List<Object?> get props => [location];
}

class DestinationLocationUpdated extends LocationState {
  final LocationEntity location;

  const DestinationLocationUpdated(this.location);

  @override
  List<Object?> get props => [location];
}

class RouteLoaded extends LocationState {
  final List<LocationEntity> routePoints;
  final LocationEntity pickup;
  final LocationEntity destination;

  const RouteLoaded({
    required this.routePoints,
    required this.pickup,
    required this.destination,
  });

  @override
  List<Object?> get props => [routePoints, pickup, destination];
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}