import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkin_assessment/src/data/repository/auth_repo.dart';
import 'package:parkin_assessment/src/presentation/common_blocs/auth/bloc.dart';
import 'package:parkin_assessment/src/utils/validators.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  ///BLOC for authentication
  ///
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        if(!UtilValidators.isValidEmail(event.email)){
          emit(AuthError("Email is invalid"));
          return;
        }
        if(!UtilValidators.isValidPassword(event.password)){
          emit(AuthError("Password is invalid"));
          return;
        }
        final user = await _authRepository.signUp(event.email, event.password, event.name );
        emit(AuthAuthenticated(user!));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    ///[SignInEvent] triggered when user signs in
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        if(!UtilValidators.isValidEmail(event.email)){
          emit(AuthError("Email is invalid"));
          return;
        }
        if(!UtilValidators.isValidPassword(event.password)){
          emit(AuthError("Password is invalid"));
          return;
        }
        final user = await _authRepository.signIn(event.email, event.password);
        emit(AuthAuthenticated(user!,));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    ///[SignOutEvent] triggered when user signs out
    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    });

    ///[CheckAuthEvent] Check auth status
    on<CheckAuthEvent>((event, emit) async {
      final user = _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}