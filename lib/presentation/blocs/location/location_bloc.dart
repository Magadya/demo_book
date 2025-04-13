import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_current_location.dart';
import '../../../domain/usecases/get_route.dart';
import '../../../domain/entities/location_entity.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final GetRoute getRoute;

  LocationEntity? _pickup;
  LocationEntity? _destination;

  LocationBloc({
    required this.getCurrentLocation,
    required this.getRoute,
  }) : super(LocationInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<UpdatePickupLocationEvent>(_onUpdatePickupLocation);
    on<UpdateDestinationLocationEvent>(_onUpdateDestinationLocation);
    on<GetRouteEvent>(_onGetRoute);
  }

  LocationEntity? get pickup => _pickup;
  LocationEntity? get destination => _destination;

  Future<void> _onGetCurrentLocation(
      GetCurrentLocationEvent event,
      Emitter<LocationState> emit,
      ) async {
    emit(LocationLoading());
    final result = await getCurrentLocation();
    result.fold(
          (failure) => emit(LocationError(failure.message)),
          (location) {
        _pickup = location;
        emit(CurrentLocationLoaded(location));
      },
    );
  }

  Future<void> _onUpdatePickupLocation(
      UpdatePickupLocationEvent event,
      Emitter<LocationState> emit,
      ) async {
    _pickup = event.location;
    emit(PickupLocationUpdated(event.location));
  }

  Future<void> _onUpdateDestinationLocation(
      UpdateDestinationLocationEvent event,
      Emitter<LocationState> emit,
      ) async {
    _destination = event.location;
    emit(DestinationLocationUpdated(event.location));


    if (_pickup != null && _destination != null) {
      add(GetRouteEvent(pickup: _pickup!, destination: _destination!));
    }
  }

  Future<void> _onGetRoute(
      GetRouteEvent event,
      Emitter<LocationState> emit,
      ) async {
    emit(LocationLoading());
    final result = await getRoute(event.pickup, event.destination);
    result.fold(
          (failure) => emit(LocationError(failure.message)),
          (routePoints) => emit(RouteLoaded(
        routePoints: routePoints,
        pickup: event.pickup,
        destination: event.destination,
      )),
    );
  }
}