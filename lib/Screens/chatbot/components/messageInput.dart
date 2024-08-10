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
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      margin: const EdgeInsets.only(bottom: 15, left: 12, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textBaseline: TextBaseline.alphabetic,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextField(
              onTapOutside: (pointerEvent) {
                FocusScope.of(context).unfocus();
              },
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Ask me about universities',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          CupertinoButton(
            pressedOpacity: 0.8,
            padding: const EdgeInsets.only(
              left: 5,
            ),
            onPressed: onSend,
            child: Icon(
              isTyping
                  ? CupertinoIcons.stop_circle_fill
                  : CupertinoIcons.arrow_up_circle_fill,
              color: isTyping
                  ? Colors.red.shade500
                  : Theme.of(context).colorScheme.primary,
              size: 45,
              applyTextScaling: true,
            ),
          ),
        ],
      ),
    );
  }
}
