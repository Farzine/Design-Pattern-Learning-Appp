import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  final List<FAQItem> _faqItems = [
    FAQItem(
        question: "How do I reset my password?",
        answer: "To reset your password, go to the login screen, click on 'Forgot Password', and follow the instructions."),
    FAQItem(
        question: "How do I update my profile?",
        answer: "You can update your profile by navigating to the 'Profile' section and clicking on the 'Edit Profile' button."),
    FAQItem(
        question: "Where can I find my progress?",
        answer: "Your progress can be tracked in the 'Dashboard' section where all your activity is summarized."),
    FAQItem(
        question: "How do I contact support?",
        answer: "You can contact our support team by clicking on the 'Contact Support' button below."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        elevation: 2,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Header
          Center(
            child: Text(
              "How can we help you?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.purple[400],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Find answers to common questions below or contact our support team.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),

          // FAQ Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _faqItems.length,
              itemBuilder: (context, index) {
                final faqItem = _faqItems[index];
                return FAQTile(item: faqItem);
              },
            ),
          ),

          // Contact Support Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showSupportDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[400],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.support_agent, color: Colors.white),
                label: const Text(
                  "Contact Support",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show support contact dialog
  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Contact Support"),
        content: const Text(
            "You can reach us at farzine07@student.sust.edu or call us at +8801793834474."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}

/// Model class for FAQ Items
class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

/// Widget for a collapsible FAQ Tile
class FAQTile extends StatefulWidget {
  final FAQItem item;

  const FAQTile({Key? key, required this.item}) : super(key: key);

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.item.isExpanded) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      widget.item.isExpanded = !widget.item.isExpanded;
      if (widget.item.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.item.question,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              widget.item.isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.purple[400],
            ),
            onTap: _toggleExpansion,
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.item.answer,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
