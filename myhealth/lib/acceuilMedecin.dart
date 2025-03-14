import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myhealth/ajout_medecin.dart';
import 'package:myhealth/disponinit%C3%A9.dart';
import 'package:myhealth/dossier_medical.dart';
import 'package:myhealth/liste_medecin.dart';
import 'package:myhealth/profilMedecin.dart';
import 'package:myhealth/services/firestor_services.dart';

class Acceuilmedecin extends StatefulWidget {
  const Acceuilmedecin({super.key});

  @override
  State<Acceuilmedecin> createState() => _AcceuilmedecinState();
}

class _AcceuilmedecinState extends State<Acceuilmedecin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServices _firestoreServices = FirestoreServices();
  String username = "Doc";

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AcceuilmedecinContent(),
    const ListeMedecin(),
    const Disponinite(),
    const Profilmedecin(),
  ];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          setState(() {
            username = user.displayName!;
          });
        } else {
          DocumentSnapshot userData =
              await _firestoreServices.getUserById(user.uid);
          if (userData.exists && userData.data() != null) {
            Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
            if (data.containsKey('username')) {
              setState(() {
                username = data['username'];
              });
            }
          }
        }
      }
    } catch (e) {
      print("Erreur lors de la récupération des données utilisateur: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Médecins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ajouter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class AcceuilmedecinContent extends StatelessWidget {
  const AcceuilmedecinContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/images/avatar1.jpeg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Hello, Doc",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list_outlined),
                    ),
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1.7,
                children: [
                  _buildDashboardCard(
                    'Dossier Medical',
                    'assets/images/personne.jpeg',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DossierMedicalForm()),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    'Disponibilte',
                    'assets/images/panier1.png',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Disponinite()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
      String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.lightBlue[50],
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(imagePath),
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
              _buildSection(
                title: 'Informations générales',
                children: [
                  _buildTextField('Poids (kg)', _poidsController),
                  _buildTextField('Groupe sanguin', _groupeSanguinController),
                  _buildTextField('Taille (cm)', _tailleController),
                  _buildTextField('Contact en cas d\'urgence', _contactUrgenceController),
                ],
              ),

              // Section 2: Amnèse
              _buildSection(
                title: 'Amnèse',
                children: [
                  _buildTextField('Maladies passées', _maladiesPasseesController, maxLines: 3),
                  _buildTextField('Symptômes actuels', _symptomesActuelsController, maxLines: 3),
                  _buildTextField('Maladies liées aux symptômes', _maladiesLieesController, maxLines: 3),
                ],
              ),

              // Section 3: Traitements antérieurs
              _buildSection(
                title: 'Traitements antérieurs',
                children: [
                  _buildTextField('Médicaments précédemment prescrits', _medicamentsPrescritsController, maxLines: 3),
                  _buildTextField('Interventions chirurgicales', _interventionsChirurgicalesController, maxLines: 3),
                ],
              ),

              // Section 4: Antécédents
              _buildSection(
                title: 'Antécédents',
                children: [
                  _buildTextField('Antécédents médicaux', _antecedentsMedicauxController, maxLines: 3),
                  _buildTextField('Antécédents chirurgicaux', _antecedentsChirurgicauxController, maxLines: 3),
                  _buildTextField('Antécédents gynéco-obstétriques', _antecedentsGynecoController, maxLines: 3),
                  _buildTextField('Antécédents familiaux', _antecedentsFamiliauxController, maxLines: 3),
                ],
              ),

              // Section 5: Allergies
              _buildSection(
                title: 'Allergies',
                children: [
                  _buildTextField('Allergies médicamenteuses', _allergiesMedicamenteusesController, maxLines: 3),
                  _buildTextField('Réactions observées', _reactionsObserveesController, maxLines: 3),
                ],
              ),

              // Section 6: Déparasitage
              _buildSection(
                title: 'Déparasitage',
                children: [
                  _buildTextField('Médicament pris', _medicamentDeparasitageController),
                  _buildTextField('Dose', _doseDeparasitageController),
                ],
              ),

              // Section 7: Enquête sociale
              _buildSection(
                title: 'Enquête sociale',
                children: [
                  _buildTextField('Situation matrimoniale', _situationMatrimonialeController),
                  _buildTextField('Profession', _professionController),
                  SwitchListTile(
                    title: const Text('Usage de drogues'),
                    value: _usageDrogues,
                    onChanged: (value) {
                      setState(() {
                        _usageDrogues = value;
                      });
                    },
                  ),
                ],
              ),

              // Section 8: Examens physiques
              _buildSection(
                title: 'Examens physiques',
                children: [
                  _buildTextField('Nom de l\'examen', _nomExamenController),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text('Télécharger le résultat de l\'examen (PDF)'),
                  ),
                  if (_fichierExamenPath != null)
                    Text('Fichier sélectionné: $_fichierExamenPath'),
                ],
              ),

              // Section 9: Diagnostic
              _buildSection(
                title: 'Diagnostic',
                children: [
                  _buildTextField('Hypothèses diagnostiques', _hypothesesDiagnostiquesController, maxLines: 3),
                  _buildTextField('Diagnostic final', _diagnosticFinalController, maxLines: 3),
                ],
              ),

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

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: children,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        maxLines: maxLines,
      ),
    );
  }

  void _sauvegarderDossierMedical() async {
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