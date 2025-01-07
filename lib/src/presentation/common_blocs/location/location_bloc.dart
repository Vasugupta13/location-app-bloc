import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<RequestLocationPermission>(_onRequestLocationPermission);
    on<FetchLocation>(_onFetchLocation);
    on<OpenLocationPressed>(_onOpenLocationPressed);
  }

  Future<void> _onRequestLocationPermission(
      RequestLocationPermission event, Emitter<LocationState> emit) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(LocationPermissionDenied());
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(LocationPermissionPermanentlyDenied());
      return;
    }

    emit(LocationPermissionGranted());
  }

  Future<void> _onFetchLocation(
      FetchLocation event, Emitter<LocationState> emit) async {
    try {
      emit(LocationFetching());
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      emit(LocationFetchSuccess(position));
    } catch (e) {
      emit(LocationFetchFailure(e.toString()));
    }
  }
  Future<void> _onOpenLocationPressed(
      OpenLocationPressed event, Emitter<LocationState> emit) async {
    try {
      emit(OpenMapLoading());
      String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${event.position.latitude},${event.position.latitude}';
      if (await canLaunchUrl(Uri.parse(googleUrl))) {
        await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.externalApplication);
        emit(LocationFetchSuccess(event.position));
      } else {
        throw 'Could not open the map.';
      }
    } catch (e) {
      emit(OpenMapFailure(e.toString()));
    }
  }
}
