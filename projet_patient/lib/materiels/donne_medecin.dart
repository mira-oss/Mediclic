import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> getDoctors() async {
  List<Map<String, dynamic>> doctors = [];
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'medecin')
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      doctors.add(data);
    }
  } catch (e) {
    print("Erreur lors de la récupération des médecins : $e");
  }
  return doctors;
}