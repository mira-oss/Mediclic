import 'package:flutter/material.dart';
import 'package:projet_patient/Page/details_medecin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultationPage extends StatefulWidget{
  const ConsultationPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
  }

  class _HomePageState extends State {
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

    @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Prener rendez-vous", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800, fontSize: 25),),
          ),
          body: Container(
            padding: EdgeInsets.only(top: 15, left: 20, right: 20 ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                        width: double.infinity, // Largeur du TextField
                        height: 45, // Hauteur du TextField
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Rechercher un spécialiste', // Label
                            hintText: 'Rechercher un spécialiste',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                            ), // Hint text
                            prefixIcon: Icon(Icons.search, color: Colors.grey), // Icône de préfixe (recherche)
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)), // Bordure arrondie
                              borderSide: BorderSide(
                                color: Colors.grey, // Couleur de la bordure
                                width: 0.5, // Taille de la bordure
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Colors.blue, // Couleur de la bordure lorsqu'en focus
                                width: 2,
                              ),
                            ),
                            filled: false, // Pas de fond
                          ),
                        ),
                      ),
                  SizedBox(height: 20,),
                  FutureBuilder<List<Map<String, dynamic>>>(
        future: getDoctors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun médecin trouvé.'));
          } else {
            List<Map<String, dynamic>> doctors = snapshot.data!;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> doctor = doctors[index];
                String nom = doctor['username'] ?? 'Nom inconnu';
                //Remplacer specialite par number si number est la spécialité.
                //String specialite = doctor['specialite'] ?? 'Spécialité inconnue';
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
      MaterialPageRoute(builder: (context) => DetailsMedecin()),
    );
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 15, left: 10, right: 5),
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
                                width: 140,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 0,
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage('assets/image/docteur.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "Dr. $nom",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    specialite,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // Naviguer vers les détails du médecin
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: Size(80, 35),
                                ),
                                child: Text(
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
          }
        },
      ),


                ],
              ),
            ),
          ),
      ),
    );
  }
  }