part of 'location_bloc.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

class LocationPermissionGranted extends LocationState {}

class LocationPermissionDenied extends LocationState {}

class LocationPermissionPermanentlyDenied extends LocationState {}

class LocationFetching extends LocationState {}

class LocationFetchSuccess extends LocationState {
  final Position position;

  LocationFetchSuccess(this.position);
}

class LocationFetchFailure extends LocationState {
  final String message;

  LocationFetchFailure(this.message);
}

class OpenMapSuccess extends LocationState {}

class OpenMapLoading extends LocationState {}

class OpenMapFailure extends LocationState {
  final String message;

  OpenMapFailure(this.message);
}