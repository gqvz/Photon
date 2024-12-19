import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photon/pages/account_page.dart';
import 'package:photon/pages/friends_page.dart';
import 'package:photon/pages/images_page.dart';
import 'package:photon/pages/session_page.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: PopScope(
          canPop: false,
          child: Scaffold(
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              selectedIndex: currentPageIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.connectdevelop),
                  label: 'Sessions',
                ),
                NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.image),
                  label: 'Images',
                ),
                NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.userGroup),
                  label: 'Friends',
                ),
                NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.circleUser),
                  label: 'Account',
                ),
              ],
            ),
            body: SafeArea(child: <Widget>[
              const SessionPage(),
              const ImagesPage(),
              const FriendsPage(),
              const AccountPage()
            ][currentPageIndex]),
          ),
        ));
  }
}
