part of 'permissions_cubit.dart';

@immutable
sealed class PermissionsState {}

final class PermissionsInitial extends PermissionsState {}

final class PermissionsGranted extends PermissionsState {}

final class PermissionsDenied extends PermissionsState {}
