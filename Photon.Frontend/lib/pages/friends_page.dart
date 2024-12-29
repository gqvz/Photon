import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class FriendData {
  final String name;
  final String imageUrl;
  final DateTime addedTime;

  FriendData(this.name, this.imageUrl, this.addedTime);
}

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<StatefulWidget> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late bool inSession = true;
  late List<FriendData> friends;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: () async {
      // Simulate loading data
      await Future.delayed(const Duration(seconds: 2));

      // Simulate error
      // throw Exception("Failed to load friends");

      // Simulate data
      friends = [
        FriendData(
            "Alice",
            "https://picsum.photos/200/200",
            DateTime.now().subtract(const Duration(days: 4))),
        FriendData(
            "Alice",
            "https://picsum.photos/200/200",
            DateTime.now().subtract(const Duration(days: 369))),
        FriendData(
            "Bob",
            "https://picsum.photos/200/200",
            DateTime.now().subtract(const Duration(days: 942))),
        FriendData(
            "Charlie",
            "https://picsum.photos/200/200",
            DateTime.now().subtract(const Duration(days: 8))),
        FriendData(
            "David",
            "https://picsum.photos/200/200",
            DateTime.now().subtract(const Duration(days: 36))),
        FriendData(
            "Eve",
            "https://picsum.photos/200/200",
            DateTime.now().subtract(const Duration(days: 65))),
      ];
      return null;
    }(), builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(
            child: Text(
          "Error getting friends",
          style: TextStyle(fontSize: 20),
        ));
      }

      // Once complete, show your application
      if (snapshot.connectionState == ConnectionState.done &&
          friends.isNotEmpty) {
        return ListView.builder(
            padding: const EdgeInsets.only(left: 8, right: 8),
            itemCount: friends.length, // Replace with dynamic participant count
            itemBuilder: (context, index) {
              // Get screen size using MediaQuery
              final screenWidth = MediaQuery.of(context).size.width;
              final screenHeight = MediaQuery.of(context).size.height;

              // Calculate dynamic sizes
              final cardWidth = screenWidth * 0.9; // 90% of screen width
              final cardHeight = screenHeight * 0.1; // 10% of screen height
              final textSize =
                  screenWidth * 0.04; // Text size based on screen width
              final iconSize =
                  screenWidth * 0.08; // Icon size based on screen width
              final buttonPadding = screenWidth * 0.005; // Button padding
              final friend = friends[index];
              return Container(
                width: cardWidth,
                height: cardHeight,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(32.0), // Apply globally
                          ),
                        )),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                          child: ClipOval(
                              child: Image(
                            image: NetworkImage(friend.imageUrl),
                            width: cardHeight * 0.5,
                            height: cardHeight * 0.5,
                          )),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // Center vertically
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Align left
                            children: [
                              Text(
                                friend.name,
                                style: TextStyle(
                                    fontSize: textSize,
                                    overflow: TextOverflow
                                        .ellipsis), // Dynamic text size
                              ),
                              Text(
                                "Added ${timeago.format(friend.addedTime)}",
                                style: TextStyle(
                                    fontSize:
                                        textSize * 0.8), // Dynamic text size
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            inSession
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(right: buttonPadding),
                                    child: IconButton(
                                      icon: FaIcon(FontAwesomeIcons.plus,
                                          size: iconSize *
                                              0.9), // Dynamic icon size
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      onPressed: () {
                                        // Call button action
                                      },
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.only(left: buttonPadding),
                              child: IconButton(
                                icon: FaIcon(FontAwesomeIcons.ban,
                                    size: iconSize * 0.9), // Dynamic icon size
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                onPressed: () {
                                  // Message button action
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              );
            },
          );
      } else if (snapshot.connectionState == ConnectionState.done &&
          friends.isEmpty) {
        return const Center(
            child: Text(
          "No friends ☹️",
          style: TextStyle(fontSize: 20),
        ));
      }

      // Otherwise, show something whilst waiting for initialization to complete
      return const Center(
          child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(),
      ));
    });
  }
}
