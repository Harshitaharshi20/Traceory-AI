import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import '../widgets/trajectory_canvas.dart';
import '../widgets/scene_overlay.dart';
import '../services/firestore_service.dart';

class StreamsScreen extends StatefulWidget {
  const StreamsScreen({super.key});

  @override
  State<StreamsScreen> createState() => _StreamsScreenState();
}

class _StreamsScreenState extends State<StreamsScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isLiveMode = firestoreService.isLiveMode;
  late StreamSubscription _modeSub;

  @override
  void initState() {
    super.initState();
    _modeSub = firestoreService.modeStream.listen((isLive) {
      if (mounted) setState(() => _isLiveMode = isLive);
    });

    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    )..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
          _isPlaying = true;
          _controller.setLooping(true);
        }
      }).catchError((e) {
        debugPrint("Video load error: $e");
      });
  }

  @override
  void dispose() {
    _modeSub.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Live Stream Monitoring', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Simulated Video Uploaded. AI processing...')));
                },
                icon: const Icon(Icons.upload),
                label: const Text('Upload New Stream'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          // AI Info Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _isLiveMode ? Colors.green.withOpacity(0.5) : Colors.orange.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: _isLiveMode ? Colors.green : Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      _isLiveMode ? 'AI Source: Gemini Vision' : 'AI Source: Simulated',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Detected Regions: ', style: TextStyle(color: Colors.grey)),
                    _buildRegionChip('Grass'),
                    const SizedBox(width: 8),
                    _buildRegionChip('Crowd'),
                    const SizedBox(width: 8),
                    _buildRegionChip('Jersey'),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _controller.value.isInitialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(_controller),
                          const SceneOverlay(),
                          const Positioned.fill(child: TrajectoryCanvas(sessionId: 'sess_1a2b3c4d')),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: IconButton(
                              icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, size: 64, color: Colors.white.withOpacity(0.8)),
                              onPressed: () {
                                setState(() {
                                  _isPlaying ? _controller.pause() : _controller.play();
                                  _isPlaying = !_isPlaying;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),
    );
  }
}
