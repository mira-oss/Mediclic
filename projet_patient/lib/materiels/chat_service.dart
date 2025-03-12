import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGPTService {
  final String apiKey = "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"; // Remplace par ta vraie clé API

  Future<String> sendMessage(String message) async {
    const url = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "Tu es un assistant utile."},
          {"role": "user", "content": message}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      return "Erreur : ${response.body}";
    }
  }
}
