import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(
    String userId,
    String username,
    String email,
    String number,
  ) async {
    await users.doc(userId).set({
      'username': username,
      'email': email,
      'number': number,
      'role': 'patient', // Assign the role "patient" here
    });
  }

  Future<String?> determineUserRole(String userId) async {
    try {
      DocumentSnapshot userDoc = await users.doc(userId).get();
      if (userDoc.exists) {
        return userDoc['role'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error determining user role: $e');
      return null;
    }
  }
}