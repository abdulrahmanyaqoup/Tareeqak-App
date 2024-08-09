import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class MessageList extends StatefulWidget {

  const MessageList({
    required this.messages, required this.animationController, required this.scrollController, super.key,
  });
  final List<String> messages;
  final AnimationController animationController;
  final ScrollController scrollController;

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  Widget _buildTypingIndicator() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          const CircleAvatar(radius: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const SizedBox(height: 20, width: 100),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        final isUser = (index % 2).isEven;

        if (message.isEmpty) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: _buildTypingIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.transparent,
                  child: Lottie.asset(
                    'assets/animations/starsFilled.json',
                    fit: BoxFit.contain,
                    controller: widget.animationController,
                  ),
                )
              else
                const SizedBox(width: 24),
              const SizedBox(width: 4),
              Expanded(
                child: Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16,),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                      color: !isUser ? Colors.grey[200] : null,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }
}
