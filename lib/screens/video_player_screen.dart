import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_hub/controller/user/video_download_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final VideoDownloadController _videoController =
      Get.put(VideoDownloadController());

  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showControls = true;
      } else {
        _controller.play();
        _showControls = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _isInitialized
            ? GestureDetector(
                onTap: _togglePlayPause,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    if (_showControls)
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 30,
                          child: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    // ⬇️ Positioned Download Button

                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Obx(() {
                        final isDownloading =
                            _videoController.isDownloading(widget.videoUrl);
                        return FloatingActionButton(
                          backgroundColor: Colors.black87,
                          onPressed: isDownloading.value
                              ? null
                              : () => _videoController
                                  .downloadVideo(widget.videoUrl),
                          child: Obx(() {
                            return isDownloading.value
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.green),
                                    ),
                                  )
                                : const Icon(Icons.download,
                                    color: Colors.white);
                          }),
                        );
                      }),
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
