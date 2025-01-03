part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthCheckRequested extends AuthEvent {}

final class AuthLogoutRequested extends AuthEvent {}