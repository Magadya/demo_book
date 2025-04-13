import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/location_entity.dart';

abstract class LocationRepository {
  Future<Either<Failure, LocationEntity>> getCurrentLocation();
  Future<Either<Failure, String>> getAddressFromCoordinates(double lat, double lng);
  Future<Either<Failure, List<LocationEntity>>> getRoutePoints(LocationEntity start, LocationEntity end);
}