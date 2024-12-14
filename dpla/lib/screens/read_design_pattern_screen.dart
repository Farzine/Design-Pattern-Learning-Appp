// lib/screens/read_design_pattern_screen.dart
import 'package:flutter/material.dart';
import 'package:dpla/models/design_pattern.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/highlight.dart' show highlight;
import 'package:highlight/languages/java.dart';
import 'package:flutter/services.dart';

class ReadDesignPatternScreen extends StatefulWidget {
  final DesignPattern pattern;

  const ReadDesignPatternScreen({Key? key, required this.pattern}) : super(key: key);

  @override
  _ReadDesignPatternScreenState createState() => _ReadDesignPatternScreenState();
}

class _ReadDesignPatternScreenState extends State<ReadDesignPatternScreen>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _youtubeController;
  late CodeController _codeController;
  late AnimationController _animationController;

  // Simulated output from "running" the code
  String _codeOutput = '';

  @override
  void initState() {
    super.initState();

    // Animation controller for hover effects
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Extract YouTube video ID from URL
    final videoId = YoutubePlayer.convertUrlToId(widget.pattern.videoUrl) ?? '';
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: false,
      ),
    );

    // Initialize code controller with the first example (if available)
    final initialCode = widget.pattern.examples.isNotEmpty
        ? widget.pattern.examples.first.code
        : '// No example code available.\n';

    // Initialize the controller without `theme`:
_codeController = CodeController(
  text: initialCode,
  language: java,
);

// When building the widget:
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Colors.purple.shade400,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.purple.withOpacity(_animationController.value * 0.2),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  padding: const EdgeInsets.all(16.0),
  child: CodeTheme(
    data: CodeThemeData(
      styles: {
        'root': TextStyle(
          color: Colors.black87,
          fontFamily: 'SourceCodePro',
          fontSize: 14,
        ),
        // Add more highlight styles if needed
      },
    ),
    child: CodeField(
      controller: _codeController,
      textStyle: const TextStyle(fontFamily: 'SourceCodePro', fontSize: 14),
      lineNumberStyle: const LineNumberStyle(
        width: 40,
        textAlign: TextAlign.right,
        textStyle: TextStyle(color: Colors.grey),
      ),
      expands: false,
      wrap: true,
      minLines: 10,
      maxLines: 20,
    ),
  ),
);
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _codeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Function to run the code (Placeholder)
  void _runCode() {
    // Simulate code execution by showing some mock output
    setState(() {
      _codeOutput = 'Code executed successfully.\nOutput:\nHello, Singleton!';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code run simulated!')),
    );
  }

  /// Copy code to clipboard
  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _codeController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final codeSectionElevation = 2.0 + (4.0 * _animationController.value);

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.redAccent,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: Text(
              widget.pattern.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 4,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // YouTube Video Section
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: player,
                ),
                const SizedBox(height: 16),

                // Description Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.pattern.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Code Editor Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Example Code',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade400,
                          ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _copyCode,
                          tooltip: 'Copy code',
                          icon: const Icon(Icons.copy, color: Colors.grey),
                        ),
                        IconButton(
                          onPressed: _runCode,
                          tooltip: 'Run code',
                          icon: const Icon(Icons.play_arrow, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),

                MouseRegion(
                  onEnter: (_) => _animationController.forward(),
                  onExit: (_) => _animationController.reverse(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.purple.shade400,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.purple.withOpacity(_animationController.value * 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: CodeField(
                      controller: _codeController,
                      textStyle: const TextStyle(fontFamily: 'SourceCodePro', fontSize: 14),
                      lineNumberStyle: const LineNumberStyle(
                        width: 40,
                        textAlign: TextAlign.right,
                        textStyle: TextStyle(color: Colors.grey),
                      ),
                      expands: false,
                      wrap: true,
                      minLines: 10,
                      maxLines: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),

                // Output Section
                if (_codeOutput.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      _codeOutput,
                      style: const TextStyle(
                        fontFamily: 'SourceCodePro',
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
