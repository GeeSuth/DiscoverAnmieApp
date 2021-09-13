import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class OpenVideo extends StatefulWidget {
  const OpenVideo({Key key, this.videoPath}) : super(key: key);

  final String videoPath;

  @override
  _OpenVideoState createState() => _OpenVideoState(videoPath);
}

class _OpenVideoState extends State<OpenVideo> {
  _OpenVideoState(this.path);

  final String path;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      path,
    );

    print('video Path ' + path);
    _initializeVideoPlayerFuture =
        _controller.initialize().then((value) => _controller.play());

    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Video'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(
                _controller,
              ),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
