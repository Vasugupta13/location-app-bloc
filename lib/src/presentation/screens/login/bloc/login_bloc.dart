import 'package:parkin_assessment/src/presentation/common_blocs/auth/bloc.dart';
import 'package:parkin_assessment/src/presentation/screens/login/bloc/login_event.dart';
import 'package:parkin_assessment/src/presentation/screens/login/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;
  LoginBloc({required this.authBloc}) : super(LoginInitial()) {

    ///Handles login button press
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        authBloc.add(SignInEvent(event.email, event.password));
        await for (final state in authBloc.stream) {
          if (state is AuthAuthenticated) {
            emit(LoginInitial());
            break;
          } else if (state is AuthError) {
            emit(LoginFailure(error: state.message));
            break;
          }
        }
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });

    ///Handles password visibility
    on<TogglePasswordVisibility>((event, emit) {
      if (state is LoginShowPass) {
        final currentState = state as LoginShowPass;
        emit(LoginShowPass(isShowPassword: !currentState.isShowPassword));
      } else {
        emit(LoginShowPass(isShowPassword: true));
      }
    });
  }
}
