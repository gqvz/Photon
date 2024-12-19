import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photon/constants.dart';
import 'package:photon/pages/home_page.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: <Widget>[
      Expanded(flex: 2, child: Container()),
      Expanded(
          flex: 8,
          child: Column(
            children: <Widget>[
              Expanded(flex: 3, child: Container()),
              const Expanded(
                  flex: 12,
                  child: Image(
                      image: NetworkImage(
                          "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"))),
              Expanded(
                  flex: 12,
                  child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Column(
                        children: <Widget>[
                          SignInButton(buttonType: MediaQuery.of(context).platformBrightness == Brightness.dark ? ButtonType.googleDark : ButtonType.google, onPressed: () async {
                            final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);
                            print(notificationSettings.authorizationStatus);
                            final fcmToken = await FirebaseMessaging.instance.getToken();
                            print(fcmToken);
                            if (context.mounted) {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                            }
                          }),
                          SignInButton(buttonType: MediaQuery.of(context).platformBrightness == Brightness.dark ? ButtonType.githubDark : ButtonType.github, onPressed: () async {
                            await _launchUrl("$apiUrl/auth/github");
                          }),
                          SignInButton(buttonType: ButtonType.discord, onPressed: () async {
                            await _launchUrl("$apiUrl/auth/discord");
                          }),
                        ],
                      ))),
              Expanded(flex: 6, child: Container()),
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text("Made with ", style: TextStyle(fontSize: 20)),
                      const FaIcon(FontAwesomeIcons.solidHeart,
                          color: Colors.red, size: 20),
                      const Text(" by CB", style: TextStyle(fontSize: 20)),
                      IconButton(
                        onPressed: () async {
                          await _launchUrl('https://github.com/phot-on');
                        },
                        icon: const FaIcon(FontAwesomeIcons.github, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
      Expanded(flex: 2, child: Container()),
    ]));
  }
}
