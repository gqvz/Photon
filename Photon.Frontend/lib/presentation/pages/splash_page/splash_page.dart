import 'package:flutter/material.dart';
import 'package:photon/presentation/pages/splash_page/widgets/logo_loading.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  
  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LogoLoading()
    );
  }
  
}