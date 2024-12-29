import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photon/generated/Avatar.pb.dart';
import 'package:photon/services.dart';

Map<String, Image> avatars = {};

class CachedAvatar extends StatefulWidget {
  final String id;

  const CachedAvatar({super.key, required this.id});

  @override
  State<CachedAvatar> createState() => _CachedAvatarState();
}

class _CachedAvatarState extends State<CachedAvatar> {
  late Future<Image> future;

  @override
  void didUpdateWidget(CachedAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id || !avatars.containsKey(widget.id)) {
      // Re-fetch the avatar if the ID changes or it's no longer cached
      _fetchImage();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }

  void _fetchImage() {
    future = avatars.containsKey(widget.id)
        ? Future.value(avatars[widget.id])
        : _getImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const FaIcon(FontAwesomeIcons.circleUser);
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ClipOval(child: snapshot.data);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<Image> _getImage() async {
    var id = widget.id;
    var stream = Services.avatarsClient.get(GetAvatarRequest(id: id));
    var completer = Completer<Image>();
    var data = <int>[];
    stream.listen((event) {
      data.addAll(event.data);
    }, onDone: () {
      var image = Image.memory(Uint8List.fromList(data), fit: BoxFit.fill);
      avatars[id] = image;
      completer.complete(image);
    }, onError: (error) {
      completer.completeError(error);
    });
    return completer.future;
  }
}
