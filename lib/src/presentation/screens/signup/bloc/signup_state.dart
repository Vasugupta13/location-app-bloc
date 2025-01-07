part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupShowPass extends SignupState {
  final bool isShowPassword;

  SignupShowPass({this.isShowPassword = false,});

  SignupShowPass copyWith({bool? isShowPassword, String? selectedRole}) {
    return SignupShowPass(
      isShowPassword: isShowPassword ?? this.isShowPassword,
    );
  }
}

final class SignupLoading extends SignupState {}

final class SignupFailure extends SignupState {
  final String error;

  SignupFailure({required this.error});
}

