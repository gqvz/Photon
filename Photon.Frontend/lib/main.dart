import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:photon/generated/google/protobuf/empty.pb.dart';
import 'package:photon/pages/login_page.dart';
import 'package:photon/services.dart';
import 'package:photon/pages/home_page.dart';
import 'package:photon/permission_checker.dart';
import 'package:photon/background_handler.dart';
import 'package:photon/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeService();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const Photon(),
    ),
  );
}


class Photon extends StatefulWidget {
  const Photon({super.key});
  @override
  State<StatefulWidget> createState() => _PhotonState();
}

class _PhotonState extends State<Photon> {
  late bool validUser = false;
  bool _permissionsInitialized = false;

  bool login = false;

  @override
  void initState() {
    super.initState();
    _initCredentialManager();
    _login();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      home: !_permissionsInitialized
          ? _PermissionHandler(
              onPermissionsGranted: () {
                setState(() => _permissionsInitialized = true);
              },
            )
          : login
              ? validUser
                  ? const HomePage()
                  : const LoginPage()
              : const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
    );
  }

  Future<void> _initCredentialManager() async {
    if (Services.credentialManager.isSupportedPlatform) {
      await Services.credentialManager.init(
        preferImmediatelyAvailableCredentials: true,
        googleClientId:
            '1068595745672-1n9ekup81lgkrtjrve9tr05o8bogedhc.apps.googleusercontent.com',
      );
    }
  }

  Future<void> _login() async {
    // get a cookie from the credential manager
    const storage = FlutterSecureStorage();
    var cookie = await storage.read(key: 'cookie');
    if (cookie == null) {
      setState(() {
        validUser = false;
        login = true;
      });
      return;
    }
    try {
      Services.cookie = cookie;
      var resp = await Services.usersClient.me(Empty());
      Services.user = resp;
      setState(() {
        validUser = true;
        login = true;
      });
    } catch (e) {
      setState(() {
        validUser = false;
        login = true;
      });
    }
  }
}

class _PermissionHandler extends StatefulWidget {
  final VoidCallback onPermissionsGranted;

  const _PermissionHandler({required this.onPermissionsGranted});

  @override
  State<_PermissionHandler> createState() => _PermissionHandlerState();
}

// Update _PermissionHandlerState
class _PermissionHandlerState extends State<_PermissionHandler> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      final result = await PermissionChecker.checkAndRequestPermissions();
      if (!result['granted']) {
        if (mounted) {
          String message;
          String title;

          switch (result['permissionType']) {
            case "android.permission.POST_NOTIFICATIONS":
              title = "Notification";
              message =
                  "App notifications are required to keep you updated with important information.";
              break;
            case "android.permission.MANAGE_EXTERNAL_STORAGE":
            case "android.permission.READ_EXTERNAL_STORAGE":
              title = "Storage Access";
              message =
                  "This app requires full access to all photos and videos to function properly.";
              break;
            default:
              title = "Permissions Required";
              message =
                  "Additional permissions are required for the app to function properly.";
          }

          await _showPermissionDialog(title, message);
          return;
        }
      }

      if (mounted) {
        widget.onPermissionsGranted();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _showPermissionDialog(String title, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await PermissionChecker.openSettings();
              _checkPermissions(); // Retry after settings
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
