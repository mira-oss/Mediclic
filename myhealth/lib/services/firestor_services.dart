import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  Future<void> addUser(String userId, String username, String email,
      String number, String role) async {
    await users.doc(userId).set({
      'username': username,
      'email': email,
      'number': number,
      'role': role,
    });
  }

  Future<String> determineUserRole() async {
    QuerySnapshot userSnapshot = await users.get();
    return userSnapshot.docs.isEmpty ? 'clinique' : 'medecin';
  }

  Future<DocumentSnapshot> getUserById(String uid) {
    return users.doc(uid).get();
  }
}
