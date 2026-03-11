import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/home/chatbot/widgets/input_area.dart';
import 'package:drips_water/presentation/screens/home/chatbot/widgets/message_bubble.dart';
import 'package:drips_water/presentation/screens/home/chatbot/widgets/typing_indicator.dart';
import 'package:drips_water/presentation/widgets/shared/app_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:drips_water/logic/services/dialogflow_service.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final _dialogflow = DialogflowService();
  final TextEditingController _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _dialogflow.init();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'text':
                'Hi! I\'m the Drips Assistant. How can I help you with your water delivery today?',
            'isUser': false,
            'time': DateTime.now(),
          });
        });
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final reply = await _dialogflow.sendMessage(trimmed);
      if (!mounted) return;

      if (reply.isNotEmpty) {
        setState(() {
          _messages.add({'text': reply, 'isUser': false});
          _isTyping = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'text': 'Something went wrong. Please try again later.',
          'isUser': false,
        });
      });
    } finally {
      if (mounted) {
        setState(() => _isTyping = false);
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _dialogflow.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: 70,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: .start,
                children: [
                  const Text(
                    "Drips Assistant",
                    style: TextStyle(fontSize: 16, fontWeight: .w700),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Always active",
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? const AppEmptyState(
                      title: "No messages yet",
                      description:
                          "I'm your virtual assistant. Ask me anything about our services",
                      icon: Icons.chat_bubble_outline,
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      padding: const .fromLTRB(16, 16, 16, 20),
                      itemBuilder: (context, index) {
                        if (_isTyping && index == _messages.length) {
                          return const TypingIndicator();
                        }
                        final msg = _messages[index];
                        return MessageBubble(
                          text: msg['text'],
                          isUser: msg['isUser'],
                        );
                      },
                    ),
            ),
            InputArea(
              controller: _controller,
              onSend: (value) {
                _sendMessage(value);
                _controller.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
