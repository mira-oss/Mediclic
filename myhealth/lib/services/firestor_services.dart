import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  Future<void> addUser(String userId, String username, String email,
      String number, String role, {Map<String, dynamic>? additionalData}) async {
        
    Map<String, dynamic> userData = {
      'username': username,
      'email': email,
      'number': number,
      'role': role
    };
    if (additionalData != null) {
      userData.addAll(additionalData);
    }
     await users.doc(userId).set(userData)
      .then((value) => print('Utilisateur ajouté'))
      .catchError((error) => print('Erreur : $error'));
  }

  Future<void> addMedecin(String username, String email, String codeProfessionnel, 
                         String specialite, String clinique,String number, String motDePasse) async {
    String userId = users.doc().id;
    
    Map<String, dynamic> medecinData = {
      'username': username,
      'email': email,
      'number': number,
      'role': "medecin",
      'motDePasse': motDePasse,
      'codeProfessionnel': codeProfessionnel,
      'specialite': specialite,
      'clinique': clinique,
      'dateCreation': FieldValue.serverTimestamp(),
    };
    
    await users.doc(userId).set(medecinData)
      .then((value) => print('Médecin ajouté'))
      .catchError((error) => print('Erreur : $error'));
  }
  
  

   Future<DocumentSnapshot> getUserById(String uid) {
    return users.doc(uid).get();
  }


  Future<String> determineUserRole() async {
    QuerySnapshot userSnapshot = await users.get();
    return userSnapshot.docs.isEmpty ? 'clinique' : 'medecin';
  }

  Future<QuerySnapshot> getMedecinsByClinic(String clinicName) {
    return users
      .where('role', isEqualTo: 'medecin')
      .where('clinique', isEqualTo: clinicName)
      .get();
  }

}


