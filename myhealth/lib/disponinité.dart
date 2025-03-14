import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Disponinite extends StatefulWidget {
  const Disponinite({super.key});

  @override
  State<Disponinite> createState() => _DisponiniteState();
}

class _DisponiniteState extends State<Disponinite> {
  final _formKey = GlobalKey<FormState>();
  final List<String> jours = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche',
  ];

  // Pour stocker les heures de début et de fin pour chaque jour
  Map<String, List<Map<String, TimeOfDay>>> disponibilites = {};
  @override
  void initState() {
    super.initState();
    // Initialiser la structure de données pour chaque jour
    for (var jour in jours) {
      disponibilites[jour] = [];
    }
  }
  Future<void> _ajouterDisponibilite(String jour) async {
    TimeOfDay? heureDebut = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    TimeOfDay? heureFin = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (heureDebut != null && heureFin != null) {
      setState(() {
        disponibilites[jour]!.add({
          'debut': heureDebut,
          'fin': heureFin,
        });
      });
    }
  }

  Future<void> _sauvegarderDisponibilites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final batch = FirebaseFirestore.instance.batch();

    for (var jour in jours) {
      if (disponibilites[jour]!.isNotEmpty) {
        final heures = disponibilites[jour]!.map((creneau) {
          return '${creneau['debut']!.format(context)}-${creneau['fin']!.format(context)}';
        }).toList();

        // Ajouter l'ID du médecin (medecinId) dans le document
        batch.set(
          FirebaseFirestore.instance.collection('disponibilites').doc(),
          {
            'medecinId': user.uid, // ID du médecin
            'jour': jour,
            'heures': heures,
          },
        );
      }
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disponibilités sauvegardées avec succès!')),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disponibilités'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: jours.map((jour) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text(jour),
                  children: [
                    ...disponibilites[jour]!.map((creneau) {
                      return ListTile(
                        title: Text(
                          '${creneau['debut']!.format(context)} - ${creneau['fin']!.format(context)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              disponibilites[jour]!.remove(creneau);
                            });
                          },
                        ),
                      );
                    }).toList(),
                    TextButton(
                      onPressed: () => _ajouterDisponibilite(jour),
                      child: const Text('Ajouter un créneau'),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sauvegarderDisponibilites,
        child: const Icon(Icons.save),
      ),
    );
  }
}
