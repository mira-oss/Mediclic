import 'package:flutter/material.dart';
import 'package:projet_patient/Page/details_medecin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() {
    return _ConsultationPageState();
  }
}

class _ConsultationPageState extends State<ConsultationPage> {
  // Déclaration du contrôleur de texte pour le champ de recherche
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredDoctors = []; // Liste des médecins filtrés

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fonction pour récupérer les médecins depuis Firebase
  Future<List<Map<String, dynamic>>> getDoctors() async {
    List<Map<String, dynamic>> doctors = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'medecin')
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        doctors.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération des médecins : $e");
    }
    return doctors;
  }

  // Fonction de recherche
  void _searchDoctors(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredDoctors = [];
      });
      return;
    }

    getDoctors().then((doctors) {
      setState(() {
        _filteredDoctors = doctors
            .where((doctor) => (doctor['nom'] as String)
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (doctor['specialite'] as String)
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Prenez rendez-vous",
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            // Barre de recherche
            SizedBox(
              width: double.infinity,
              height: 45,
              child: TextField(
                controller: _searchController,
                onChanged: _searchDoctors, // Recherche au changement de texte
                decoration: InputDecoration(
                  labelText: 'Rechercher un spécialiste',
                  hintText: 'Rechercher un spécialiste',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  filled: false,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>( 
                future: getDoctors(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Aucun médecin trouvé.'));
                  }

                  List<Map<String, dynamic>> doctors = snapshot.data!;
                  List<Map<String, dynamic>> displayDoctors = _filteredDoctors.isNotEmpty ? _filteredDoctors : doctors;

                  return ListView.builder(
                    itemCount: displayDoctors.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> doctor = displayDoctors[index];
                      String nom = doctor['nom'] ?? 'Nom inconnu';
                      String specialite = doctor['specialite'] ?? 'Spécialité inconnue';

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsMedecin(medecin: doctor),
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 15, left: 10, right: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 221, 240, 255),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white,
                                width: 0,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 0,
                                        ),
                                        image: const DecorationImage(
                                          image: AssetImage('assets/image/docteur.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      "Dr. $nom",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      specialite,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailsMedecin(medecin: doctor),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        minimumSize: const Size(80, 35),
                                      ),
                                      child: const Text(
                                        'Informations',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
