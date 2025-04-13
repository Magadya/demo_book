import 'package:dartz/dartz.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_datasource.dart';
import '../models/location_model.dart';
import '../../core/errors/failures.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation() async {
    try {
      final locationModel = await dataSource.getCurrentLocation();
      return Right(locationModel);
    } on LocationFailure catch (e) {
      return Left(LocationFailure(e.message));
    } catch (e) {
      return Left(LocationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final address = await dataSource.getAddressFromCoordinates(lat, lng);
      return Right(address);
    } on LocationFailure catch (e) {
      return Left(LocationFailure(e.message));
    } catch (e) {
      return Left(LocationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getRoutePoints(LocationEntity start, LocationEntity end) async {
    try {
      final startModel = LocationModel.fromEntity(start);
      final endModel = LocationModel.fromEntity(end);
      final routePoints = await dataSource.getRoutePoints(startModel, endModel);
      return Right(routePoints);
    } on LocationFailure catch (e) {
      return Left(LocationFailure(e.message));
    } catch (e) {
      return Left(LocationFailure(e.toString()));
    }
  }
}