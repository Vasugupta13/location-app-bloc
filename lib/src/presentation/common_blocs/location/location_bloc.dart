import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    // Register event handlers for different location events
    on<RequestLocationPermission>(_onRequestLocationPermission);
    on<FetchLocation>(_onFetchLocation);
    on<OpenLocationPressed>(_onOpenLocationPressed);
  }

  /// Handles requesting location permission from the user.
  Future<void> _onRequestLocationPermission(
      RequestLocationPermission event, Emitter<LocationState> emit) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(LocationPermissionDenied());
        // Emit if permission is denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(LocationPermissionPermanentlyDenied());
      // Emit if permission is permanently denied
      return;
    }

    emit(LocationPermissionGranted());
    // Emit if permission is granted
  }

  /// Fetches the current location of the user.
  Future<void> _onFetchLocation(
      FetchLocation event, Emitter<LocationState> emit) async {
    try {
      emit(LocationFetching());
      // Emit loading state
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      emit(LocationFetchSuccess(position));
      // Emit success with fetched position
    } catch (e) {
      emit(LocationFetchFailure(e.toString()));
      // Emit failure if fetching fails
    }
  }

  /// Opens the Google Maps app with the given position.
  Future<void> _onOpenLocationPressed(
      OpenLocationPressed event, Emitter<LocationState> emit) async {
    try {
      emit(OpenMapLoading());
      // Emit loading state for map opening
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=${event.position.latitude},${event.position.latitude}';
      if (await canLaunchUrl(Uri.parse(googleUrl))) {
        await launchUrl(Uri.parse(googleUrl),
            mode: LaunchMode.externalApplication);
        // Launch Google Maps
        emit(LocationFetchSuccess(event.position));
        // Emit success after opening map
      } else {
        throw 'Could not open the map.';
        // Throw an error if the map can't open
      }
    } catch (e) {
      emit(OpenMapFailure(e.toString()));
      // Emit failure if map opening fails
    }
  }
}

