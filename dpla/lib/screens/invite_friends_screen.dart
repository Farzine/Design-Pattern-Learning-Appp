import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String referralCode = "DPLA1234";
    const String inviteMessage =
        "Hey! Join me on this amazing app and learn design patterns interactively. Use my referral code **DPLA1234** to get started: https://example.com/invite";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Friends'),
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        elevation: 4,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Header
          Center(
            child: Text(
              "Invite Your Friends!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple[400],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Share your referral code with friends and help them join the app to start learning design patterns interactively!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),

          // Illustration (Placeholder Image)
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/logo.png', // Replace with your illustration asset
                height: 200,
              ),
            ),
          ),

          // Referral Code Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    referralCode,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.purple),
                    onPressed: () {
                      _copyToClipboard(context, referralCode);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Share Invite Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _shareInvite(inviteMessage);
              },
              icon: const Icon(Icons.share, color: Colors.white, size: 24),
              label: const Text(
                "Share Invite",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[400],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// Function to share invite message using the Share plugin
  void _shareInvite(String message) {
    Share.share(message);
  }

  /// Function to copy referral code to clipboard
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Referral code copied to clipboard!'),
        backgroundColor: Colors.purple[400],
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
