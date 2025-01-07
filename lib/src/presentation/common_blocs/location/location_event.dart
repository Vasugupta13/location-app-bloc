part of 'location_bloc.dart';

@immutable
sealed class LocationEvent {}

class RequestLocationPermission extends LocationEvent {}

class FetchLocation extends LocationEvent {}

class OpenLocationPressed extends LocationEvent {
  final Position position;

  OpenLocationPressed(this.position,);
}