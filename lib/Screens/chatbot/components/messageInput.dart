import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    required this.controller,
    required this.isTyping,
    required this.onSend,
    super.key,
  });
  final TextEditingController controller;
  final bool isTyping;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: Icon(isTyping ? Icons.stop : Icons.send),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
