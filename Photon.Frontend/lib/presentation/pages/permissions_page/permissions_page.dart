import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/permissions/permissions_cubit.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});
  
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const PermissionsPage());
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Permissions"),
      content: Text("This app requires location, media and notification permissions to work properly.\n\nPlease allow the permissions to continue.\nNote: Please allow complete access to images and media files."),
      actions: [
        TextButton(
          onPressed: () {
            context.read<PermissionsCubit>().requestPermissions();
            Navigator.of(context).pop();
          },
          child: const Text("Allow"),
        ),
        TextButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: const Text("Deny"),
        ),
      ],
    );
  }  
}