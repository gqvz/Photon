import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("data"),);
  }
  
}