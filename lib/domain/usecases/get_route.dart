import 'package:dartz/dartz.dart';
import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';
import '../../core/errors/failures.dart';

class GetRoute {
  final LocationRepository repository;

  GetRoute(this.repository);

  Future<Either<Failure, List<LocationEntity>>> call(LocationEntity start, LocationEntity end) async {
    return await repository.getRoutePoints(start, end);
  }
}