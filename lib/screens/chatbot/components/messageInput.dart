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
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.5),
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          TextField(
            onTapOutside: (pointerEvent) {
              FocusScope.of(context).unfocus();
            },
            maxLines: null,
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Ask me about universities',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.only(
                left: 16,
                bottom: 10,
                top: 10,
                right: 40,
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 0,
            child: CupertinoButton(
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
        ],
      ),
    );
  }
}
