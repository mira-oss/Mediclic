import 'package:flutter/material.dart';
import 'package:projet_patient/materiels/chat_service.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ChatGPTService _chatService = ChatGPTService();
  List<Map<String, String>> messages = [];

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "content": _controller.text});
    });

    String response = await _chatService.sendMessage(_controller.text);

    setState(() {
      messages.add({"role": "assistant", "content": response});
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ChatGPT")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message["content"]!),
                  subtitle: Text(message["role"] == "user" ? "Toi" : "ChatGPT"),
                  tileColor: message["role"] == "user" ? Colors.blue[100] : Colors.grey[200],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Écris ton message..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
