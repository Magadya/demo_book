import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/location_datasource.dart';
import '../../data/datasources/ride_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/ride_repository_impl.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/ride_repository.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/get_route.dart';
import '../../domain/usecases/submit_ride_request.dart';
import '../../presentation/blocs/location/location_bloc.dart';
import '../../presentation/blocs/ride/ride_bloc.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  try {
    // Data sources
    sl.registerLazySingleton(() => LocationDataSource());
    sl.registerLazySingleton(() => RideDataSource());

    // Repositories
    sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl(dataSource: sl()));
    sl.registerLazySingleton<RideRepository>(() => RideRepositoryImpl(dataSource: sl()));

    // Use cases
    sl.registerLazySingleton(() => GetCurrentLocation(sl()));
    sl.registerLazySingleton(() => GetRoute(sl()));
    sl.registerLazySingleton(() => SubmitRideRequest(sl()));

    // BLoCs
    sl.registerFactory(() => LocationBloc(getCurrentLocation: sl(), getRoute: sl()));
    sl.registerFactory(() => RideBloc(submitRideRequest: sl()));
  } catch (e) {
    debugPrint('Error in dependency setup: $e');
  }
}