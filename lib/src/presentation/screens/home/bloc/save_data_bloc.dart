

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkin_assessment/src/data/models/user_data.dart';
import 'package:parkin_assessment/src/data/repository/save_user_data_repo.dart';

part 'save_data_event.dart';
part 'save_data_state.dart';

class SaveDataBloc extends Bloc<SaveDataEvent, SaveDataState> {
  final SaveUserDataRepo saveUserDataRepo;

  SaveDataBloc({required this.saveUserDataRepo}) : super(SaveDataInitial()) {
    on<SaveUserData>(_onSaveUserData);
    on<FetchUserData>(_onFetchUserData);
    on<DeleteUserData>(_onDeleteUserData);
  }

  Future<void> _onSaveUserData(SaveUserData event, Emitter<SaveDataState> emit) async {
    emit(SaveDataLoading());
    try {
      await saveUserDataRepo.saveUserData(event.name, event.age, event.note);
      final userDataList = saveUserDataRepo.fetchUserData();
      emit(SaveDataSuccess(userDataList));
    } catch (e) {
      emit(SaveDataFailure(e.toString()));
    }
  }

  Future<void> _onFetchUserData(FetchUserData event, Emitter<SaveDataState> emit) async {
    emit(SaveDataLoading());
    try {
      final userDataList = saveUserDataRepo.fetchUserData();
      emit(SaveDataSuccess(userDataList));
    } catch (e) {
      emit(SaveDataFailure(e.toString()));
    }
  }
  Future<void> _onDeleteUserData(DeleteUserData event, Emitter<SaveDataState> emit) async {
    emit(SaveDataLoading());
    try {
      await saveUserDataRepo.deleteUserDataByDate(event.userData.time);
      final userDataList = saveUserDataRepo.fetchUserData();
      emit(SaveDataSuccess(userDataList));
    } catch (e) {
      emit(SaveDataFailure(e.toString()));
    }
  }
}
