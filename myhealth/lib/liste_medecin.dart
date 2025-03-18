import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/ajout_medecin.dart';

class ListeMedecin extends StatefulWidget {
  const ListeMedecin({super.key});

  @override
  State<ListeMedecin> createState() => _ListeMedecinState();
}

class _ListeMedecinState extends State<ListeMedecin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des médecins"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where("role", isEqualTo: "medecin")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('Aucun médecin trouvé.'));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var medecin = snapshot.data!.docs[index];
                var data = medecin.data() as Map<String, dynamic>;

                // Formater la date si elle existe
                String dateCreation = '';
                if (data['createdAt'] != null) {
                  dateCreation = (data['createdAt'] as Timestamp).toDate().toString();
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nom du médecin: ${data['nom'] ?? 'Non renseigné'}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("Spécialité: ${data['specialite'] ?? 'Non renseigné'}"),
                        const SizedBox(height: 10),
                        Text("Code professionnel: ${data['codeProfessionnel'] ?? 'Non renseigné'}"),
                        const SizedBox(height: 10),
                        Text("Clinique: ${data['clinique'] ?? 'Non renseigné'}"),
                        const SizedBox(height: 10),
                        Text("Numéro: ${data['numero'] ?? 'Non renseigné'}"),
                        const SizedBox(height: 10),
                        Text("Créé le : $dateCreation"),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AjoutMedecin()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}