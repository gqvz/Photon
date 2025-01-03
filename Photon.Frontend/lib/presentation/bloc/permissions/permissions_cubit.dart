import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'permissions_state.dart';

class PermissionsCubit extends Cubit<PermissionsState> {
  PermissionsCubit() : super(PermissionsInitial());
  
  Future<void> requestPermissions() async {
    emit(PermissionsInitial());
    await Future.delayed(Duration(seconds: 1));
    emit(PermissionsGranted());
  }
}
