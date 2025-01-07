part of 'save_data_bloc.dart';

@immutable
sealed class SaveDataEvent {}

class SaveUserData extends SaveDataEvent {
  final String name;
  final int age;
  final String note;

  SaveUserData(this.name, this.age, this.note);
}

class FetchUserData extends SaveDataEvent {}

class DeleteUserData extends SaveDataEvent {
  final UserData userData;

  DeleteUserData(this.userData);
}