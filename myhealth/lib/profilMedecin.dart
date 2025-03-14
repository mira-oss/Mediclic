import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myhealth/auth/login.dart';
import 'package:myhealth/services/firestor_services.dart';

class Profilmedecin extends StatefulWidget {
  const Profilmedecin({super.key});

  @override
  State<Profilmedecin> createState() => _ProfilmedecinState();
}

class _ProfilmedecinState extends State<Profilmedecin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServices _firestoreServices = FirestoreServices();
  String username = "Non défini";
  String email = "Non défini";

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    setState(() {
     
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
       
        setState(() {
          email = user.email ?? "Non défini";
        });

       
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          setState(() {
            username = user.displayName!;
          });
        } else {
          
          DocumentSnapshot userData = await _firestoreServices.getUserById(user.uid);
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
    } finally {
      setState(() {

      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      SingleChildScrollView(
          child: SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar1.jpeg'),
                    radius: 60),
                         Text('Nom: $username'),
                        Text('Email: $email'),
                        SizedBox(height: 15),
                        Container(
                          height: 500,
                          decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)),
                              color:Color.fromARGB(255, 185, 211, 231),),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.person, size: 40),
                            title: Text('Nom: $username'),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                           ListTile(
                        leading: Icon(Icons.settings, size: 40),
                        title: Text('Parametre'),
                        trailing: Icon(Icons.arrow_forward_ios)),
                    ListTile(
                        leading: Icon(Icons.history, size: 40),
                        title: Text('Historique'),
                        trailing: Icon(Icons.arrow_forward_ios)),
                    ListTile(
                      leading: Icon(Icons.mode_night, size: 40),
                      title: Text('Mode'),
                      trailing: Icon(Icons.check_box_outline_blank_rounded),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>LoginScreen ()),
                        );
                      },
                        child: const Text('Déconnexion'),
                    ),
                    ]
                    )
                    )
                      ]
                    ))))
    ]));
  }
}