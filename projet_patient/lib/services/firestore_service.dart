import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class FirestoreServices {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference dossiers =
      FirebaseFirestore.instance.collection('dossiers');

  // Générer un code unique à 5 chiffres
  String _generateUniqueCode() {
    final random = Random();
    return (10000 + random.nextInt(90000)).toString(); // Code entre 10000 et 99999
  }




 Future<void> addUser(String userId, String username, String email, String number) async {
  try {
    String uniqueCode = _generateUniqueCode();

    // Ajouter l'utilisateur à Firestore
    await users.doc(userId).set({
      'username': username,
      'email': email,
      'number': number,
      'role': 'patient',
      'uniqueCode': uniqueCode,
    });

    // Créer un dossier médical pour l'utilisateur
    await _createDossierMedical(userId, username);

    // Envoyer le code par email
    await _sendCodeByEmail(email, uniqueCode);
  } catch (e) {
    print('Erreur lors de l\'ajout de l\'utilisateur ou de l\'envoi de l\'email : $e');
    throw e; // Propager l'erreur pour la gérer dans l'interface utilisateur
  }
}

  // Créer un dossier médical
  Future<void> _createDossierMedical(String userId, String username) async {
  final dossierId = 'Dossier_$username';
  print('Création du dossier médical avec l\'ID : $dossierId');
  try{
     await dossiers.doc(dossierId).set({
    'patientId': userId,
    'dossierId': dossierId,
    'createdAt': FieldValue.serverTimestamp(),
    'informationsGenerales': {
      'poids': '',
      'groupeSanguin': '',
      'taille': '',
      'contactUrgence': '',
    },
    'amnese': {
      'maladiesPassees': '',
      'symptomesActuels': '',
      'maladiesLiees': '',
    },
    'traitementsAnterieurs': {
      'medicamentsPrescrits': '',
      'interventionsChirurgicales': '',
    },
    'antecedents': {
      'medicaux': '',
      'chirurgicaux': '',
      'gynecoObstetriques': '',
      'familiaux': '',
    },
    'allergies': {
      'medicamenteuses': '',
      'reactionsObservees': '',
    },
    'deparasitage': {
      'medicament': '',
      'dose': '',
    },
    'enqueteSociale': {
      'situationMatrimoniale': '',
      'profession': '',
      'usageDrogues': false,
    },
    'examensPhysiques': {
      'nomExamen': '',
      'fichierExamen': '',
    },
    'diagnostic': {
      'hypothesesDiagnostiques': '',
      'diagnosticFinal': '',
    },
    });
     print('Dossier médical créé avec succès');
  } catch (e) {
    print('Erreur lors de la création du dossier médical : $e');
    throw e;
}
  }

Future<void> _sendCodeByEmail(String email, String code) async {
  // Configuration du serveur SMTP (exemple avec Gmail)
  final smtpServer = gmail('votre-email@gmail.com', 'votre-mot-de-passe');

  // Création du message
  final message = Message()
    ..from = Address('votre-email@gmail.com', 'Votre Nom')
    ..recipients.add(email)
    ..subject = 'Votre code de vérification'
    ..text = 'Votre code de vérification est : $code';

  try {
    // Envoyer l'email
    final sendReport = await send(message, smtpServer);
    print('Email envoyé avec succès : ${sendReport.toString()}');
  } catch (e) {
    print('Erreur lors de l\'envoi de l\'email : $e');
  }
}
}


