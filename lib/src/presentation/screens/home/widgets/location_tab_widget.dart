import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parkin_assessment/src/configs/config.dart';
import 'package:parkin_assessment/src/constants/color_constant.dart';
import 'package:parkin_assessment/src/presentation/common_blocs/location/location_bloc.dart';
import 'package:parkin_assessment/src/utils/gradient_button.dart';

class LocationTabWidget extends StatefulWidget {
  const LocationTabWidget({super.key});

  @override
  State<LocationTabWidget> createState() => _LocationTabWidgetState();
}

class _LocationTabWidgetState extends State<LocationTabWidget> {
  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(RequestLocationPermission());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is LocationInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LocationPermissionGranted) {
          return Center(
              child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.2),
            child: GradientButton(
              title: 'Fetch Location',
              fontSize: 13,
              onTap: () {
                context.read<LocationBloc>().add(FetchLocation());
              },
            ),
          ));
        } else if (state is LocationFetching) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LocationFetchSuccess) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Location fetched successfully!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: COLOR_CONST.primaryLightColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Latitude: ${state.position.latitude.toStringAsPrecision(5)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Longitude: ${state.position.longitude.toStringAsPrecision(5)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 0.1),
                  child: GradientButton(
                    title: 'Open Location in Google maps',
                    fontSize: 13,
                    onTap: () {
                      context
                          .read<LocationBloc>()
                          .add(OpenLocationPressed(state.position));
                    },
                  ),
                )
              ],
            ),
          );
        } else if (state is LocationFetchFailure) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        } else if (state is OpenMapFailure) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        } else if (state is LocationPermissionDenied) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<LocationBloc>().add(RequestLocationPermission());
              },
              child: const Text('Allow Permission'),
            ),
          );
        } else if (state is LocationPermissionPermanentlyDenied) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Permission Permanently Denied'),
                ElevatedButton(
                  onPressed: () {
                    Geolocator.openAppSettings();
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
