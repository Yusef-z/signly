import 'package:signly/screens/text_to_sign_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'video_player_widget.dart';

class NetworkPlayerWidget extends StatefulWidget {
  late VideoPlayerController controller;
  Key key;
  NetworkPlayerWidget({required this.controller, required this.key});

  @override
  _NetworkPlayerWidgetState createState() => _NetworkPlayerWidgetState();
}

class _NetworkPlayerWidgetState extends State<NetworkPlayerWidget> {
  late VideoPlayerController controller = widget.controller;
  @override
  void initState() {
    super.initState();
    controller.setLooping(true);
    controller
      ..addListener(() {})
      ..initialize().then((_) {
        setState(() {
          controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerWidget(controller: controller);
  }
}
