import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DesignPatternVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const DesignPatternVideoPlayer({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  State<DesignPatternVideoPlayer> createState() =>
      _DesignPatternVideoPlayerState();
}

class _DesignPatternVideoPlayerState extends State<DesignPatternVideoPlayer> {
  late YoutubePlayerController _controller;
  String _videoTitle = '';
  String _videoAuthor = '';

  @override
  void initState() {
    super.initState();

    // Extract video ID from the URL
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';

    // Initialize the controller
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        // If true, the default controls are hidden,
        // but we want them visible for a YouTube-like experience:
        hideControls: false,
        enableCaption: true,
        controlsVisibleAtStart: true,
      ),
    )..addListener(_onPlayerStateChange);
  }

  void _onPlayerStateChange() {
    // Update the title & author from metadata once it's available
    if (_controller.metadata.title.isNotEmpty &&
        _videoTitle != _controller.metadata.title) {
      setState(() {
        _videoTitle = _controller.metadata.title;
        _videoAuthor = _controller.metadata.author;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerStateChange);
    _controller.dispose();
    super.dispose();
  }

  /// Overlay at the top with video title/author
  Widget _buildVideoTitleOverlay() {
    // If you prefer a cleaner UI (just like the YouTube app),
    // you could remove this overlay or show/hide it on tap.
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        _videoTitle.isNotEmpty
            ? '$_videoTitle by $_videoAuthor'
            : 'Loading video details...',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.redAccent,
            progressColors: const ProgressBarColors(
              playedColor: Colors.redAccent,
              handleColor: Colors.red,
            ),
            // A near-official YouTube bottom bar:
            bottomActions: [
              // A little horizontal space
              const SizedBox(width: 8),

              const SizedBox(width: 8),

              // Current Position Text
              CurrentPosition(),
              const SizedBox(width: 8),

              // Progress bar that expands
              ProgressBar(isExpanded: true),

              // Remaining Duration
              RemainingDuration(),

              // Playback Speed
              const PlaybackSpeedButton(),

              // Full screen button
              FullScreenButton(),
            ],
            onReady: () {
              // Called when the controller is ready.
              // Optionally do something here.
            },
          ),
          // Optional title overlay at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildVideoTitleOverlay(),
          ),
        ],
      ),
    );
  }
}
