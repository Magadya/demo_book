import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/submit_ride_request.dart';
import '../../../domain/entities/ride_request_entity.dart';
import '../../../core/constants/app_constants.dart';
import 'ride_event.dart';
import 'ride_state.dart';

class RideBloc extends Bloc<RideEvent, RideState> {
  final SubmitRideRequest submitRideRequest;
  int _passengersCount = AppConstants.defaultPassengersCount;
  DateTime _rideTime = DateTime.now().add(const Duration(minutes: 15));

  RideBloc({required this.submitRideRequest}) : super(RideInitial()) {
    on<UpdatePassengersCountEvent>(_onUpdatePassengersCount);
    on<UpdateRideTimeEvent>(_onUpdateRideTime);
    on<SubmitRideRequestEvent>(_onSubmitRideRequest);
  }

  int get passengersCount => _passengersCount;
  DateTime get rideTime => _rideTime;

  Future<void> _onUpdatePassengersCount(
      UpdatePassengersCountEvent event,
      Emitter<RideState> emit,
      ) async {
    if (event.count > 0 && event.count <= AppConstants.maxPassengersCount) {
      _passengersCount = event.count;
      emit(PassengersCountUpdated(_passengersCount));
    }
  }

  Future<void> _onUpdateRideTime(
      UpdateRideTimeEvent event,
      Emitter<RideState> emit,
      ) async {
    _rideTime = event.dateTime;
    emit(RideTimeUpdated(_rideTime));
  }

  Future<void> _onSubmitRideRequest(
      SubmitRideRequestEvent event,
      Emitter<RideState> emit,
      ) async {
    emit(RideLoading());

    final rideRequest = RideRequestEntity(
      pickup: event.pickup,
      destination: event.destination,
      passengersCount: event.passengersCount,
      rideTime: event.rideTime,
    );

    final result = await submitRideRequest(rideRequest);
    result.fold(
          (failure) => emit(RideError(failure.message)),
          (rideId) => emit(RideRequestSubmitted(rideId)),
    );
  }
}