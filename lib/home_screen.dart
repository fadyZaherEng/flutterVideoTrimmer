import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_video_trimmer_test/video_trimmer_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? selectedVideo;
  VideoPlayerController? videoPlayerController;
  final int _maxVideoDuration = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Video Trimmer"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("LOAD VIDEO FROM GALLERY"),
          onPressed: () async {
            await _getVideo(ImageSource.gallery);
          },
        ),
      ),
    );
  }

  Future<void> _getVideo(
    ImageSource img,
  ) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
        source: img,
        maxDuration: Duration(
          seconds: _maxVideoDuration,
        ));
    XFile? videoFile = pickedFile;
    if (videoFile == null) {
      return;
    }
    setState(() {
      selectedVideo = File(videoFile.path);
    });
  }

  void _onAddVideoState({
    required File video,
    required ImageSource imageSource,
  }) {
    selectedVideo = video;
    videoPlayerController = VideoPlayerController.file(
      selectedVideo!,
    )..initialize().then(
        (_) {
          if (videoPlayerController!.value.duration.inSeconds >
              _maxVideoDuration) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoTrimmerScreen(
                    file: selectedVideo!,
                    maxDuration: _maxVideoDuration,
                  ),
                ));
            selectedVideo = null;
            videoPlayerController = null;
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Video is too short"),
                content: const Text("Please choose another video"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
        },
      );
  }
}
