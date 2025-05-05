import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_video_trimmer/config/theme/color_schemes.dart';
import 'package:flutter_video_trimmer/core/utils/duration_styles.dart';
import 'package:flutter_video_trimmer/flutter_video_trimmer.dart';
import 'package:flutter_video_trimmer/presentation/widgets/trim_viewer_widget.dart';
import 'package:flutter_video_trimmer/presentation/widgets/video_viewer_widget.dart';

class VideoTrimmerScreen extends StatefulWidget {
  final File file;
  final int maxDuration;

  const VideoTrimmerScreen({
    super.key,
    required this.file,
    required this.maxDuration,
  });

  @override
  State<VideoTrimmerScreen> createState() => _VideoTrimmerScreenState();
}

class _VideoTrimmerScreenState extends State<VideoTrimmerScreen> {
  final FlutterVideoTrimmer _trimmer = FlutterVideoTrimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;
   double _initialEndValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? value;

    await _trimmer
        .saveTrimmedVideo(
            startValue: _startValue,
            endValue: _endValue,
            onSave: (String? outputPath) {
              value = outputPath;
              Navigator.pop(context, value);
              debugPrint('OUTPUT PATH: $value');
              const snackBar =
                  SnackBar(content: Text('Video Saved successfully'));
              ScaffoldMessenger.of(context).showSnackBar(
                snackBar,
              );
            })
        .then((value) {
      setState(() {
        _progressVisibility = false;
      });
    });

    return value;
  }

  void _loadVideo() => _trimmer.loadVideo(videoFile: widget.file);

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(child: VideoViewer(trimmer: _trimmer)),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 100,
              child: TrimViewer(
                trimmer: _trimmer,
                viewerHeight: 60.0,
                showDuration: true,
                durationStyle: DurationStyle.FORMAT_HH_MM_SS,
                durationTextStyle: const TextStyle(color: Colors.black),
                viewerWidth: MediaQuery.of(context).size.width,
                onChangeStart: (value) {
                  _startValue = value;
                },
                onChangeEnd: (value) {
                  _endValue = value;
                  if (_initialEndValue == 0.0) {
                    _initialEndValue = value;
                  }
                },
                onChangePlaybackState: (value) =>
                    setState(() => _isPlaying = value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorSchemes.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text("CANCEL"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorSchemes.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text("SAVE"),
                      onPressed: () async {
                        if (!_progressVisibility) {
                          if (Duration(
                                      milliseconds:
                                          (_endValue - _startValue).toInt())
                                  .inSeconds >
                              widget.maxDuration) {
                            _showMessageDialog();
                          } else {
                            await _saveVideo();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showMessageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
            "${"Keep It Short And Sweet Videos Are Best At"} ${widget.maxDuration} ${"Seconds Or Less Thanks"}"),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
