import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photon/pages/home_page.dart';
import 'firebase_options.dart';

import 'pages/login_page.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const Photon(), // Wrap your app
    ),
  );
}

class Photon extends StatefulWidget {
  const Photon({super.key});

  @override
  State<StatefulWidget> createState() => _PhotonState();
}

class _PhotonState extends State {
  late bool validUser = false;
  late Future<void> loginFuture;

  @override
  void initState() {
    super.initState();
    loginFuture = _login();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loginFuture,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: snapshot.hasError
                ? const Scaffold(
                    body: Center(
                        child: Text(
                            "Some error occurred, please try again later",
                            style: TextStyle(fontSize: 20))))
                : snapshot.connectionState == ConnectionState.done
                    ? validUser
                        ? const HomePage()
                        : const LoginPage()
                    : const Center(
                        child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(),
                      )),
            themeMode: ThemeMode.system,
          );
        });
  }

  Future<void> _login() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await Future.delayed(const Duration(seconds: 2));
    validUser = false;
  }
}
