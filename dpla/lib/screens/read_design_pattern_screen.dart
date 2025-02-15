import 'package:flutter/material.dart';
import 'package:dpla/models/design_pattern.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:dpla/widgets/design_pattern_video_player.dart';
import 'package:dpla/widgets/design_pattern_description.dart';
import 'package:dpla/widgets/design_pattern_code_editor.dart';

class ReadDesignPatternScreen extends StatefulWidget {
  final DesignPattern pattern;

  const ReadDesignPatternScreen({
    Key? key,
    required this.pattern,
  }) : super(key: key);

  @override
  _ReadDesignPatternScreenState createState() =>
      _ReadDesignPatternScreenState();
}

class _ReadDesignPatternScreenState extends State<ReadDesignPatternScreen> {
  String _codeOutput = '';

  /// Function to run the code (Placeholder)
  void _simulateRunCode(String code) {
    // You'd integrate real compilation or server-based run here.
    setState(() {
      _codeOutput = 'Code executed successfully.\nOutput:\nHello, Singleton!';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code run simulated!')),
    );
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    // Add a page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Text(widget.pattern.name,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.SizedBox(height: 16),
            pw.Text(widget.pattern.description,
                style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 24),
            pw.Text('Example Code',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text(
              // For demonstration we just use the first example code
              widget.pattern.examples.isNotEmpty
                  ? widget.pattern.examples.first.code
                  : '// No example code available',
              style: pw.TextStyle(
                fontSize: 12,
                font: pw.Font.courier(),
              ),
            ),
          ];
        },
      ),
    );

    // Use the printing plugin to share or save the PDF
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'pattern.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final initialCode = widget.pattern.examples.isNotEmpty
        ? widget.pattern.examples.first.code
        : '// No example code available.\n';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          widget.pattern.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.purple.shade100,
        actions: [
          IconButton(
            onPressed: _generatePdf,
            tooltip: 'Download as PDF',
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. YouTube Video
            DesignPatternVideoPlayer(videoUrl: widget.pattern.videoUrl),
            const SizedBox(height: 16),

            // 2. Description + Simple Annotation
            DesignPatternDescription(description: widget.pattern.description),
            const SizedBox(height: 24),

            // 3. Code Editor
            DesignPatternCodeEditor(
              initialCode: initialCode,
              runOutput: _codeOutput,
              onRun: _simulateRunCode,
            ),
          ],
        ),
      ),
    );
  }
}
