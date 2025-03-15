import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = "AIzaSyDlfh5VLT-MlwAC9ZOoDZAuECdeGXkYLgA"; // Mets ta clé ici

  late GenerativeModel model;

  GeminiService() {
    model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  Future<String> sendMessage(String message) async {
    // Vérifier si le message est médical
    if (!_isMedicalRelated(message)) {
      return "Je suis conçu uniquement pour donner des conseils sur les spécialistes médicaux à consulter.";
    }

    try {
      final content = [Content.text(message)];
      final response = await model.generateContent(content);
      return response.text ?? "Aucune réponse.";
    } catch (e) {
      return "Erreur : $e";
    }
  }

  // Fonction pour filtrer les questions médicales
  bool _isMedicalRelated(String message) {
    List<String> medicalKeywords = [
      "maladie", "douleur", "médecin", "hôpital", "spécialiste",
      "fièvre", "infection", "allergie", "cardiologue", "dentiste",
      "pédiatre", "ophtalmologue", "dermatologue", "neurologue",
      "gynécologue", "psychologue", "symptômes", "diagnostic",
      "ordonnance", "traitement", "chirurgie"
    ];

    for (var keyword in medicalKeywords) {
      if (message.toLowerCase().contains(keyword)) {
        return true;
      }
    }

    return false;
  }
}
