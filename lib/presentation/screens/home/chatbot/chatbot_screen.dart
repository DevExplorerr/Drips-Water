import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/home/chatbot/widgets/input_area.dart';
import 'package:drips_water/presentation/screens/home/chatbot/widgets/message_bubble.dart';
import 'package:drips_water/presentation/screens/home/chatbot/widgets/typing_indicator.dart';
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
          title: const Text("Drips Chatbot"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            const Icon(Icons.circle, size: 12, color: AppColors.success),
            const SizedBox(width: 6),
            Text("Online", style: textTheme.bodyMedium),
            const SizedBox(width: 20),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
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
