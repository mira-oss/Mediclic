import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

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
  late TextEditingController _resultatExamenController;
  late TextEditingController _hypothesesDiagnostiquesController;
  late TextEditingController _diagnosticFinalController;
  String? _pdfUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _tailleController = TextEditingController(text: widget.patientRecord['informationsPersonnelles']?['taille']);
    _poidsController = TextEditingController(text: widget.patientRecord['informationsPersonnelles']?['poids']);
    _groupeSanguinController = TextEditingController(text: widget.patientRecord['informationsPersonnelles']?['groupeSanguin']);
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
    setState(() => _isUploading = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      if (result != null) {
        PlatformFile file = result.files.first;
        if (file.bytes == null) throw Exception('Le fichier ne peut pas être lu.');
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance.ref().child('examens/$fileName.pdf');
        await storageReference.putData(file.bytes!);
        String downloadURL = await storageReference.getDownloadURL();
        setState(() => _pdfUrl = downloadURL);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'upload du fichier : $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _launchPdf(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Impossible d\'ouvrir le fichier PDF')));
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
              _buildSection('Informations Personnelles', [
                _buildTextFormField('Taille', _tailleController, required: false),
                _buildTextFormField('Poids', _poidsController, required: false),
                _buildTextFormField('Groupe Sanguin', _groupeSanguinController, required: false),
              ]),
              _buildSection('Traitements Antérieurs', [
                _buildTextFormField('Médicaments précédents', _medicamentsPrecedentsController, required: false),
                _buildTextFormField('Interventions chirurgicales', _interventionsChirurgicalesController, required: false),
                _buildTextFormField('Thérapies suivies', _therapiesSuiviesController, required: false),
              ]),
              _buildSection('Antécédents', [
                _buildTextFormField('Antécédents médicaux', _antecedentsMedicauxController, required: false),
                _buildTextFormField('Antécédents chirurgicaux', _antecedentsChirurgicauxController, required: false),
                _buildTextFormField('Antécédents gynéco-obstétriques', _antecedentsGynecoObstetriquesController, required: false),
                _buildTextFormField('Antécédents familiaux', _antecedentsFamiliauxController, required: false),
              ]),
              _buildSection('Allergies', [
                _buildTextFormField('Allergies médicamenteuses', _allergiesMedicamentsController, required: false),
                _buildTextFormField('Allergies alimentaires', _allergiesAlimentairesController, required: false),
                _buildTextFormField('Réactions observées', _reactionsObserveesController, required: false),
              ]),
              _buildSection('Déparasitage', [
                _buildTextFormField('Type de traitement', _typeTraitementController, required: false),
                _buildTextFormField('Fréquence', _frequenceTraitementController, required: false),
              ]),
              _buildSection('Enquête Sociale', [
                _buildTextFormField('Situation familiale', _situationFamilialeController, required: false),
                _buildTextFormField('Profession', _professionController, required: false),
                _buildTextFormField('Habitudes alimentaires', _habitudesAlimentairesController, required: false),
              ]),
              _buildSection('Examen Physique', [
                _buildTextFormField('Nom de l\'examen', _nomExamenController, required: false),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadPdf,
                  child: _isUploading ? CircularProgressIndicator() : Text('Uploader un fichier PDF'),
                ),
                if (_pdfUrl != null)
                  InkWell(
                    onTap: () => _launchPdf(_pdfUrl!),
                    child: Text(
                      'Télécharger le résultat de l\'examen (PDF)',
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
              ]),
              _buildSection('Diagnostic', [
                _buildTextFormField('Hypothèses diagnostiques', _hypothesesDiagnostiquesController, required: false),
                _buildTextFormField('Diagnostic final', _diagnosticFinalController, required: false),
              ]),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRecord,
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        children: children,
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller, {bool required = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) return 'Veuillez remplir ce champ';
                return null;
              }
            : null,
      ),
    );
  }

  void _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      Map<String, dynamic> updatedRecord = {
        ...widget.patientRecord,
        'informationsPersonnelles': {
          ...widget.patientRecord['informationsPersonnelles'] ?? {},
          'taille': _tailleController.text.isNotEmpty ? _tailleController.text : null,
          'poids': _poidsController.text.isNotEmpty ? _poidsController.text : null,
          'groupeSanguin': _groupeSanguinController.text.isNotEmpty ? _groupeSanguinController.text : null,
          'date': currentDate,
        },
        'traitementsAnterieurs': {
          ...widget.patientRecord['traitementsAnterieurs'] ?? {},
          'medicamentsPrecedents': [
            ...widget.patientRecord['traitementsAnterieurs']?['medicamentsPrecedents'] ?? [],
            if (_medicamentsPrecedentsController.text.isNotEmpty) ..._medicamentsPrecedentsController.text.split(','),
          ],
          'interventionsChirurgicales': [
            ...widget.patientRecord['traitementsAnterieurs']?['interventionsChirurgicales'] ?? [],
            if (_interventionsChirurgicalesController.text.isNotEmpty) ..._interventionsChirurgicalesController.text.split(','),
          ],
          'therapiesSuivies': [
            ...widget.patientRecord['traitementsAnterieurs']?['therapiesSuivies'] ?? [],
            if (_therapiesSuiviesController.text.isNotEmpty) ..._therapiesSuiviesController.text.split(','),
          ],
          'date': currentDate,
        },
        'examenPhysique': {
          ...widget.patientRecord['examenPhysique'] ?? {},
          'nomExamen': _nomExamenController.text.isNotEmpty ? _nomExamenController.text : null,
          'resultatExamen': _pdfUrl,
          'date': currentDate,
        },
      };

      await widget.onSave(updatedRecord);
      Navigator.pop(context);
    }
  }
}