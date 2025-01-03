part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  final User user;

  const AuthState(this.user);
}

final class AuthUnknown extends AuthState {
  AuthUnknown() : super(User.unknown);
}

final class AuthAccepted extends AuthState {
  const AuthAccepted(super.user);
}

final class AuthDenied extends AuthState {
  AuthDenied() : super(User.unknown);
}
