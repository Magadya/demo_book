import 'package:dartz/dartz.dart';
import '../entities/ride_request_entity.dart';
import '../../core/errors/failures.dart';

abstract class RideRepository {
  Future<Either<Failure, String>> submitRideRequest(RideRequestEntity rideRequest);
}