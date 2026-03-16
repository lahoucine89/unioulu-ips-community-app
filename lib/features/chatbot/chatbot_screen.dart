import 'dart:convert';

import 'package:community/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  bool isDarkMode = false;

  Future<void> _sendMessage({String? predefinedMessage}) async {
    final userMessage = (predefinedMessage ?? _controller.text).trim();

    if (userMessage.isEmpty || isLoading) return;

    setState(() {
      messages.add({
        "sender": "user",
        "message": userMessage,
      });
      _controller.clear();
      isLoading = true;
    });

    _scrollToBottom();

    final response = await _getChatbotResponse(userMessage);

    if (!mounted) return;

    setState(() {
      messages.add({
        "sender": "bot",
        "message": response,
      });
      isLoading = false;
    });

    _scrollToBottom();
  }

  Future<String> _getChatbotResponse(String message) async {
    try {
      final url = Uri.parse('http://127.0.0.1:8000/chat');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "message": message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data['response']?.toString().trim() ?? '';

        if (botResponse.isEmpty) {
          return 'Empty response from model.';
        }

        return botResponse;
      }

      return 'Server error: ${response.statusCode}';
    } catch (e) {
      return 'Connection error: $e';
    }
  }

  void _sendPredefinedResponse(String predefinedMessage) {
    _sendMessage(predefinedMessage: predefinedMessage);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    final bool isUser = message['sender'] == 'user';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: isUser ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 5,
              ),
            ],
          ),
          child: Text(
            message['message'] ?? '',
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReply(String text) {
    return ElevatedButton(
      onPressed: isLoading ? null : () => _sendPredefinedResponse(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black54,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Chat with Bot",
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty && !isLoading
                ? Center(
                    child: Text(
                      'Ask me about events, announcements, or the app.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    itemCount: messages.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (isLoading && index == messages.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final message = messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isDarkMode ? Colors.white : Colors.blueAccent,
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Ask a question...",
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: isLoading ? null : _sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQuickReply("Hello"),
                const SizedBox(width: 10),
                _buildQuickReply("How are you?"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
