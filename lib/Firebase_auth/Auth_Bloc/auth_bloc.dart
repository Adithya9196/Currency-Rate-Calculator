import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Auth_Repository/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;
  late final StreamSubscription<User?> _sub;

  AuthBloc(this.repo) : super(AuthInitial()) {
    _sub = repo.authState.listen((user) {
      if (user == null) {
        add(_InternalAuthChanged(false, null));
      } else {
        add(_InternalAuthChanged(true, user));
      }
    });

    on<_InternalAuthChanged>((event, emit) {
      if (event.signedIn) {
        emit(AuthAuthenticated(event.user!));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await repo.login(event.email.trim(), event.password);
      } catch (e) {
        emit(AuthError(firebaseErrorMessage(e.toString())));
      }
    });

    on<AuthRegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await repo.register(event.email.trim(), event.password);
      } catch (e) {
        emit(AuthError(firebaseErrorMessage(e.toString())));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await repo.logout();
      } catch (e) {
        emit(AuthError(firebaseErrorMessage(e.toString())));
      }
    });
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}

class _InternalAuthChanged extends AuthEvent {
  final bool signedIn;
  final User? user;
  _InternalAuthChanged(this.signedIn, this.user);
}
