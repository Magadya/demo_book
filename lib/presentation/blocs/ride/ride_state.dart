import 'package:equatable/equatable.dart';

abstract class RideState extends Equatable {
  const RideState();

  @override
  List<Object?> get props => [];
}

class RideInitial extends RideState {}

class RideLoading extends RideState {}

class PassengersCountUpdated extends RideState {
  final int count;

  const PassengersCountUpdated(this.count);

  @override
  List<Object?> get props => [count];
}

class RideTimeUpdated extends RideState {
  final DateTime dateTime;

  const RideTimeUpdated(this.dateTime);

  @override
  List<Object?> get props => [dateTime];
}

class RideRequestSubmitted extends RideState {
  final String rideId;

  const RideRequestSubmitted(this.rideId);

  @override
  List<Object?> get props => [rideId];
}

class RideError extends RideState {
  final String message;

  const RideError(this.message);

  @override
  List<Object?> get props => [message];
}
