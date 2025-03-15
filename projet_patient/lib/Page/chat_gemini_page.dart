import 'package:flutter/material.dart';
import 'package:projet_patient/materiels/gemini_service.dart';

class ChatGemini extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatGemini> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _chatService = GeminiService();
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
      appBar: AppBar(title: Text("Chat avec Gemini AI", style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: message["role"] == "user"
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (message["role"] == "assistant")
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.account_circle, color: Colors.white),
                        ),
                      SizedBox(width: 8),
                      Material(
                        borderRadius: BorderRadius.circular(16),
                        elevation: 4,
                        color: message["role"] == "user" ? Colors.blue[100] : Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7), // Limite la largeur du message
                            child: Text(
                              message["content"]!,
                              style: TextStyle(
                                fontSize: 16,
                                color: message["role"] == "user" ? Colors.black : Colors.black87,
                              ),
                              softWrap: true, // Permet le retour à la ligne
                              overflow: TextOverflow.visible, // Permet l'affichage complet du texte
                            ),
                          ),
                        ),
                      ),
                      if (message["role"] == "user")
                        SizedBox(width: 8),
                      if (message["role"] == "user")
                        CircleAvatar(
                          backgroundColor: Colors.greenAccent,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                    ],
                  ),
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
                    decoration: InputDecoration(hintText: "Écris ton message...", border: OutlineInputBorder()),
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
