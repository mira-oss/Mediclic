import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet_patient/Page/afficahgepatient.dart';

class PatientRecordSearchScreen extends StatefulWidget {
  @override
  _PatientRecordSearchScreenState createState() => _PatientRecordSearchScreenState();
}

class _PatientRecordSearchScreenState extends State<PatientRecordSearchScreen> {
  final TextEditingController _uniqueCodeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _searchPatient() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('dossiers_medicaux')
          .where('uniqueCode', isEqualTo: _uniqueCodeController.text.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final patientRecord = querySnapshot.docs.first.data() as Map<String, dynamic>;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientRecordViewScreen(patientRecord: patientRecord),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun dossier trouvé pour ce code unique.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rechercher mon dossier médical'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _uniqueCodeController,
              decoration: InputDecoration(
                labelText: 'Entrez mon code ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchPatient,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Rechercher'),
            ),
          ],
        ),
      ),
    );
  }
}