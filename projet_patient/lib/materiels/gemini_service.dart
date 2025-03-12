import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = "AIzaSyDlfh5VLT-MlwAC9ZOoDZAuECdeGXkYLgA"; // Mets ta clé ici

  late GenerativeModel model;

  GeminiService() {
    model = GenerativeModel(
      model: 'gemini-2.0-flash', // Utilisation du bon modèle
      apiKey: apiKey,
    );
  }

  Future<String> sendMessage(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await model.generateContent(content);
      return response.text ?? "Aucune réponse.";
    } catch (e) {
      return "Erreur : $e";
    }
  }
}
