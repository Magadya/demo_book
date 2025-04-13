import 'package:dartz/dartz.dart';
import '../../domain/entities/ride_request_entity.dart';
import '../../domain/repositories/ride_repository.dart';
import '../datasources/ride_datasource.dart';
import '../models/ride_request_model.dart';
import '../../core/errors/failures.dart';

class RideRepositoryImpl implements RideRepository {
  final RideDataSource dataSource;

  RideRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, String>> submitRideRequest(RideRequestEntity rideRequest) async {
    try {
      final rideRequestModel = RideRequestModel.fromEntity(rideRequest);
      final rideId = await dataSource.submitRideRequest(rideRequestModel);
      return Right(rideId);
    } on RideFailure catch (e) {
      return Left(RideFailure(e.message));
    } catch (e) {
      return Left(RideFailure(e.toString()));
    }
  }
}