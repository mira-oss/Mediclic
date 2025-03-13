import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myhealth/services/firestor_services.dart';

class AjoutMedecin extends StatefulWidget {
  const AjoutMedecin({super.key});

  @override
  State<AjoutMedecin> createState() => _AjoutMedecinState();
}

class _AjoutMedecinState extends State<AjoutMedecin> {
  final TextEditingController _nomPrenomController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeProfessionnelController =
      TextEditingController();
  
  String? _specialiteSelectionnee;
  String? _cliniqueSelectionnee;

  List<String> _specialites = [];
  List<String> _cliniques = [];
//bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    try {
      final specialitesSnapshot =
          await FirebaseFirestore.instance.collection('Specialite').get();
      final specialites =
          specialitesSnapshot.docs.map((doc) => doc['nom'].toString()).toList();

      final cliniquesSnapshot =
          await FirebaseFirestore.instance.collection('Clinique').get();
      final cliniques =
          cliniquesSnapshot.docs.map((doc) => doc['nom'].toString()).toList();

      setState(() {
        _specialites = specialites;
        _cliniques = cliniques;
        //_isLoading = false;
      });
    } catch (e) {
      print("Erreur lors du chargement des données: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des données: $e')),
      );
    }
  }

  String _genererMotDePasse() {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    Random rnd = Random.secure();
    return List.generate(12, (index) => chars[rnd.nextInt(chars.length)])
        .join();
  }

  Future<void> _envoyerNotification(String token, String titre, String corps) async {
    try {
      // Remplacez cette URL par l'URL de votre propre backend ou Cloud Function
      const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
      
      // Remplacez par votre clé serveur Firebase
      final String serverKey = '';
      
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'notification': {
            'title': titre,
            'body': corps,
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'type': 'password_notification',
            'password': corps.split(': ')[1], // Pour extraire le mot de passe
          },
          'to': token,
        }),
      );

      if (response.statusCode == 200) {
        print('Notification envoyée avec succès');
      } else {
        print('Échec de l\'envoi de la notification: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la notification: $e');
    }
  }


  Future<void> _creatMedecin() async {
    if (_nomPrenomController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _codeProfessionnelController.text.isEmpty ||
        _specialiteSelectionnee == null ||
        _cliniqueSelectionnee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    final bool emailValide = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text);
    if (!emailValide) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format d\'email invalide')),
      );
      return;
    }
    final bool codeValide = RegExp(r'^\d+\/ONMB\/[A-Z]{3}\/\d{4}$')
        .hasMatch(_codeProfessionnelController.text);
    if (!codeValide) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Format du code professionnel invalide. Ex: 250/ONMB/ATL/2016')),
      );
      return;
    }

    final motDePasse = _genererMotDePasse();

    try {
      String userId = FirebaseFirestore.instance.collection('users').doc().id;
      await FirestoreServices().addMedecin(
        _nomPrenomController.text.trim(),
        _emailController.text.trim(),
        _codeProfessionnelController.text.trim(),
        _specialiteSelectionnee!,
        _cliniqueSelectionnee!,
        _numberController.text.trim(),
        motDePasse
      );

      _nomPrenomController.clear();
      _emailController.clear();
      _numberController.clear();
      _codeProfessionnelController.clear();
      setState(() {
        _specialiteSelectionnee = null;
        _cliniqueSelectionnee = null;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 221, 223, 226),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Le compte du médecin a été créé avec succes"),
                SizedBox(height: 10),
                Text(
                    "Un mot de passe temporaire a été généré et sera envoyé au médecin par notification."),
                SizedBox(height: 10),
                Text("Email: ${_emailController.text.trim()}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      Fluttertoast.showToast(
        msg: "Medecin crée avec succes!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print("Erreur lors de la création du médecin: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création du médecin: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            //height: MediaQuery.of(context).size.height * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset( "assets/images/coup-moyen-docteur-prendre-notes.png",width: 200),
                  SizedBox(height: 15),
                const Text(
                  'Ajout medecin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 32, 168, 192),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _nomPrenomController,
                  decoration: InputDecoration(
                    labelText: 'Nom et prenom du médecin',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email du médecin',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _codeProfessionnelController,
                  decoration: InputDecoration(
                    labelText: 'Code professionnel (ex: 250/ONMB/ATL/2016)',
                    hintText: 'XXX/ONMB/XXX/XXXX',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'Numero du médecin',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Sélectionner une spécialité'),
                      value: _specialiteSelectionnee,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? value) {
                        setState(() {
                          _specialiteSelectionnee = value;
                        });
                      },
                      items: _specialites
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Sélectionner une clinique'),
                      value: _cliniqueSelectionnee,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (String? value) {
                        setState(() {
                          _cliniqueSelectionnee = value;
                        });
                      },
                      items: _cliniques
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _creatMedecin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "CRÉER MÉDECIN",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
