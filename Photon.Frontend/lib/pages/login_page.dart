import 'package:credential_manager/credential_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photon/generated/Auth.pb.dart';
import 'package:photon/generated/google/protobuf/empty.pb.dart';
import 'package:photon/services.dart';
import 'package:photon/constants.dart';
import 'package:photon/pages/home_page.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool tryingLogin = false;

  Future<void> _launchUrl(String url) async {
    var theme = Theme.of(context);
    final Uri uri = Uri.parse(url);
    await launchUrl(
      uri,
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
        ),
        urlBarHidingEnabled: true,
        showTitle: true,
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcons.back,
        ),
      ),
    );
  }

  @override
  void initState() {
    var sub = Services.appLinks.uriLinkStream.listen((uri) async {
        setState(() {
        tryingLogin = true;
      });
      if (uri.queryParameters.containsKey("code")) {
        final code = uri.queryParameters["code"];
        if (uri.pathSegments.last == "discord") {
          await Services.authClient
              .login(LoginRequest(token: code, loginType: LoginType.DISCORD));
          var user = await Services.usersClient.me(Empty());
          Services.user = user;
          if (context.mounted) {
            setState(() {
              tryingLogin = false;
            });
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
            return;
          }
        } else if (uri.pathSegments.last == "github") {
          await Services.authClient
              .login(LoginRequest(token: code, loginType: LoginType.GITHUB));
          var user = await Services.usersClient.me(Empty());
          Services.user = user;
          if (context.mounted) {
            setState(() {
              tryingLogin = false;
            });
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
            return;
          }
        }
      }
        setState(() {
        tryingLogin = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
            body: tryingLogin
                ? const Center(child: CircularProgressIndicator())
                : Row(children: <Widget>[
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
                                        SignInButton(
                                            buttonType: MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.dark
                                                ? ButtonType.googleDark
                                                : ButtonType.google,
                                            onPressed: () async {
                                              try {
                                                final GoogleIdTokenCredential?
                                                    credential = await Services
                                                        .credentialManager
                                                        .saveGoogleCredential(
                                                            useButtonFlow:
                                                                false);
                                                setState(() {
                                                  tryingLogin = true;
                                                });
                                                var token = credential?.idToken;
                                                await Services.authClient.login(
                                                    LoginRequest(
                                                        token: token,
                                                        loginType:
                                                            LoginType.GOOGLE));
                                                var user = await Services
                                                    .usersClient
                                                    .me(Empty());
                                                Services.user = user;
                                                print(user);
                                              } catch (e) {
                                                // Handle the error
                                                setState(() {
                                                  tryingLogin = false;
                                                });
                                              }
                                              if (context.mounted) {
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomePage()));
                                              }
                                            }),
                                        SignInButton(
                                            buttonType: MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.dark
                                                ? ButtonType.githubDark
                                                : ButtonType.github,
                                            onPressed: () async {
                                              await _launchUrl(
                                                  "https://github.com/login/oauth/authorize?client_id=$githubClientId&redirect_uri=$githubRedirectUri&scope=user:email");
                                            }),
                                        SignInButton(
                                            buttonType: ButtonType.discord,
                                            onPressed: () async {
                                              await _launchUrl(
                                                  "https://discord.com/api/oauth2/authorize?client_id=$discordClientId&redirect_uri=$discordRedirectUri&response_type=code&scope=identify%20email");
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
                                    const Text("Made with ",
                                        style: TextStyle(fontSize: 20)),
                                    const FaIcon(FontAwesomeIcons.solidHeart,
                                        color: Colors.red, size: 20),
                                    const Text(" by CB",
                                        style: TextStyle(fontSize: 20)),
                                    IconButton(
                                      onPressed: () async {
                                        await _launchUrl(
                                            'https://github.com/phot-on');
                                      },
                                      icon: const FaIcon(
                                          FontAwesomeIcons.github,
                                          size: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    Expanded(flex: 2, child: Container()),
                  ])));
  }
}
