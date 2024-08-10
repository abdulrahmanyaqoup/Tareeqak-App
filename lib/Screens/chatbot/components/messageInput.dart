import 'package:flutter/cupertino.dart';
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
    return Material(
      elevation: 1,
      shadowColor: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(10),
      child: TextField(
        onTapOutside: (pointerEvent) {
          FocusScope.of(context).unfocus();
        },
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Ask me about universities',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          suffixIcon: CupertinoButton(
            pressedOpacity: 0.8,
            padding: EdgeInsets.zero,
            onPressed: onSend,
            child: Icon(
              isTyping
                  ? CupertinoIcons.stop_circle_fill
                  : CupertinoIcons.arrow_up_circle_fill,
              color: isTyping
                  ? Colors.red.shade500
                  : Theme.of(context).colorScheme.primary,
              size: 35, // Adjust the size as needed
              applyTextScaling: true,
            ),
          ),
        ),
      ),
    );
  }
}
