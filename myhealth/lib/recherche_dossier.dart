import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myhealth/dossierMedical.dart';
import 'package:myhealth/miseajour.dart';

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
    });

    try {
      // Rechercher le dossier médical dans Firestore
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
          SnackBar(content: Text('Aucun dossier médical trouvé avec ce code.')),
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
                  onUpdate: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateMedicalRecordScreen(
                          patientRecord: _patientRecord!,
                          onSave: (updatedRecord) async {
                            // Mettre à jour le dossier dans Firestore
                            await FirebaseFirestore.instance
                                .collection('dossiers_medicaux')
                                .doc(_patientRecord!['uniqueCode'])
                                .update(updatedRecord);

                            setState(() {
                              _patientRecord = updatedRecord;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Bouton "Mettre à jour" toujours visible
            if (_patientRecord == null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateMedicalRecordScreen(
                        patientRecord: {
                          'uniqueCode': _uniqueCodeController.text.trim(),
                          'informationsPersonnelles': {},
                          'traitementsAnterieurs': {},
                          'antecedents': {},
                          'allergies': {},
                          'deparasitage': {},
                          'enqueteSociale': {},
                          'examenPhysique': {},
                          'diagnostic': {},
                        },
                        onSave: (updatedRecord) async {
  try {
    // Vérifier si uniqueCode existe
    if (_patientRecord == null || _patientRecord!['uniqueCode'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : uniqueCode non trouvé')),
      );
      return;
    }

    // Mettre à jour ou créer le dossier dans Firestore
    await FirebaseFirestore.instance
        .collection('dossiers_medicaux')
        .doc(_patientRecord!['uniqueCode'])
        .set(updatedRecord, SetOptions(merge: true)); // Utiliser merge pour ne pas écraser les champs existants

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dossier médical mis à jour avec succès !')),
    );

    // Mettre à jour l'état local avec les nouvelles données
    setState(() {
      _patientRecord = updatedRecord;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de la mise à jour : $e')),
    );
  }
},
                      ),
                    ),
                  );
                },
                child: Text('Mettre à jour le dossier'),
              ),
          ],
        ),
      ),
    );
  }
}