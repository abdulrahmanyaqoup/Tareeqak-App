import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../api/openaiApi.dart';
import 'components/messageInput.dart';
import 'components/messageList.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  ChatBotState createState() => ChatBotState();
}

class ChatBotState extends State<ChatBot>
    with AutomaticKeepAliveClientMixin<ChatBot>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _messages = [];
  final OpenaiApi _api = OpenaiApi();
  bool _isTyping = false;
  bool _stopTyping = false;
  late final AnimationController _animationController = AnimationController(
    value: 0.25,
    vsync: this,
  );

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_isTyping) {
      _stopTyping = true;
      setState(() {
        _isTyping = false;
      });
      return;
    }

    _scrollToLastMessage();
    final message = _controller.text.trim();
    if (message.isEmpty) return;
    _controller.clear();

    setState(() {
      _messages.add(message);
      _isTyping = true;
      _stopTyping = false;
      _messages.add(''); // Placeholder for typing indicator
    });

    await Future.delayed(const Duration(milliseconds: 10));
    final response = await _api.sendMessage(message);

    await _simulateTyping(response);
  }

  Future<void> _simulateTyping(String response) async {
    setState(() {
      _messages[_messages.length - 1] = ''; // Clear placeholder
    });

    for (var i = 0; i < response.length; i++) {
      if (_stopTyping && _messages[_messages.length - 1].isEmpty) {
        _messages[_messages.length - 1] = 'Typing stopped here';
        break;
      } else if (_stopTyping) {
        break;
      }

      await Future.delayed(const Duration(milliseconds: 2));
      setState(() {
        _messages[_messages.length - 1] += response[i];
      });
    }

    setState(() {
      _isTyping = false;
      _scrollToLastMessage();
    });
  }

  void _scrollToLastMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.4),
      appBar: CupertinoNavigationBar(
        middle: const Text(
          'Chat AI',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          if (_messages.isEmpty) Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Lottie.asset(
                          'assets/animations/astronet.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20, width: 100),
                      SizedBox(
                        width: 300,
                        child: Text(
                          // ignore: lines_longer_than_80_chars
                          'Hello! I am Astronet, Know about universities, courses, and more in Jordan.',
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ) else Expanded(
                  child: MessageList(
                    messages: _messages,
                    animationController: _animationController,
                    scrollController: _scrollController,
                  ),
                ),
          MessageInput(
            controller: _controller,
            isTyping: _isTyping,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
