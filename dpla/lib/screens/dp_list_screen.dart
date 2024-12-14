// lib/screens/dp_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/providers/design_pattern_provider.dart';
import 'package:dpla/models/design_pattern.dart';
import 'package:dpla/screens/read_design_pattern_screen.dart';

class DpListScreen extends ConsumerWidget {
  const DpListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designPatternState = ref.watch(designPatternProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Design Patterns',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: designPatternState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : designPatternState.error != null
                ? Center(child: Text(designPatternState.error!))
                : ListView.builder(
                    itemCount: designPatternState.patterns.length,
                    itemBuilder: (context, index) {
                      final pattern = designPatternState.patterns[index];
                      return DesignPatternCard(pattern: pattern);
                    },
                  ),
      ),
    );
  }
}

class DesignPatternCard extends StatefulWidget {
  final DesignPattern pattern;

  const DesignPatternCard({Key? key, required this.pattern}) : super(key: key);

  @override
  _DesignPatternCardState createState() => _DesignPatternCardState();
}

class _DesignPatternCardState extends State<DesignPatternCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.purple[100] : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? Colors.purple[200]! : Colors.grey.shade300,
              blurRadius: _isHovered ? 12.0 : 6.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Design Pattern Name
              Text(
                widget.pattern.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.purple[400],
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8.0),
              // Description (truncated)
              Text(
                widget.pattern.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 16.0),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Read Design Pattern Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReadDesignPatternScreen(pattern: widget.pattern),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Read', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Implement Practice functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Practice feature coming soon!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Practice',style: TextStyle(color: Colors.white,)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}