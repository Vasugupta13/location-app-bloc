part of 'save_data_bloc.dart';

@immutable
sealed class SaveDataState {}

class SaveDataInitial extends SaveDataState {}

class SaveDataLoading extends SaveDataState {}

class SaveDataSuccess extends SaveDataState {
  final List<UserData> userDataList;

  SaveDataSuccess(this.userDataList);
}

class SaveDataFailure extends SaveDataState {
  final String error;

  SaveDataFailure(this.error);
}