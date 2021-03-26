import 'dart:async';

import 'package:example/utils/mock_data.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

import 'providerim.dart';

class DefaultPlayer extends StatefulWidget {
  DefaultPlayer({Key key}) : super(key: key);

  @override
  _DefaultPlayerState createState() => _DefaultPlayerState();
}

class _DefaultPlayerState extends State<DefaultPlayer> {
  FlickManager flickManager;
  int a = 0;

  final StreamController<int> _streamController =StreamController<int>();
  int positionI=0;

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    a = flickManager
        .flickVideoManager.videoPlayerController.value.position.inSeconds;
    print("***setState" +
        flickManager.flickVideoManager.videoPlayerValue.position.inSeconds
            .toString());
  }

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.network(mockData["items"][0]["trailer_url"]),
    );
    print("***initState" +
        flickManager.flickVideoManager.videoPlayerValue.position.inSeconds
            .toString());
  }

  @override
  void dispose() {
    flickManager.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager.autoPause();
          print("***if" +
              flickManager
                  .flickVideoManager.videoPlayerValue.position.inSeconds
                  .toString());
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager.autoResume();
          print("***elseif" +
              flickManager
                  .flickVideoManager.videoPlayerValue.position.inSeconds
                  .toString());
        }
      },
      child: Column(
        children: [
          Container(
            child: FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: FlickVideoWithControls(
                controls: FlickPortraitControls(),
              ),
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                controls: FlickLandscapeControls(),
              ),
            ),
          ),
          Card(
            color: Theme.of(context).backgroundColor,
            child: Container(
              width: MediaQuery.of(context).size.height * 0.3,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [Text("Video saniyesi"+flickManager.flickVideoManager.videoPlayerValue.position.inMilliseconds.toString()),
                  Text(flickManager.flickVideoManager.videoPlayerValue.position.inSeconds.toString()),



                ],
              ),
            ),
          )
        ],
      ),
    );
  }


}