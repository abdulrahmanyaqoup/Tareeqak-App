import 'package:chatview/chatview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/api/openaiApi.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin<ChatScreen> {
  @override
  bool get wantKeepAlive => true;

  bool isDarkTheme = false;

  final OpenaiApi _api = OpenaiApi();
  final Uuid _uuid = const Uuid();
  bool _isTyping = false;

  final _chatController = ChatController(
    initialMessageList: [],
    scrollController: ScrollController(),
    currentUser: ChatUser(id: 'user', name: 'User'),
    otherUsers: [
      ChatUser(id: 'bot', name: 'Bot'),
    ],
  );

  void _onSendTap(
      String messageText, ReplyMessage replyMessage, MessageType messageType) {
    final userMessage = Message(
      id: _uuid.v4(),
      message: messageText,
      createdAt: DateTime.now(),
      sentBy: _chatController.currentUser.id,
      messageType: messageType,
    );

    _chatController.addMessage(userMessage);
    _sendMessageToApi(messageText);
  }

  void _sendMessageToApi(String message) async {
    setState(() {
      _isTyping = true;
    });

    final response = await _api.sendMessage(message);

    final botMessage = Message(
      id: _uuid.v1(),
      message: response,
      createdAt: DateTime.now(),
      sentBy: 'bot',
    );

    setState(() {
      _isTyping = false;
      _chatController.addMessage(botMessage);
    });
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withOpacity(0.4),
      appBar: CupertinoNavigationBar(
        middle: const Text(
          "Chat AI",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: ChatView(
        chatController: _chatController,
        onSendTap: _onSendTap,
        chatViewState: _chatController.initialMessageList.isEmpty
            ? ChatViewState.noData
            : ChatViewState.hasMessages,
        
        chatViewStateConfig: ChatViewStateConfiguration(
          loadingWidgetConfig: ChatViewStateWidgetConfiguration(
            loadingIndicatorColor: theme.colorScheme.secondary,
          ),
        ),
        
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            color: theme.colorScheme.primary,
            textStyle: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
          ),
          inComingChatBubbleConfig: ChatBubble(
            color: Theme.of(context).colorScheme.tertiary,
            textStyle: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 16,fontWeight: FontWeight.bold),
            senderNameTextStyle: TextStyle(color: Theme.of(context).colorScheme.secondary,fontSize: 16,fontWeight: FontWeight.bold),
          ),
        ),
        emojiPickerSheetConfig: Config(
          bottomActionBarConfig: BottomActionBarConfig(
            enabled: false,
            
          )
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          backgroundColor: theme.colorScheme.surface,
        ),
        sendMessageConfig: SendMessageConfiguration(
          allowRecordingVoice: false,
          enableCameraImagePicker: false,
          enableGalleryImagePicker: false,
          textFieldBackgroundColor: Colors.grey.shade200,
          textFieldConfig: TextFieldConfiguration(
            borderRadius: BorderRadius.circular(10),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintText: 'Send a message...',
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            hintStyle: TextStyle(color: theme.textTheme.bodyLarge?.color),
            onMessageTyping: (status) {
              debugPrint(status.toString());
            },
            textStyle: TextStyle(color: theme.textTheme.bodyLarge?.color),
          ),
          replyMessageColor: theme.colorScheme.surface,
          defaultSendButtonColor: theme.colorScheme.primary,
        ),
        
      ),
    );
  }
}
