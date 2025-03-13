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
          title: Text("Liste des medecins"),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where("role", isEqualTo: "medecin")
                  .snapshots(),
              builder: (context, snapshot) {
                print('données');
                print(snapshot.data);
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('Aucun medecin trouvé.');
                }
                return Container(
                  padding: EdgeInsets.all(5),
                  height: 700,
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var medecin = snapshot.data!.docs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Nom medecin:${medecin['username']}")
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Specialité:${medecin['specialite']}")
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                      "Code professionnel:${medecin['codeProfessionnel']}")
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text("Clinique:${medecin['clinique']}")
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [Text("Numero:${medecin['number']}")],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                      "Crée le :${medecin['dateCreation'].toDate()}")
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                );
              },
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AjoutMedecin()));
          },
          child: Icon(Icons.add),
        ));
  }
}
