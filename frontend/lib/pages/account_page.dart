import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photon/main.dart';
import 'package:photon/pages/friends_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late String inputFieldText = "";

  late List<FriendData> friendRequests;
  late Future<void> _friendRequestsFuture;

  @override
  void initState() {
    super.initState();
    _friendRequestsFuture = _getFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensures keyboard doesn't overlap content
      body: GestureDetector(
        onTap: () => FocusScope.of(context)
            .unfocus(), // Dismiss the keyboard when tapping outside
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Align to start for better readability
              children: <Widget>[
                // Profile Section
                Center(
                  child: ClipOval(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.network(
                        "https://avatars.githubusercontent.com/u/70444445?s=1024&v=4",
                        fit: BoxFit.cover, // Maintain aspect ratio and fill
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Garvit Sharmaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                    style: TextStyle(fontSize: 35),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Share.share("Add me on Photon!\nhttps://photon.garvit.tech/frienddl/adjw2j");
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text("Friend code: adjw2j",
                            style: TextStyle(fontSize: 20)),
                        Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: FaIcon(
                              FontAwesomeIcons.link,
                              size: 20,
                            )),
                      ])),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Photon()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      inputFieldText = value;
                    });
                  },
                  maxLength: 6,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Friend Code",
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: inputFieldText.length < 6
                        ? null
                        : () {
                            setState(() {
                              // TODO: Implement session code logic
                            });
                          },
                    child: const Text(
                      "Add friend",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Friend Requests",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 10),

                // Friend Requests Section
                FutureBuilder(
                  future: _friendRequestsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "Error getting friend requests",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.done &&
                        friendRequests.isNotEmpty) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final screenHeight = MediaQuery.of(context).size.height;

                      return ListView.builder(
                        shrinkWrap:
                            true, // Allows embedding in a scrollable view
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(left: 1, right: 1),
                        itemCount: friendRequests.length,
                        itemBuilder: (context, index) {
                          final cardWidth = screenWidth * 0.9; // Dynamic width
                          final cardHeight =
                              screenHeight * 0.1; // Dynamic height
                          final textSize =
                              screenWidth * 0.04; // Dynamic text size
                          final iconSize =
                              screenWidth * 0.08; // Dynamic icon size
                          final buttonPadding =
                              screenWidth * 0.005; // Button padding
                          final friendRequest = friendRequests[index];

                          return Container(
                            width: cardWidth,
                            height: cardHeight,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipOval(
                                      child: Image.network(
                                        friendRequest.imageUrl,
                                        width: cardHeight * 0.5,
                                        height: cardHeight * 0.5,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          friendRequest.name,
                                          style: TextStyle(
                                            fontSize: textSize,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          "Sent ${timeago.format(friendRequest.addedTime)}",
                                          style: TextStyle(
                                              fontSize: textSize * 0.8),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: buttonPadding),
                                        child: IconButton(
                                          icon: FaIcon(
                                            FontAwesomeIcons.check,
                                            size: iconSize * 0.9,
                                          ),
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          onPressed: () {
                                            // Accept friend request
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: buttonPadding),
                                        child: IconButton(
                                          icon: FaIcon(
                                            FontAwesomeIcons.ban,
                                            size: iconSize * 0.9,
                                          ),
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                          onPressed: () {
                                            // Reject friend request
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
                        friendRequests.isEmpty) {
                      return const Center(
                        child: Text(
                          "No friend requests ☹️",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    } else {
                      return const Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getFriendRequests() async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate error
    // throw Exception("Failed to load friends");

    // Simulate data
    friendRequests = [
      FriendData(
          "Alice",
          "https://avatars.githubusercontent.com/u/70444445?s=1024&v=4",
          DateTime.now().subtract(const Duration(days: 4))),
      FriendData(
          "Alice",
          "https://avatars.githubusercontent.com/u/70444445?s=1024&v=4",
          DateTime.now().subtract(const Duration(days: 369))),
      FriendData(
          "Bob",
          "https://avatars.githubusercontent.com/u/70444445?s=1024&v=4",
          DateTime.now().subtract(const Duration(days: 942))),
      FriendData(
          "Charlie",
          "https://avatars.githubusercontent.com/u/70444445?s=1024&v=4",
          DateTime.now().subtract(const Duration(days: 8))),
      FriendData(
          "David",
          "https://avatars.githubusercontent.com/u/70444445?s=1024&v=4",
          DateTime.now().subtract(const Duration(days: 36))),
      FriendData(
          "Eve",
          "https://avatars.githubusercontent.com/u/70444445?s=1024&v=4",
          DateTime.now().subtract(const Duration(days: 65))),
    ];
  }
}
