import 'package:dartz/dartz.dart';
import '../entities/ride_request_entity.dart';
import '../repositories/ride_repository.dart';
import '../../core/errors/failures.dart';

class SubmitRideRequest {
  final RideRepository repository;

  SubmitRideRequest(this.repository);

  Future<Either<Failure, String>> call(RideRequestEntity rideRequest) async {
    return await repository.submitRideRequest(rideRequest);
  }
}