import 'package:signly/screens/text_to_sign_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'video_player_widget.dart';
import 'package:provider/provider.dart';
import 'package:signly/providers/counter_provider.dart';

class VideoListPlayerWidget extends StatefulWidget {
  // late String video_path;
  late Key key;
  late List<String> video_paths;
  // late VideoPlayerController controller;
  VideoListPlayerWidget({required this.key, required this.video_paths}) {
    // controller = VideoPlayerController.network(video_path);
  }

  @override
  _VideoListPlayerWidgetState createState() => _VideoListPlayerWidgetState();
}

class _VideoListPlayerWidgetState extends State<VideoListPlayerWidget> {
  VideoPlayerController controller = VideoPlayerController.network("");
  void initAndPlay(String video_path) {
    setState(() {
      controller = VideoPlayerController.network(video_path);
    });

    controller
      ..addListener(() async {
        if (controller.value.position == controller.value.duration) {
          print("video finished");
          if (Provider.of<TranslationProvider>(context, listen: false).counter <
                  widget.video_paths.length &&
              mounted) {
            print("inside not playing");
            if (Provider.of<TranslationProvider>(context, listen: false)
                    .counter !=
                widget.video_paths.length) {
              controller.removeListener(() {});
              controller.dispose();

              initAndPlay(widget.video_paths[
                  Provider.of<TranslationProvider>(context, listen: false)
                      .counter]);

              Provider.of<TranslationProvider>(context, listen: false)
                  .increment();
            }
            if (Provider.of<TranslationProvider>(context, listen: false)
                    .counter ==
                widget.video_paths.length) {
              Provider.of<TranslationProvider>(context, listen: false)
                  .toggleTranslation();
              print("Translation status: " +
                  Provider.of<TranslationProvider>(context)
                      .isTranslating
                      .toString());
            }
            print(Provider.of<TranslationProvider>(context, listen: false)
                .counter);
          }
        }
      })
      ..initialize().then((_) {
        setState(() {
          controller.play();
          print("playing");
        });
      }).catchError((error) {
        print("");
      });
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print("init called");
    super.initState();
    if (Provider.of<TranslationProvider>(context, listen: false).counter !=
        widget.video_paths.length) {
      initAndPlay(widget.video_paths[
          Provider.of<TranslationProvider>(context, listen: false).counter]);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("inside video build");
    return VideoPlayerWidget(controller: controller);
  }
}
