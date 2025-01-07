import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkin_assessment/src/data/repository/auth_repo.dart';
import 'package:parkin_assessment/src/data/repository/save_user_data_repo.dart';
import 'package:parkin_assessment/src/presentation/common_blocs/auth/bloc.dart';
import 'package:parkin_assessment/src/presentation/common_blocs/connectivity/connectivity_bloc.dart';
import 'package:parkin_assessment/src/presentation/screens/home/bloc/save_data_bloc.dart';

import 'location/location_bloc.dart';

class CommonBloc {
  /// Bloc
  static final authenticationBloc = AuthBloc(AuthRepository());
  static final connectivityBloc = ConnectivityBloc();
  static final locationBloc = LocationBloc();
  static final saveDataBloc = SaveDataBloc(saveUserDataRepo: SaveUserDataRepo());

  static final List<BlocProvider> blocProviders = [

    BlocProvider<AuthBloc>(
      create: (context) => authenticationBloc,
    ),
    BlocProvider<ConnectivityBloc>(
      create: (context) => connectivityBloc,
    ),
    BlocProvider<LocationBloc>(
      create: (context) => locationBloc,
    ),
    BlocProvider<SaveDataBloc>(
      create: (context) => saveDataBloc,
    ),
  ];

  /// Dispose
  static void dispose() {
    authenticationBloc.close();
    connectivityBloc.close();
    locationBloc.close();
  }

  /// Singleton factory
  static final CommonBloc _instance = CommonBloc._internal();

  factory CommonBloc() {
    return _instance;
  }
  CommonBloc._internal();
}
