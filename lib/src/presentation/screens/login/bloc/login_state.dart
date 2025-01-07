abstract class LoginState {}

class LoginInitial extends LoginState {
}

class LoginShowPass extends LoginState {
  final bool isShowPassword;

  LoginShowPass({this.isShowPassword = false});

  LoginShowPass copyWith({bool? isShowPassword, String? selectedRole}) {
    return LoginShowPass(
      isShowPassword: isShowPassword ?? this.isShowPassword,
    );
  }
}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}