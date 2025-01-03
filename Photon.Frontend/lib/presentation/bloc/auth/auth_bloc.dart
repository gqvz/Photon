import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:photon/domain/models/user.dart';
import 'package:photon/domain/repositories/auth_repository.dart';

import '../../../domain/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
      AuthenticationRepository authenticationRepository,
      UserRepository userRepository,
      ) : _authenticationRepository = authenticationRepository, _userRepository = userRepository, super(AuthUnknown()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }
  
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  
  Future<void> _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    await Future.delayed(Duration(seconds: 1));
    emit(AuthAccepted(User.unknown));
  }
  
  Future<void> _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthUnknown());
    await Future.delayed(Duration(seconds: 1));
    emit(AuthDenied());
  }
}
