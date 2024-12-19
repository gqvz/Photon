import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photon/pages/friends_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  late String sessionName = "real trip";
  late String sessionCode = "12364";
  late String inputFieldText = "";
  
  late List<FriendData> participantsOrInvites;
  late Future<void> participantsFuture;
  
  @override
  void initState() {
    super.initState();
    participantsFuture = _getParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensures UI doesn't get compressed when keyboard appears
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Fixed Top Section
            Column(
              children: [
                Text(
                  sessionCode.isEmpty ? "Create or Join" : sessionName,
                  style: const TextStyle(fontSize: 45),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                sessionCode.isEmpty
                    ? TextField(
                        onChanged: (value) {
                          setState(() {
                            inputFieldText = value;
                          });
                        },
                        enabled: sessionCode.isEmpty,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Session Code",
                        ),
                      )
                    : SizedBox(
                        child: TextButton(
                          onPressed: () {
                            Share.share(
                                'Join my Photon session\nhttps://photon.garvit.tech/join/$sessionCode');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(sessionCode,
                                  style: const TextStyle(fontSize: 40)),
                            const Padding(padding: EdgeInsets.only(left: 16), child: FaIcon(FontAwesomeIcons.link, size: 40,))
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isButtonDisabled()
                        ? null
                        : () {
                            setState(() {
                              // TODO: Implement session code logic
                            });
                          },
                    child: Text(
                      getButtonText(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(sessionCode.isEmpty ? "Invites" : "Participants", style: const TextStyle(fontSize: 30)),
              ],
            ),

            const SizedBox(height: 10),

            // Scrollable List of Participants
            FutureBuilder(
              future: participantsFuture,
              builder: (context, snapshot) {
                return snapshot.hasError
                    ? const Center(
                    child: Text(
                      "Error getting friend requests",
                      style: TextStyle(fontSize: 20),
                    ))
                    : snapshot.connectionState == ConnectionState.done && participantsOrInvites.isNotEmpty
                    ? Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 1, right: 1),
                    itemCount: participantsOrInvites.length, // Replace with dynamic participant count
                    itemBuilder: (context, index) {
                      // Get screen size using MediaQuery
                      final screenWidth =
                          MediaQuery.of(context).size.width;
                      final screenHeight =
                          MediaQuery.of(context).size.height;

                      // Calculate dynamic sizes
                      final cardWidth =
                          screenWidth * 0.9; // 90% of screen width
                      final cardHeight =
                          screenHeight * 0.1; // 10% of screen height
                      final textSize = screenWidth *
                          0.04; // Text size based on screen width
                      final iconSize = screenWidth *
                          0.08; // Icon size based on screen width
                      final buttonPadding =
                          screenWidth * 0.005; // Button padding
                      final participant = participantsOrInvites[index];

                      return Container(
                        width: cardWidth,
                        height: cardHeight,
                        margin:
                        const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                WidgetStatePropertyAll(
                                    Theme.of(context)
                                        .brightness ==
                                        Brightness.dark
                                        ? Colors.white
                                        : Colors.black),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        32.0), // Apply globally
                                  ),
                                )),
                            onPressed: () {},
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 8.0, 8.0, 8.0),
                                  child: ClipOval(
                                      child: Image(
                                        image: NetworkImage(
                                            participant.imageUrl),
                                        width: cardHeight * 0.5,
                                        height: cardHeight * 0.5,
                                      )
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Center vertically
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start, // Align left
                                    children: [
                                      Text(
                                        participant.name,
                                        style: TextStyle(
                                            fontSize: textSize,
                                            overflow: TextOverflow
                                                .ellipsis), // Dynamic text size
                                      ),
                                      Text(
                                        "Sent ${timeago.format(participant.addedTime)}",
                                        style: TextStyle(
                                            fontSize: textSize *
                                                0.8), // Dynamic text size
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
                                            size: iconSize *
                                                0.9), // Dynamic icon size
                                        color: Theme.of(context)
                                            .brightness ==
                                            Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                        onPressed: () {
                                          // Call button action
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: buttonPadding),
                                      child: IconButton(
                                        icon: FaIcon(
                                            FontAwesomeIcons.ban,
                                            size: iconSize *
                                                0.9), // Dynamic icon size
                                        color: Theme.of(context)
                                            .brightness ==
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
                  ),
                )
                    : snapshot.connectionState == ConnectionState.done && participantsOrInvites.isEmpty ?  const Center(
                    child: Text(
                      "No invites ☹️",
                      style: TextStyle(fontSize: 20),
                    ))
                :const Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _isButtonDisabled() {
    return inputFieldText.length < 6 && inputFieldText.isNotEmpty;
  }

  String getButtonText() {
    if (sessionCode.isEmpty) {
      return inputFieldText.length < 6 ? "Create Session" : "Join Session";
    } else {
      return "Leave Session";
    }
  }

  Future<void> _getParticipants() async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate error
    // throw Exception("Failed to load friends");

    // Simulate data
    participantsOrInvites = [
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
