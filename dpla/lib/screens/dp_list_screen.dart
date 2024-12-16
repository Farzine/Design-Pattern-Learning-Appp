// lib/screens/dp_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dpla/providers/design_pattern_provider.dart';
import 'package:dpla/models/design_pattern.dart';
import 'package:dpla/screens/read_design_pattern_screen.dart';
import 'package:dpla/screens/practice_session_screen.dart';
import '../widgets/custom_nav_bar.dart';
import 'dart:async';

class DpListScreen extends ConsumerStatefulWidget {
  const DpListScreen({Key? key}) : super(key: key);

  @override
  _DpListScreenState createState() => _DpListScreenState();
}

class _DpListScreenState extends ConsumerState<DpListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Listen to search input changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      ref.read(designPatternProvider.notifier).searchDesignPatterns(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final designPatternState = ref.watch(designPatternProvider);

    return Scaffold(
      appBar: CustomNavBar(
        logoPath: 'assets/logo.png', // Path to your logo asset
        searchController: _searchController,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: designPatternState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : designPatternState.error != null
                ? Center(child: Text(designPatternState.error!))
                : designPatternState.patterns.isEmpty
                    ? const Center(child: Text('No design patterns found.'))
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
                          builder: (context) => ReadDesignPatternScreen(pattern: widget.pattern),
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
                      // Navigate to Practice Session Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PracticeSessionScreen(
                            designPatternId: widget.pattern.id,
                            designPatternName: widget.pattern.name,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Practice', style: TextStyle(color: Colors.white)),
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
