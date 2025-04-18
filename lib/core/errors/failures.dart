import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

class RideFailure extends Failure {
  const RideFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}