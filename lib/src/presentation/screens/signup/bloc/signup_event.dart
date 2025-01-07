part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

class SignupButtonPressed extends SignupEvent {
  final String email;
  final String password;
  final String name;

  SignupButtonPressed(
      {required this.email,
      required this.password,
      required this.name,});
}
class TogglePasswordVisibility extends SignupEvent {}

