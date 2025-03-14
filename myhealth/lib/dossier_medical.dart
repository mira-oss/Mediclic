import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DossierMedicalForm extends StatefulWidget {
  const DossierMedicalForm({super.key});

  @override
  _DossierMedicalFormState createState() => _DossierMedicalFormState();
}

class _DossierMedicalFormState extends State<DossierMedicalForm> {
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs du formulaire
  final _poidsController = TextEditingController();
  final _groupeSanguinController = TextEditingController();
  final _tailleController = TextEditingController();
  final _contactUrgenceController = TextEditingController();

  final _maladiesPasseesController = TextEditingController();
  final _symptomesActuelsController = TextEditingController();
  final _maladiesLieesController = TextEditingController();

  final _medicamentsPrescritsController = TextEditingController();
  final _interventionsChirurgicalesController = TextEditingController();

  final _antecedentsMedicauxController = TextEditingController();
  final _antecedentsChirurgicauxController = TextEditingController();
  final _antecedentsGynecoController = TextEditingController();
  final _antecedentsFamiliauxController = TextEditingController();

  final _allergiesMedicamenteusesController = TextEditingController();
  final _reactionsObserveesController = TextEditingController();

  final _medicamentDeparasitageController = TextEditingController();
  final _doseDeparasitageController = TextEditingController();

  final _situationMatrimonialeController = TextEditingController();
  final _professionController = TextEditingController();
  bool _usageDrogues = false;

  final _nomExamenController = TextEditingController();
  String? _fichierExamenPath;

  final _hypothesesDiagnostiquesController = TextEditingController();
  final _diagnosticFinalController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _fichierExamenPath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dossier médical'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Informations générales
              const Text(
                'Informations générales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              TextFormField(
                controller: _poidsController,
                decoration: const InputDecoration(labelText: 'Poids (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _groupeSanguinController,
                decoration: const InputDecoration(labelText: 'Groupe sanguin'),
              ),
              TextFormField(
                controller: _tailleController,
                decoration: const InputDecoration(labelText: 'Taille (cm)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _contactUrgenceController,
                decoration: const InputDecoration(labelText: 'Contact en cas d\'urgence'),
              ),
              const SizedBox(height: 20),

              // Section 2: Amnèse
              const Text(
                'Amnèse',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              TextFormField(
                controller: _maladiesPasseesController,
                decoration: const InputDecoration(labelText: 'Maladies passées'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _symptomesActuelsController,
                decoration: const InputDecoration(labelText: 'Symptômes actuels'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _maladiesLieesController,
                decoration: const InputDecoration(labelText: 'Maladies liées aux symptômes'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Section 3: Traitements antérieurs
              const Text(
                'Traitements antérieurs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _medicamentsPrescritsController,
                decoration: const InputDecoration(labelText: 'Médicaments précédemment prescrits'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _interventionsChirurgicalesController,
                decoration: const InputDecoration(labelText: 'Interventions chirurgicales'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Section 4: Antécédents
              const Text(
                'Antécédents',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _antecedentsMedicauxController,
                decoration: const InputDecoration(labelText: 'Antécédents médicaux'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _antecedentsChirurgicauxController,
                decoration: const InputDecoration(labelText: 'Antécédents chirurgicaux'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _antecedentsGynecoController,
                decoration: const InputDecoration(labelText: 'Antécédents gynéco-obstétriques'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _antecedentsFamiliauxController,
                decoration: const InputDecoration(labelText: 'Antécédents familiaux'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Section 5: Allergies
              const Text(
                'Allergies',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _allergiesMedicamenteusesController,
                decoration: const InputDecoration(labelText: 'Allergies médicamenteuses'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _reactionsObserveesController,
                decoration: const InputDecoration(labelText: 'Réactions observées'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Section 6: Déparasitage
              const Text(
                'Déparasitage',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _medicamentDeparasitageController,
                decoration: const InputDecoration(labelText: 'Médicament pris'),
              ),
              TextFormField(
                controller: _doseDeparasitageController,
                decoration: const InputDecoration(labelText: 'Dose'),
              ),
              const SizedBox(height: 20),

              // Section 7: Enquête sociale
              const Text(
                'Enquête sociale',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _situationMatrimonialeController,
                decoration: const InputDecoration(labelText: 'Situation matrimoniale'),
              ),
              TextFormField(
                controller: _professionController,
                decoration: const InputDecoration(labelText: 'Profession'),
              ),
              SwitchListTile(
                title: const Text('Usage de drogues'),
                value: _usageDrogues,
                onChanged: (value) {
                  setState(() {
                    _usageDrogues = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Section 8: Examens physiques
              const Text(
                'Examens physiques',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nomExamenController,
                decoration: const InputDecoration(labelText: 'Nom de l\'examen'),
              ),
              ElevatedButton(
                onPressed: _pickFile,
                child: const Text('Télécharger le résultat de l\'examen (PDF)'),
              ),
              if (_fichierExamenPath != null)
                Text('Fichier sélectionné: $_fichierExamenPath'),
              const SizedBox(height: 20),

              // Section 9: Diagnostic
              const Text(
                'Diagnostic',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _hypothesesDiagnostiquesController,
                decoration: const InputDecoration(labelText: 'Hypothèses diagnostiques'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _diagnosticFinalController,
                decoration: const InputDecoration(labelText: 'Diagnostic final'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Bouton de soumission
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Sauvegarder les données dans Firestore
                      _sauvegarderDossierMedical();
                    }
                  },
                  child: const Text('Sauvegarder le dossier médical'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sauvegarderDossierMedical() {
    // Récupérer les données du formulaire
    final dossierMedical = {
      'informationsGenerales': {
        'poids': _poidsController.text,
        'groupeSanguin': _groupeSanguinController.text,
        'taille': _tailleController.text,
        'contactUrgence': _contactUrgenceController.text,
      },
      'amnese': {
        'maladiesPassees': _maladiesPasseesController.text,
        'symptomesActuels': _symptomesActuelsController.text,
        'maladiesLiees': _maladiesLieesController.text,
      },
      'traitementsAnterieurs': {
        'medicamentsPrescrits': _medicamentsPrescritsController.text,
        'interventionsChirurgicales': _interventionsChirurgicalesController.text,
      },
      'antecedents': {
        'medicaux': _antecedentsMedicauxController.text,
        'chirurgicaux': _antecedentsChirurgicauxController.text,
        'gynecoObstetriques': _antecedentsGynecoController.text,
        'familiaux': _antecedentsFamiliauxController.text,
      },
      'allergies': {
        'medicamenteuses': _allergiesMedicamenteusesController.text,
        'reactionsObservees': _reactionsObserveesController.text,
      },
      'deparasitage': {
        'medicament': _medicamentDeparasitageController.text,
        'dose': _doseDeparasitageController.text,
      },
      'enqueteSociale': {
        'situationMatrimoniale': _situationMatrimonialeController.text,
        'profession': _professionController.text,
        'usageDrogues': _usageDrogues,
      },
      'examensPhysiques': {
        'nomExamen': _nomExamenController.text,
        'fichierExamen': _fichierExamenPath,
      },
      'diagnostic': {
        'hypothesesDiagnostiques': _hypothesesDiagnostiquesController.text,
        'diagnosticFinal': _diagnosticFinalController.text,
      },
    };

    // Sauvegarder dans Firestore
    FirebaseFirestore.instance.collection('dossiersMedicaux').add(dossierMedical).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dossier médical sauvegardé avec succès!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sauvegarde: $error')),
      );
    });
  }
}