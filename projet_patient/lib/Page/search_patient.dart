import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Assurez-vous que ce chemin est correct

class SearchPatientScreen extends StatefulWidget {
  @override
  _SearchPatientScreenState createState() => _SearchPatientScreenState();
}

class _SearchPatientScreenState extends State<SearchPatientScreen> {
  final TextEditingController _uniqueCodeController = TextEditingController();
  Map<String, dynamic>? _patientRecord;
  bool _isLoading = false;

  Future<void> _searchPatient() async {
    setState(() {
      _isLoading = true;
      _patientRecord = null; // Réinitialiser le dossier précédent
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('dossiers_medicaux')
          .where('uniqueCode', isEqualTo: _uniqueCodeController.text.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _patientRecord = querySnapshot.docs.first.data() as Map<String, dynamic>;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun dossier trouvé pour ce code.')),
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
        title: Text('Rechercher un patient'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _uniqueCodeController,
              decoration: InputDecoration(
                labelText: 'Entrez le code unique du patient',
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
            SizedBox(height: 20),
            if (_patientRecord != null)
              Expanded(
                child: MedicalRecordView(
                  patientRecord: _patientRecord!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MedicalRecordView extends StatelessWidget {
  final Map<String, dynamic> patientRecord;

  MedicalRecordView({required this.patientRecord});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichez ici les informations du dossier médical à partir de patientRecord
            Text('Code unique: ${patientRecord['uniqueCode']}'),
            // Exemple : Afficher d'autres informations
            if (patientRecord['informationsPersonnelles'] != null)
              Text(
                  'Nom: ${patientRecord['informationsPersonnelles']['nom'] ?? 'N/A'}'),
            // ... Ajoutez d'autres champs à afficher ...
          ],
        ),
      ),
    );
  }
}