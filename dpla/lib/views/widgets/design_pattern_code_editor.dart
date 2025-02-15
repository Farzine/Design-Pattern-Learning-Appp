import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';
import 'package:flutter/services.dart';

class DesignPatternCodeEditor extends StatefulWidget {
  final String initialCode;
  final void Function(String) onRun;
  final String runOutput;
  final String language;

  const DesignPatternCodeEditor({
    Key? key,
    required this.initialCode,
    required this.onRun,
    required this.runOutput,
    this.language = 'java', // Default language is Java
  }) : super(key: key);

  @override
  _DesignPatternCodeEditorState createState() =>
      _DesignPatternCodeEditorState();
}

class _DesignPatternCodeEditorState extends State<DesignPatternCodeEditor>
    with SingleTickerProviderStateMixin {
  late CodeController _codeController;
  late AnimationController _hoverAnimation;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _hoverAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _codeController = CodeController(
      text: widget.initialCode,
      language: widget.language == 'java' ? java : python, // Switch languages
    );
  }

  @override
  void dispose() {
    _hoverAnimation.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _codeController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code copied to clipboard!')),
    );
  }

  Future<void> _runCode() async {
    setState(() {
      _isRunning = true;
    });

    // Mock the backend interaction and output
    await Future.delayed(const Duration(seconds: 2));

    // Simulate output (in a real scenario, you'd call the backend here)
    String simulatedOutput = 'Code executed successfully!\nOutput: ${_codeController.text}';

    setState(() {
      _isRunning = false;
    });

    // Return the simulated output
    widget.onRun(simulatedOutput);
  }

  void _resetCode() {
    setState(() {
      _codeController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and action buttons
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
                IconButton(
                  onPressed: _resetCode,
                  tooltip: 'Reset code',
                  icon: const Icon(Icons.refresh, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // The CodeField with hover effect
        MouseRegion(
          onEnter: (_) => _hoverAnimation.forward(),
          onExit: (_) => _hoverAnimation.reverse(),
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
                  color: Colors.purple.withOpacity(_hoverAnimation.value * 0.2),
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

        // Output Section
        const SizedBox(height: 16),
        if (_isRunning)
          const Center(child: CircularProgressIndicator())
        else if (widget.runOutput.isNotEmpty)
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
              widget.runOutput,
              style: const TextStyle(
                fontFamily: 'SourceCodePro',
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
