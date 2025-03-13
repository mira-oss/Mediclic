import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<String> addMedecin(String nom, String email, String code, String specialite, String clinique, String numero, String motDePasse) async {
  try {
   
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: motDePasse,
    );


    String userId = userCredential.user!.uid;

   
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'nom': nom,
      'email': email,
      'codeProfessionnel': code,
      'specialite': specialite,
      'clinique': clinique,
      'numero': numero,
      'role': 'medecin',
      'createdAt': FieldValue.serverTimestamp(),
      'motDePasseTemporaire': motDePasse,
    });

    return userId;
  } on FirebaseAuthException catch (e) {
    print("Erreur Firebase Auth: ${e.code} - ${e.message}");
    throw e;
  } catch (e) {
    print("Erreur lors de la création du médecin: $e");
    throw e;
  }
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


