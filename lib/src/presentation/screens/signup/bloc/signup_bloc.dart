
import 'package:parkin_assessment/src/presentation/common_blocs/auth/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthBloc authBloc;
  SignupBloc({required this.authBloc}) : super(SignupShowPass()) {
    ///Handles sign up actions
    on<SignupButtonPressed>((event, emit) async {
      emit(SignupLoading());
      try {
        authBloc.add(SignUpEvent(event.email, event.password, event.name));
        await for (final state in authBloc.stream) {
          if (state is AuthAuthenticated) {
            emit(SignupShowPass());
            break;
          } else if (state is AuthError) {
            emit(SignupFailure(error: state.message));
            break;
          }
        }
      } catch (error) {
        emit(SignupFailure(error: error.toString()));
      }
    });

    ///Handles password visibility
    on<TogglePasswordVisibility>((event, emit) {
      if (state is SignupShowPass) {
        final currentState = state as SignupShowPass;
        emit(currentState.copyWith(isShowPassword: !currentState.isShowPassword));
      }
    });
  }
}
