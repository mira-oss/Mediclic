import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMedicalRecordScreen extends StatefulWidget {
  final Map<String, dynamic> patientRecord;
  final Function(Map<String, dynamic>) onSave;

  UpdateMedicalRecordScreen({required this.patientRecord, required this.onSave});

  @override
  _UpdateMedicalRecordScreenState createState() => _UpdateMedicalRecordScreenState();
}

class _UpdateMedicalRecordScreenState extends State<UpdateMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tailleController;
  late TextEditingController _poidsController;
  late TextEditingController _groupeSanguinController;
  late TextEditingController _medicamentsPrecedentsController;
  late TextEditingController _interventionsChirurgicalesController;
  late TextEditingController _therapiesSuiviesController;
  late TextEditingController _antecedentsMedicauxController;
  late TextEditingController _antecedentsChirurgicauxController;
  late TextEditingController _antecedentsGynecoObstetriquesController;
  late TextEditingController _antecedentsFamiliauxController;
  late TextEditingController _allergiesMedicamentsController;
  late TextEditingController _allergiesAlimentairesController;
  late TextEditingController _reactionsObserveesController;
  late TextEditingController _typeTraitementController;
  late TextEditingController _frequenceTraitementController;
  late TextEditingController _situationFamilialeController;
  late TextEditingController _professionController;
  late TextEditingController _habitudesAlimentairesController;
  late TextEditingController _nomExamenController;
  String? _pdfUrl; // Pour stocker l'URL du fichier PDF
  bool _isUploading = false; // Pour gérer l'état de l'upload
  late TextEditingController _resultatExamenController;
  late TextEditingController _hypothesesDiagnostiquesController;
  late TextEditingController _diagnosticFinalController;

  @override
  void initState() {
    super.initState();
    _tailleController = TextEditingController();
    _poidsController = TextEditingController();
    _groupeSanguinController = TextEditingController();
    _medicamentsPrecedentsController = TextEditingController();
    _interventionsChirurgicalesController = TextEditingController();
    _therapiesSuiviesController = TextEditingController();
    _antecedentsMedicauxController = TextEditingController();
    _antecedentsChirurgicauxController = TextEditingController();
    _antecedentsGynecoObstetriquesController = TextEditingController();
    _antecedentsFamiliauxController = TextEditingController();
    _allergiesMedicamentsController = TextEditingController();
    _allergiesAlimentairesController = TextEditingController();
    _reactionsObserveesController = TextEditingController();
    _typeTraitementController = TextEditingController();
    _frequenceTraitementController = TextEditingController();
    _situationFamilialeController = TextEditingController();
    _professionController = TextEditingController();
    _habitudesAlimentairesController = TextEditingController();
    _nomExamenController = TextEditingController();
    _resultatExamenController = TextEditingController();
    _hypothesesDiagnostiquesController = TextEditingController();
    _diagnosticFinalController = TextEditingController();
  }

  Future<void> _uploadPdf() async {
  setState(() {
    _isUploading = true;
  });

  try {
    // Sélectionner un fichier PDF
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      // Vérifier si le fichier contient des données
      if (file.bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : le fichier ne peut pas être lu.')),
        );
        return;
      }

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('examens/$fileName.pdf');

      // Upload du fichier
      await storageReference.putData(file.bytes!);
      String downloadURL = await storageReference.getDownloadURL();

      setState(() {
        _pdfUrl = downloadURL;
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de l\'upload du fichier : $e')),
    );
  } finally {
    setState(() {
      _isUploading = false;
    });
  }
}

  Future<void> _launchPdf(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d\'ouvrir le fichier PDF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mettre à jour le dossier médical'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Informations personnelles
              _buildSectionTitle('Informations Personnelles'),
              _buildTextFormField('Taille', _tailleController),
              _buildTextFormField('Poids', _poidsController),
              _buildTextFormField('Groupe Sanguin', _groupeSanguinController),

              // Traitements antérieurs
              _buildSectionTitle('Traitements Antérieurs'),
              _buildTextFormField('Médicaments précédents', _medicamentsPrecedentsController),
              _buildTextFormField('Interventions chirurgicales', _interventionsChirurgicalesController),
              _buildTextFormField('Thérapies suivies', _therapiesSuiviesController),

              // Antécédents
              _buildSectionTitle('Antécédents'),
              _buildTextFormField('Antécédents médicaux', _antecedentsMedicauxController),
              _buildTextFormField('Antécédents chirurgicaux', _antecedentsChirurgicauxController),
              _buildTextFormField('Antécédents gynéco-obstétriques', _antecedentsGynecoObstetriquesController),
              _buildTextFormField('Antécédents familiaux', _antecedentsFamiliauxController),

              // Allergies
              _buildSectionTitle('Allergies'),
              _buildTextFormField('Allergies médicamenteuses', _allergiesMedicamentsController),
              _buildTextFormField('Allergies alimentaires', _allergiesAlimentairesController),
              _buildTextFormField('Réactions observées', _reactionsObserveesController),

              // Déparasitage
              _buildSectionTitle('Déparasitage'),
              _buildTextFormField('Type de traitement', _typeTraitementController),
              _buildTextFormField('Fréquence', _frequenceTraitementController),

              // Enquête sociale
              _buildSectionTitle('Enquête Sociale'),
              _buildTextFormField('Situation familiale', _situationFamilialeController),
              _buildTextFormField('Profession', _professionController),
              _buildTextFormField('Habitudes alimentaires', _habitudesAlimentairesController),

              // Examen physique
              _buildSectionTitle('Examen Physique'),
              _buildTextFormField('Nom de l\'examen', _nomExamenController),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadPdf,
                child: _isUploading
                    ? CircularProgressIndicator()
                    : Text('Uploader un fichier PDF'),
              ),
              SizedBox(height: 10),
              if (_pdfUrl != null)
                InkWell(
                  onTap: () => _launchPdf(_pdfUrl!),
                  child: Text(
                    'Télécharger le résultat de l\'examen (PDF)',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

              // Diagnostic
              _buildSectionTitle('Diagnostic'),
              _buildTextFormField('Hypothèses diagnostiques', _hypothesesDiagnostiquesController),
              _buildTextFormField('Diagnostic final', _diagnosticFinalController),

              // Bouton de sauvegarde
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

                     if (widget.patientRecord['uniqueCode'] == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur : uniqueCode non trouvé')),
                      );
                      return;
                    }

                    Map<String, dynamic> updatedRecord = {
                      ...widget.patientRecord,
                      'informationsPersonnelles': {
                        ...widget.patientRecord['informationsPersonnelles'] ?? {},
                        'taille': _tailleController.text,
                        'poids': _poidsController.text,
                        'groupeSanguin': _groupeSanguinController.text,
                        'date': currentDate,
                      },
                      'traitementsAnterieurs': {
                        ...widget.patientRecord['traitementsAnterieurs'] ?? {},
                        'medicamentsPrecedents': [
                          ...widget.patientRecord['traitementsAnterieurs']?['medicamentsPrecedents'] ?? [],
                          ..._medicamentsPrecedentsController.text.split(','),
                        ],
                        'interventionsChirurgicales': [
                          ...widget.patientRecord['traitementsAnterieurs']?['interventionsChirurgicales'] ?? [],
                          ..._interventionsChirurgicalesController.text.split(','),
                        ],
                        'therapiesSuivies': [
                          ...widget.patientRecord['traitementsAnterieurs']?['therapiesSuivies'] ?? [],
                          ..._therapiesSuiviesController.text.split(','),
                        ],
                        'date': currentDate,
                      },
                      'examenPhysique': {
                        ...widget.patientRecord['examenPhysique'] ?? {},
                        'nomExamen': _nomExamenController.text,
                        'resultatExamen': _pdfUrl, // URL du fichier PDF
                        'date': currentDate,
                      },
                      // Ajoutez les autres sections ici...
                    };

                    await widget.onSave(updatedRecord);
                    Navigator.pop(context);
                  }
                },
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez remplir ce champ';
          }
          return null;
        },
      ),
    );
  }
}