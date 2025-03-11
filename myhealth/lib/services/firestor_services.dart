import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  Future<void> addUser(String userId, String username, String email,
      String number,// String role
      ) async {
    await users.doc(userId).set({
      'username': username,
      'email': email,
      'number': number,
      //'role': role,
    });
  }

  
}
