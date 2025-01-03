import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photon/presentation/bloc/permissions/permissions_cubit.dart';
import 'package:photon/presentation/pages/login_page/login_page.dart';
import 'package:photon/presentation/pages/permissions_page/permissions_page.dart';
import 'package:photon/presentation/pages/splash_page/splash_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => PermissionsCubit()..requestPermissions(),
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return BlocListener<PermissionsCubit, PermissionsState>(
          listener: (context, state) {
            switch (state) {
              case PermissionsInitial():
                _navigator.pushAndRemoveUntil(
                  SplashPage.route(),
                  (route) => false,
                );
                break;
              case PermissionsGranted():
                _navigator.pushAndRemoveUntil(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              case PermissionsDenied():
                _navigator.pushAndRemoveUntil(
                  PermissionsPage.route(),
                  (route) => false,
                );
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
