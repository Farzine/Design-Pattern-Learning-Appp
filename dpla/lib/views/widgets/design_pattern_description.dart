import 'package:flutter/material.dart';

class DesignPatternDescription extends StatefulWidget {
  final String description;

  const DesignPatternDescription({Key? key, required this.description})
      : super(key: key);

  @override
  _DesignPatternDescriptionState createState() =>
      _DesignPatternDescriptionState();
}

class _DesignPatternDescriptionState extends State<DesignPatternDescription> {
  
  late String heading; 
  late String subheading; 
  late List<String> bodyLines; 

  // For word highlighting
  late List<String> _words; 
  late List<bool> _isHighlighted; 
  late List<Color> _highlightColors; 

  // For notes
  final TextEditingController _noteController = TextEditingController();
  List<String> _notes = []; 

  @override
  void initState() {
    super.initState();
    
    final lines = widget.description.trim().split('\n');

    // Parse heading, subheading, and body
    heading = lines.isNotEmpty ? lines[0] : '';
    subheading = lines.length > 1 ? lines[1] : '';
    bodyLines = lines.length > 2 ? lines.sublist(2) : [];

    
    final bodyText = bodyLines.join(' ');

    
    _words = bodyText.isNotEmpty ? bodyText.split(' ') : [];

    // Initialize highlight arrays
    _isHighlighted = List.filled(_words.length, false);
    _highlightColors = List.filled(_words.length, Colors.transparent);
  }

  // Show color picker dialog
  void _showColorPicker(int index) async {
    final Color? color = await showDialog<Color>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Highlight Color'),
          content: SingleChildScrollView(
            child: ColorPickerGrid(
              onColorSelected: (Color color) {
                setState(() {
                  _highlightColors[index] = color;
                });
                Navigator.of(context).pop(color);
              },
            ),
          ),
        );
      },
    );

    if (color != null) {
      setState(() {
        _highlightColors[index] = color;
      });
    }
  }

  // Add a note to the list
  void _addNote() {
    final text = _noteController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _notes.add(text);
      });
      _noteController.clear();
    }
  }

  // Dismiss the keyboard when tapping outside of the note section
  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard, 
      child: Container(
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              if (heading.isNotEmpty)
                Text(
                  heading,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              // Subheading
              if (subheading.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  subheading,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],

              // Body area (with highlighting)
              if (_words.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    children: List.generate(_words.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _isHighlighted[index] = !_isHighlighted[index];
                          });
                        },
                        onLongPress: () {
                          _showColorPicker(index);
                        },
                        child: SizedBox(
                          child: Container(
                            decoration: BoxDecoration(
                              color: _isHighlighted[index]
                                  ? _highlightColors[index]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 4,
                            ),
                            margin: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${_words[index]} ',
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],

              // Notes section
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add a Note:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Write your note here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.edit),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _addNote,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Note',
                            style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.purple[200],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Display notes in bullet points
              if (_notes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Your Notes:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _notes.map((note) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.4,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              note,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Custom color picker widget for highlight selection
class ColorPickerGrid extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ColorPickerGrid({Key? key, required this.onColorSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.yellow,
      Colors.purple,
      Colors.cyan,
      Colors.pink,
      Colors.lime,
      Colors.brown,
      Colors.grey,
      Colors.teal,
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: colors.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) {
        final color = colors[index];
        return InkWell(
          onTap: () => onColorSelected(color),
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            width: 40,
            height: 40,
          ),
        );
      },
    );
  }
}
